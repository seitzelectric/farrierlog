import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

import 'database_service.dart';
import 'invoice_service.dart';

class BackupService {
  static const int formatVersion = 2;

  static Future<File> createBackup() async {
    final db = await DatabaseService.database;
    final now = DateTime.now().toUtc();
    final stamp = now.toIso8601String().replaceAll(':', '').split('.').first;
    final temp = await getTemporaryDirectory();
    final workDir = Directory(p.join(temp.path, 'farrierlog_backup_$stamp'));

    if (await workDir.exists()) {
      await workDir.delete(recursive: true);
    }
    await workDir.create(recursive: true);

    try {
      await _validateDatabase(db);

      final backupDbPath = p.join(workDir.path, 'farrier_log.sqlite');
      await db.execute('VACUUM INTO ?', [backupDbPath]);

      final backupDb = await openDatabase(backupDbPath);
      final media = await _copyMediaIntoBackup(backupDb, workDir);
      await backupDb.close();

      final tableCounts = await _tableCounts(db);
      final manifest = <String, dynamic>{
        'format': 'com.farrierlog.backup',
        'format_version': formatVersion,
        'database_schema_version': DatabaseService.databaseVersion,
        'created_at': now.toIso8601String(),
        'includes': {
          'database': true,
          'photos': media.photoCount > 0,
          'invoice_pdfs': media.invoiceCount > 0,
          'company_logo': media.logoIncluded,
        },
        'counts': tableCounts,
        'missing_media': media.missing,
      };

      final archive = Archive();
      _addBytes(
        archive,
        'manifest.json',
        utf8.encode(const JsonEncoder.withIndent('  ').convert(manifest)),
      );
      await _addFile(archive, File(backupDbPath), 'data/farrier_log.sqlite');
      await _addDirectoryFiles(
          archive, Directory(p.join(workDir.path, 'media')));

      final zipBytes = ZipEncoder().encode(archive);

      final file =
          File(p.join(temp.path, 'FarrierLog-backup-$stamp.flbackup.zip'));
      await file.writeAsBytes(zipBytes, flush: true);
      return file;
    } finally {
      if (await workDir.exists()) {
        await workDir.delete(recursive: true);
      }
    }
  }

