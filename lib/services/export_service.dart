import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

import 'database_service.dart';

class ExportService {
  static Future<File> exportCsvZip() async {
    final db = await DatabaseService.database;
    final exportDate = _dateOnly(DateTime.now().toIso8601String());
    final archive = Archive();

    final files = <String, List<List<String>>>{
      'clients.csv': await _clientsRows(db),
      'animals.csv': await _animalsRows(db),
      'visits.csv': await _visitsRows(db),
      'service_lines.csv': await _serviceLineRows(db),
      'invoice_summary.csv': await _invoiceSummaryRows(db),
    };

    for (final entry in files.entries) {
      final bytes = utf8.encode(_toCsv(entry.value));
      archive.addFile(ArchiveFile(entry.key, bytes.length, bytes));
    }

    final zipBytes = ZipEncoder().encode(archive);

    final directory = await getTemporaryDirectory();
    final file = File(
      p.join(directory.path, 'farrierlog_export_$exportDate.zip'),
    );
    await file.writeAsBytes(zipBytes, flush: true);
    return file;
  }

  static Future<void> shareCsvZip(File file) async {
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'FarrierLog CSV Export',
      text: 'FarrierLog CSV export',
    );
  }

  static Future<List<List<String>>> _clientsRows(Database db) async {
    final rows = await db.query(
      'clients',
      orderBy: 'last_name COLLATE NOCASE, first_name COLLATE NOCASE',
    );

    return [
      [
        'client_id',
        'first_name',
        'last_name',
        'full_name',
        'phone',
        'email',
        'address',
        'notes',
        'created_at',
        'updated_at',
      ],
      ...rows.map((row) {
        final firstName = _value(row['first_name']);
        final lastName = _value(row['last_name']);
        return [
          _value(row['id']),
          firstName,
          lastName,
          '$firstName $lastName'.trim(),
          _value(row['phone']),
          _value(row['email']),
          _value(row['address']),
          _value(row['notes']),
          _value(row['created_at']),
          _value(row['updated_at']),
        ];
      }),
    ];
  }

  static Future<List<List<String>>> _animalsRows(Database db) async {
    final rows = await db.rawQuery('''
      SELECT horses.*, clients.first_name, clients.last_name
      FROM horses
      INNER JOIN clients ON clients.id = horses.client_id
      ORDER BY clients.last_name COLLATE NOCASE,
               clients.first_name COLLATE NOCASE,
               horses.name COLLATE NOCASE
    ''');

    return [
      [
        'animal_id',
        'client_id',
        'client_name',
        'name',
        'species',
        'description',
        'notes',
        'created_at',
      ],
      ...rows.map((row) {
        final firstName = _value(row['first_name']);
        final lastName = _value(row['last_name']);
        return [
          _value(row['id']),
          _value(row['client_id']),
          '$firstName $lastName'.trim(),
          _value(row['name']),
          _value(row['breed']),
          _value(row['color']),
          _value(row['notes']),
          _value(row['created_at']),
        ];
      }),
    ];
  }

  static Future<List<List<String>>> _visitsRows(Database db) async {
    final rows = await db.rawQuery('''
      SELECT visits.*,
             clients.first_name,
             clients.last_name,
             COALESCE(SUM(service_lines.price * service_lines.quantity), 0) AS total
      FROM visits
      INNER JOIN clients ON clients.id = visits.client_id
      LEFT JOIN service_lines ON service_lines.visit_id = visits.id
      GROUP BY visits.id
      ORDER BY visits.datetime ASC
    ''');

    return [
      [
        'visit_id',
        'client_id',
        'client_name',
        'visit_date',
        'visit_datetime',
        'paid',
        'notes',
        'total',
        'created_at',
      ],
      ...rows.map((row) {
        final firstName = _value(row['first_name']);
        final lastName = _value(row['last_name']);
        final datetime = _value(row['datetime']);
        return [
          _value(row['id']),
          _value(row['client_id']),
          '$firstName $lastName'.trim(),
          _dateOnly(datetime),
          datetime,
          _bool(row['paid']),
          _value(row['notes']),
          _money(row['total']),
          _value(row['created_at']),
        ];
      }),
    ];
  }

  static Future<List<List<String>>> _serviceLineRows(Database db) async {
    final rows = await db.rawQuery('''
      SELECT service_lines.*,
             visits.client_id,
             visits.datetime,
             clients.first_name,
             clients.last_name,
             COALESCE(horses.name, 'General') AS animal_name
      FROM service_lines
      INNER JOIN visits ON visits.id = service_lines.visit_id
      INNER JOIN clients ON clients.id = visits.client_id
      LEFT JOIN horses ON horses.id = service_lines.horse_id
      ORDER BY visits.datetime ASC, service_lines.id ASC
    ''');

    return [
      [
        'service_line_id',
        'visit_id',
        'visit_date',
        'client_id',
        'client_name',
        'animal_id',
        'animal_name',
        'description',
        'price',
        'quantity',
        'is_group',
        'group_label',
        'total',
        'created_at',
      ],
      ...rows.map((row) {
        final firstName = _value(row['first_name']);
        final lastName = _value(row['last_name']);
        final price = (row['price'] as num?)?.toDouble() ?? 0;
        final quantity = (row['quantity'] as num?)?.toInt() ?? 1;
        return [
          _value(row['id']),
          _value(row['visit_id']),
          _dateOnly(_value(row['datetime'])),
          _value(row['client_id']),
          '$firstName $lastName'.trim(),
          _value(row['horse_id']),
          _value(row['animal_name']),
          _value(row['description']),
          _money(row['price']),
          _value(quantity),
          _bool(row['is_group']),
          _value(row['group_label']),
          (price * quantity).toStringAsFixed(2),
          _value(row['created_at']),
        ];
      }),
    ];
  }

  static Future<List<List<String>>> _invoiceSummaryRows(Database db) async {
    final rows = await db.rawQuery('''
      SELECT invoices.*,
             visits.client_id,
             visits.datetime,
             visits.paid,
             clients.first_name,
             clients.last_name
      FROM invoices
      INNER JOIN visits ON visits.id = invoices.visit_id
      INNER JOIN clients ON clients.id = visits.client_id
      ORDER BY invoices.issued_at ASC, invoices.invoice_number ASC
    ''');

    return [
      [
        'invoice_id',
        'invoice_number',
        'visit_id',
        'client_id',
        'client_name',
        'visit_date',
        'issued_at',
        'paid_at',
        'paid',
        'total',
        'file_name',
      ],
      ...rows.map((row) {
        final firstName = _value(row['first_name']);
        final lastName = _value(row['last_name']);
        return [
          _value(row['id']),
          _value(row['invoice_number']),
          _value(row['visit_id']),
          _value(row['client_id']),
          '$firstName $lastName'.trim(),
          _dateOnly(_value(row['datetime'])),
          _value(row['issued_at']),
          _value(row['paid_at']),
          _bool(row['paid']),
          _money(row['total']),
          _value(row['file_name']),
        ];
      }),
    ];
  }

  static String _toCsv(List<List<String>> rows) =>
      rows.map((row) => row.map(_csvCell).join(',')).join('\r\n');

  static String _csvCell(String value) {
    final escaped = value.replaceAll('"', '""');
    if (escaped.contains(',') ||
        escaped.contains('"') ||
        escaped.contains('\n') ||
        escaped.contains('\r')) {
      return '"$escaped"';
    }
    return escaped;
  }

  static String _value(Object? value) => value?.toString() ?? '';

  static String _bool(Object? value) => value == 1 ? 'true' : 'false';

  static String _dateOnly(String value) {
    if (value.isEmpty) return '';
    final parsed = DateTime.tryParse(value);
    return parsed?.toIso8601String().split('T').first ?? value.split('T').first;
  }

  static String _money(Object? value) {
    if (value == null) return '0.00';
    if (value is num) return value.toDouble().toStringAsFixed(2);
    return (double.tryParse(value.toString()) ?? 0).toStringAsFixed(2);
  }
}