  static Future<void> shareBackup(File file) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: 'FarrierLog Backup',
        text: 'FarrierLog full backup',
      ),
    );
  }

  static Future<void> restoreBackup(File file) async {
    final temp = await getTemporaryDirectory();
    final stamp = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    final restoreDir =
        Directory(p.join(temp.path, 'farrierlog_restore_$stamp'));

    if (await restoreDir.exists()) {
      await restoreDir.delete(recursive: true);
    }
    await restoreDir.create(recursive: true);

    try {
      final bytes = await file.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);
      _extractArchive(archive, restoreDir);

      final manifest = await _readManifest(restoreDir);
      _validateManifest(manifest);

      final restoredDbFile =
          File(p.join(restoreDir.path, 'data', 'farrier_log.sqlite'));
      if (!await restoredDbFile.exists()) {
        throw const BackupException(
            'Backup is missing data/farrier_log.sqlite.');
      }

      final restoredDb = await openDatabase(restoredDbFile.path);
      try {
        await _validateDatabase(restoredDb);
        await _restoreMediaAndRewritePaths(restoredDb, restoreDir, stamp);
        await _validateDatabase(restoredDb);
      } finally {
        await restoredDb.close();
      }

      await DatabaseService.close();

      final liveDb = File(await DatabaseService.databasePath);
      final rollbackDb = File('${liveDb.path}.pre_restore');
      final hadLiveDb = await liveDb.exists();

      if (await rollbackDb.exists()) {
        await rollbackDb.delete();
      }

      try {
        if (hadLiveDb) {
          await liveDb.rename(rollbackDb.path);
        }

        await restoredDbFile.copy(liveDb.path);
        await DatabaseService.database;
        await InvoiceService.loadCompanyInfo();

        if (await rollbackDb.exists()) {
          await rollbackDb.delete();
        }
      } catch (_) {
        await DatabaseService.close();
        if (await liveDb.exists()) {
          await liveDb.delete();
        }
        if (await rollbackDb.exists()) {
          await rollbackDb.rename(liveDb.path);
        }
        await DatabaseService.database;
        rethrow;
      }
    } finally {
      if (await restoreDir.exists()) {
        await restoreDir.delete(recursive: true);
      }
    }
  }

  static Future<void> _validateDatabase(Database db) async {
    final integrity = await db.rawQuery('PRAGMA integrity_check');
    final integrityValue = integrity.first.values.first?.toString();
    if (integrityValue != 'ok') {
      throw BackupException('Database integrity check failed: $integrityValue');
    }

    final foreignKeys = await db.rawQuery('PRAGMA foreign_key_check');
    if (foreignKeys.isNotEmpty) {
      throw const BackupException('Database foreign key check failed.');
    }

    const requiredTables = {
      'clients',
      'horses',
      'visits',
      'visit_horses',
      'service_lines',
      'visit_photos',
      'invoices',
      'app_settings',
    };
    final rows = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'table'",
    );
    final tables = rows.map((row) => row['name'] as String).toSet();
    final missing = requiredTables.difference(tables);
    if (missing.isNotEmpty) {
      throw BackupException(
          'Backup is missing required tables: ${missing.join(', ')}');
    }
  }

  static Future<Map<String, int>> _tableCounts(Database db) async {
    const tables = [
      'clients',
      'horses',
      'visits',
      'visit_horses',
      'service_lines',
      'visit_charges',
      'visit_photos',
      'invoices',
      'app_settings',
    ];
    final counts = <String, int>{};
    for (final table in tables) {
      counts[table] = Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM $table'),
          ) ??
          0;
    }
    return counts;
  }

  static Future<_MediaCopyResult> _copyMediaIntoBackup(
    Database db,
    Directory workDir,
  ) async {
    final result = _MediaCopyResult();

    final photoRows = await db.query('visit_photos', orderBy: 'id ASC');
    for (final row in photoRows) {
      final id = row['id'] as int;
      final originalPath = row['path'] as String? ?? '';
      final relativePath = p.join(
        'media',
        'photos',
        'visit_photos',
        'photo_${id.toString().padLeft(6, '0')}${p.extension(originalPath)}',
      );
      if (await _copyIfExists(originalPath, workDir, relativePath)) {
        await db.update(
          'visit_photos',
          {'path': relativePath},
          where: 'id = ?',
          whereArgs: [id],
        );
        result.photoCount++;
      } else if (originalPath.isNotEmpty) {
        result.missing.add(originalPath);
      }
    }

    final invoiceRows = await db.query('invoices', orderBy: 'id ASC');
    for (final row in invoiceRows) {
      final id = row['id'] as int;
      final originalPath = row['file_path'] as String? ?? '';
      final fileName = (row['file_name'] as String?)?.trim().isNotEmpty == true
          ? row['file_name'] as String
          : 'invoice_${id.toString().padLeft(6, '0')}.pdf';
      final issuedAt = DateTime.tryParse(row['issued_at'] as String? ?? '');
      final relativePath = p.join(
        'media',
        'invoices',
        (issuedAt?.year ?? DateTime.now().year).toString(),
        fileName,
      );
      if (await _copyIfExists(originalPath, workDir, relativePath)) {
        await db.update(
          'invoices',
          {'file_path': relativePath, 'file_name': fileName},
          where: 'id = ?',
          whereArgs: [id],
        );
        result.invoiceCount++;
      } else if (originalPath.isNotEmpty) {
        result.missing.add(originalPath);
      }
    }

    final logoRows = await db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: ['company_logo'],
      limit: 1,
    );
    if (logoRows.isNotEmpty) {
      final originalPath = logoRows.first['value'] as String? ?? '';
      final relativePath = p.join(
        'media',
        'logos',
        'company_logo${p.extension(originalPath)}',
      );
      if (await _copyIfExists(originalPath, workDir, relativePath)) {
        await db.insert(
          'app_settings',
          {'key': 'company_logo', 'value': relativePath},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        result.logoIncluded = true;
      } else if (originalPath.isNotEmpty) {
        result.missing.add(originalPath);
      }
    }

    return result;
  }

  static Future<bool> _copyIfExists(
    String sourcePath,
    Directory root,
    String relativePath,
  ) async {
    if (sourcePath.isEmpty) return false;
    final source = File(sourcePath);
    if (!await source.exists()) return false;

    final target = File(p.join(root.path, relativePath));
    await target.parent.create(recursive: true);
    await source.copy(target.path);
    return true;
  }

  static Future<void> _restoreMediaAndRewritePaths(
    Database db,
    Directory restoreDir,
    String restoreId,
  ) async {
    final documents = await getApplicationDocumentsDirectory();
    final mediaRoot = Directory(
      p.join(documents.path, 'restored_backups', restoreId),
    );

    final photoRows = await db.query('visit_photos', orderBy: 'id ASC');
    for (final row in photoRows) {
      final id = row['id'] as int;
      final relativePath = row['path'] as String? ?? '';
      final restored =
          await _restoreMediaFile(restoreDir, mediaRoot, relativePath);
      if (restored != null) {
        await db.update(
          'visit_photos',
          {'path': restored.path},
          where: 'id = ?',
          whereArgs: [id],
        );
      }
    }

    final invoiceRows = await db.query('invoices', orderBy: 'id ASC');
    for (final row in invoiceRows) {
      final id = row['id'] as int;
      final relativePath = row['file_path'] as String? ?? '';
      final restored =
          await _restoreMediaFile(restoreDir, mediaRoot, relativePath);
      if (restored != null) {
        await db.update(
          'invoices',
          {'file_path': restored.path},
          where: 'id = ?',
          whereArgs: [id],
        );
      }
    }

    final logoPath = await _settingValue(db, 'company_logo');
    final restoredLogo =
        await _restoreMediaFile(restoreDir, mediaRoot, logoPath);
    if (restoredLogo != null) {
      await db.insert(
        'app_settings',
        {'key': 'company_logo', 'value': restoredLogo.path},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<File?> _restoreMediaFile(
    Directory restoreDir,
    Directory mediaRoot,
    String relativePath,
  ) async {
    if (relativePath.isEmpty || p.isAbsolute(relativePath)) return null;
    final source = File(p.join(restoreDir.path, relativePath));
    if (!await source.exists()) {
      throw BackupException('Backup is missing media file: $relativePath');
    }

    final target = File(p.join(mediaRoot.path, relativePath));
    await target.parent.create(recursive: true);
    await source.copy(target.path);
    return target;
  }

  static Future<String> _settingValue(Database db, String key) async {
    final rows = await db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    return rows.isEmpty ? '' : rows.first['value'] as String? ?? '';
  }

  static Future<Map<String, dynamic>> _readManifest(
      Directory restoreDir) async {
    final file = File(p.join(restoreDir.path, 'manifest.json'));
    if (!await file.exists()) {
      throw const BackupException('Backup is missing manifest.json.');
    }

    final decoded = jsonDecode(await file.readAsString());
    if (decoded is! Map<String, dynamic>) {
      throw const BackupException('Backup manifest is invalid.');
    }
    return decoded;
  }

  static void _validateManifest(Map<String, dynamic> manifest) {
    if (manifest['format'] != 'com.farrierlog.backup') {
      throw const BackupException('This is not a FarrierLog backup.');
    }
    final version = manifest['format_version'];
    if (version is! int || version > formatVersion) {
      throw BackupException('Unsupported backup format version: $version');
    }
  }

  static void _extractArchive(Archive archive, Directory restoreDir) {
    for (final entry in archive.files) {
      final normalized = p.normalize(entry.name);
      if (p.isAbsolute(normalized) || normalized.startsWith('..')) {
        throw const BackupException('Backup contains an unsafe file path.');
      }

      final outputPath = p.join(restoreDir.path, normalized);
      if (entry.isFile) {
        final file = File(outputPath);
        file.parent.createSync(recursive: true);
        file.writeAsBytesSync(entry.content, flush: true);
      } else {
        Directory(outputPath).createSync(recursive: true);
      }
    }
  }

  static Future<void> _addFile(
    Archive archive,
    File file,
    String archivePath,
  ) async {
    final bytes = await file.readAsBytes();
    _addBytes(archive, archivePath, bytes);
  }

  static Future<void> _addDirectoryFiles(
      Archive archive, Directory directory) async {
    if (!await directory.exists()) return;

    await for (final entity in directory.list(recursive: true)) {
      if (entity is! File) continue;
      final relative = p.relative(entity.path, from: directory.parent.path);
      await _addFile(archive, entity, relative);
    }
  }

  static void _addBytes(Archive archive, String path, List<int> bytes) {
    archive.addFile(ArchiveFile(path, bytes.length, bytes));
  }
}

class BackupException implements Exception {
  final String message;

  const BackupException(this.message);

  @override
  String toString() => message;
}

class _MediaCopyResult {
  int photoCount = 0;
  int invoiceCount = 0;
  bool logoIncluded = false;
  final List<String> missing = [];
}
