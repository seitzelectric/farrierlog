import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import '../models/models.dart';

class DatabaseService {
  static Database? _db;
  static const String _dbName = 'farrier_log_v2.db';
  static const int _dbVersion = 5;

  static Future<Database> get database async {
    if (_db != null) return _db!;

    final path = p.join(await getDatabasesPath(), _dbName);

    _db = await openDatabase(
      path,
      version: _dbVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onOpen: (db) async {
        await db.execute('''
    CREATE TABLE IF NOT EXISTS app_settings(
      key TEXT PRIMARY KEY,
      value TEXT NOT NULL DEFAULT ''
    )
  ''');
      },
    );

    return _db!;
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE clients(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        first_name TEXT NOT NULL DEFAULT '',
        last_name TEXT NOT NULL DEFAULT '',
        phone TEXT NOT NULL DEFAULT '',
        email TEXT NOT NULL DEFAULT '',
        address TEXT NOT NULL DEFAULT '',
        notes TEXT NOT NULL DEFAULT '',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE horses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        client_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        breed TEXT NOT NULL DEFAULT '',
        color TEXT NOT NULL DEFAULT '',
        notes TEXT NOT NULL DEFAULT '',
        created_at TEXT NOT NULL,
        FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE visits(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        client_id INTEGER NOT NULL,
        datetime TEXT NOT NULL,
        notes TEXT NOT NULL DEFAULT '',
        paid INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE visit_horses(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        visit_id INTEGER NOT NULL,
        horse_id INTEGER NOT NULL,
        FOREIGN KEY (visit_id) REFERENCES visits(id) ON DELETE CASCADE,
        FOREIGN KEY (horse_id) REFERENCES horses(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE service_lines(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        visit_id INTEGER NOT NULL,
        horse_id INTEGER,
        description TEXT NOT NULL,
        price REAL NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        FOREIGN KEY (visit_id) REFERENCES visits(id) ON DELETE CASCADE,
        FOREIGN KEY (horse_id) REFERENCES horses(id) ON DELETE SET NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE visit_photos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        visit_id INTEGER NOT NULL,
        horse_id INTEGER,
        path TEXT NOT NULL,
        caption TEXT NOT NULL DEFAULT '',
        include_on_invoice INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        FOREIGN KEY (visit_id) REFERENCES visits(id) ON DELETE CASCADE,
        FOREIGN KEY (horse_id) REFERENCES horses(id) ON DELETE SET NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE invoices(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        visit_id INTEGER NOT NULL UNIQUE,
        invoice_number TEXT NOT NULL UNIQUE,
        issued_at TEXT NOT NULL,
        paid_at TEXT,
        total REAL NOT NULL DEFAULT 0,
        file_path TEXT NOT NULL DEFAULT '',
        file_name TEXT NOT NULL DEFAULT '',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (visit_id) REFERENCES visits(id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for performance
    await db.execute('CREATE INDEX idx_horses_client ON horses(client_id)');
    await db.execute('CREATE INDEX idx_visits_client ON visits(client_id)');
    await db.execute('CREATE INDEX idx_visits_datetime ON visits(datetime)');
    await db.execute(
        'CREATE INDEX idx_service_lines_visit ON service_lines(visit_id)');
    await db.execute(
        'CREATE INDEX idx_visit_photos_visit ON visit_photos(visit_id)');
    await db.execute('CREATE INDEX idx_invoices_visit ON invoices(visit_id)');
    await db
        .execute('CREATE INDEX idx_invoices_issued_at ON invoices(issued_at)');
  }

  static Future<void> _onUpgrade(
    Database db,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await db.execute(
          "ALTER TABLE horses ADD COLUMN breed TEXT NOT NULL DEFAULT ''");
      await db.execute(
          "ALTER TABLE horses ADD COLUMN color TEXT NOT NULL DEFAULT ''");
      await db.execute(
          "ALTER TABLE clients ADD COLUMN created_at TEXT NOT NULL DEFAULT ''");
      await db.execute(
          "ALTER TABLE clients ADD COLUMN updated_at TEXT NOT NULL DEFAULT ''");
    }

    if (oldVersion < 3) {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS app_settings(
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL DEFAULT ''
      )
    ''');
    }

    if (oldVersion < 5) {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS invoices(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        visit_id INTEGER NOT NULL UNIQUE,
        invoice_number TEXT NOT NULL UNIQUE,
        issued_at TEXT NOT NULL,
        paid_at TEXT,
        total REAL NOT NULL DEFAULT 0,
        file_path TEXT NOT NULL DEFAULT '',
        file_name TEXT NOT NULL DEFAULT '',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (visit_id) REFERENCES visits(id) ON DELETE CASCADE
      )
    ''');
      await db.execute(
          'CREATE INDEX IF NOT EXISTS idx_invoices_visit ON invoices(visit_id)');
      await db.execute(
          'CREATE INDEX IF NOT EXISTS idx_invoices_issued_at ON invoices(issued_at)');
    }
  }

  // ==================== CLIENT OPERATIONS ====================

  static Future<int> insertClient(Client client) async {
    final db = await database;
    return await db.insert('clients', client.toMap());
  }

  static Future<int> updateClient(Client client) async {
    final db = await database;
    return await db.update(
      'clients',
      client.toMap(),
      where: 'id = ?',
      whereArgs: [client.id],
    );
  }

  static Future<int> deleteClient(int id) async {
    final db = await database;
    // Delete associated photos from storage
    final photos = await getPhotosForClient(id);
    for (final photo in photos) {
      final file = File(photo.path);
      if (await file.exists()) await file.delete();
    }
    return await db.delete('clients', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Client>> getClients({String? searchQuery}) async {
    final db = await database;
    String? where;
    List<dynamic>? whereArgs;

    if (searchQuery != null && searchQuery.isNotEmpty) {
      where =
          'first_name LIKE ? OR last_name LIKE ? OR phone LIKE ? OR email LIKE ? OR address LIKE ?';
      final query = '%$searchQuery%';
      whereArgs = [query, query, query, query, query];
    }

    final rows = await db.query(
      'clients',
      where: where,
      whereArgs: whereArgs,
      orderBy: 'last_name COLLATE NOCASE, first_name COLLATE NOCASE',
    );
    return rows.map((r) => Client.fromMap(r)).toList();
  }

  static Future<Client?> getClient(int id) async {
    final db = await database;
    final rows = await db.query('clients', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return Client.fromMap(rows.first);
  }

  // ==================== HORSE OPERATIONS ====================

  static Future<int> insertHorse(Horse horse) async {
    final db = await database;
    return await db.insert('horses', horse.toMap());
  }

  static Future<int> updateHorse(Horse horse) async {
    final db = await database;
    return await db.update(
      'horses',
      horse.toMap(),
      where: 'id = ?',
      whereArgs: [horse.id],
    );
  }

  static Future<int> deleteHorse(int id) async {
    final db = await database;
    return await db.delete('horses', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Horse>> getHorsesForClient(int clientId) async {
    final db = await database;
    final rows = await db.query(
      'horses',
      where: 'client_id = ?',
      whereArgs: [clientId],
      orderBy: 'name COLLATE NOCASE',
    );
    return rows.map((r) => Horse.fromMap(r)).toList();
  }

  static Future<List<Horse>> getHorsesForVisit(int visitId) async {
    final db = await database;
    final rows = await db.rawQuery('''
      SELECT horses.* FROM horses
      INNER JOIN visit_horses ON visit_horses.horse_id = horses.id
      WHERE visit_horses.visit_id = ?
      ORDER BY horses.name COLLATE NOCASE
    ''', [visitId]);
    return rows.map((r) => Horse.fromMap(r)).toList();
  }

  // ==================== VISIT OPERATIONS ====================

  static Future<int> insertVisit(Visit visit, List<int> horseIds) async {
    final db = await database;
    final visitId = await db.insert('visits', visit.toMap());
    for (final horseId in horseIds) {
      await db.insert('visit_horses', {
        'visit_id': visitId,
        'horse_id': horseId,
      });
    }
    return visitId;
  }

  static Future<int> updateVisit(Visit visit, List<int> horseIds) async {
    final db = await database;
    // Update visit record
    await db.update(
      'visits',
      visit.toMap(),
      where: 'id = ?',
      whereArgs: [visit.id],
    );
    // Update horse associations
    await db
        .delete('visit_horses', where: 'visit_id = ?', whereArgs: [visit.id]);
    for (final horseId in horseIds) {
      await db.insert('visit_horses', {
        'visit_id': visit.id,
        'horse_id': horseId,
      });
    }
    return visit.id!;
  }

  static Future<int> deleteVisit(int id) async {
    final db = await database;
    // Delete associated photos
    final photos = await getPhotos(id);
    for (final photo in photos) {
      final file = File(photo.path);
      if (await file.exists()) await file.delete();
    }
    return await db.delete('visits', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Visit>> getVisits({DateTime? from, DateTime? to}) async {
    final db = await database;
    final conditions = <String>[];
    final args = <dynamic>[];

    if (from != null) {
      conditions.add('visits.datetime >= ?');
      args.add(from.toIso8601String());
    }
    if (to != null) {
      conditions.add('visits.datetime <= ?');
      args.add(to.toIso8601String());
    }

    final where =
        conditions.isNotEmpty ? 'WHERE ${conditions.join(' AND ')}' : '';

    final rows = await db.rawQuery('''
      SELECT visits.*, clients.first_name, clients.last_name
      FROM visits
      INNER JOIN clients ON clients.id = visits.client_id
      $where
      ORDER BY visits.datetime ASC
    ''', args);
    return rows.map((r) => Visit.fromMap(r)).toList();
  }

  static Future<List<Visit>> getVisitsForClient(int clientId) async {
    final db = await database;
    final rows = await db.rawQuery('''
      SELECT visits.*, clients.first_name, clients.last_name
      FROM visits
      INNER JOIN clients ON clients.id = visits.client_id
      WHERE visits.client_id = ?
      ORDER BY visits.datetime DESC
    ''', [clientId]);
    return rows.map((r) => Visit.fromMap(r)).toList();
  }

  static Future<Visit?> getVisit(int id) async {
    final db = await database;
    final rows = await db.rawQuery('''
      SELECT visits.*, clients.first_name, clients.last_name
      FROM visits
      INNER JOIN clients ON clients.id = visits.client_id
      WHERE visits.id = ?
    ''', [id]);
    if (rows.isEmpty) return null;
    return Visit.fromMap(rows.first);
  }

  static Future<void> setVisitPaid(int visitId, bool paid) async {
    final db = await database;
    await db.update(
      'visits',
      {'paid': paid ? 1 : 0},
      where: 'id = ?',
      whereArgs: [visitId],
    );
  }

  // ==================== SERVICE LINE OPERATIONS ====================

  static Future<int> insertServiceLine(ServiceLine line) async {
    final db = await database;
    return await db.insert('service_lines', line.toMap());
  }

  static Future<int> updateServiceLine(ServiceLine line) async {
    final db = await database;
    return await db.update(
      'service_lines',
      line.toMap(),
      where: 'id = ?',
      whereArgs: [line.id],
    );
  }

  static Future<int> deleteServiceLine(int id) async {
    final db = await database;
    return await db.delete('service_lines', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<ServiceLine>> getServiceLines(int visitId) async {
    final db = await database;
    final rows = await db.rawQuery('''
  SELECT 
    service_lines.*, 
    COALESCE(horses.name, 'General') AS horse_name,
    COALESCE(horses.breed, '') AS horse_breed,
    COALESCE(horses.color, '') AS horse_color
  FROM service_lines
  LEFT JOIN horses ON horses.id = service_lines.horse_id
  WHERE service_lines.visit_id = ?
  ORDER BY service_lines.id
''', [visitId]);
    return rows.map((r) => ServiceLine.fromMap(r)).toList();
  }

  // ==================== PHOTO OPERATIONS ====================

  static Future<int> insertPhoto(VisitPhoto photo) async {
    final db = await database;
    return await db.insert('visit_photos', photo.toMap());
  }

  static Future<int> updatePhoto(VisitPhoto photo) async {
    final db = await database;
    return await db.update(
      'visit_photos',
      photo.toMap(),
      where: 'id = ?',
      whereArgs: [photo.id],
    );
  }

  static Future<int> deletePhoto(int id) async {
    final db = await database;
    final photos =
        await db.query('visit_photos', where: 'id = ?', whereArgs: [id]);
    if (photos.isNotEmpty) {
      final file = File(photos.first['path'] as String);
      if (await file.exists()) await file.delete();
    }
    return await db.delete('visit_photos', where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<VisitPhoto>> getPhotos(int visitId) async {
    final db = await database;
    final rows = await db.query(
      'visit_photos',
      where: 'visit_id = ?',
      whereArgs: [visitId],
      orderBy: 'created_at ASC',
    );
    return rows.map((r) => VisitPhoto.fromMap(r)).toList();
  }

  static Future<List<VisitPhoto>> getPhotosForClient(int clientId) async {
    final db = await database;
    final rows = await db.rawQuery('''
      SELECT visit_photos.* FROM visit_photos
      INNER JOIN visits ON visits.id = visit_photos.visit_id
      WHERE visits.client_id = ?
    ''', [clientId]);
    return rows.map((r) => VisitPhoto.fromMap(r)).toList();
  }

// ==================== APP SETTINGS ====================

  static Future<void> setSetting(String key, String value) async {
    final db = await database;

    await db.insert(
      'app_settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<String> getSetting(
    String key, {
    String defaultValue = '',
  }) async {
    final db = await database;

    final rows = await db.query(
      'app_settings',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );

    if (rows.isEmpty) return defaultValue;

    return rows.first['value'] as String? ?? defaultValue;
  }

  // ==================== INVOICE OPERATIONS ====================

  static Future<String> getNextInvoiceNumber(DateTime issuedAt) async {
    final db = await database;
    final year = issuedAt.year;
    final key = 'invoice_sequence_$year';

    return await db.transaction((txn) async {
      final rows = await txn.query(
        'app_settings',
        where: 'key = ?',
        whereArgs: [key],
        limit: 1,
      );

      final current = rows.isEmpty
          ? 0
          : int.tryParse((rows.first['value'] as String?) ?? '') ?? 0;
      final next = current + 1;

      await txn.insert(
        'app_settings',
        {'key': key, 'value': next.toString()},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return 'INV-$year-${next.toString().padLeft(4, '0')}';
    });
  }

  static Future<int> insertInvoice(InvoiceRecord invoice) async {
    final db = await database;
    return await db.insert('invoices', invoice.toMap());
  }

  static Future<int> updateInvoice(InvoiceRecord invoice) async {
    final db = await database;
    return await db.update(
      'invoices',
      invoice.toMap(),
      where: 'id = ?',
      whereArgs: [invoice.id],
    );
  }

  static Future<List<InvoiceRecord>> getInvoicesForVisit(int visitId) async {
    final db = await database;
    final rows = await db.query(
      'invoices',
      where: 'visit_id = ?',
      whereArgs: [visitId],
      orderBy: 'issued_at DESC',
    );
    return rows.map((r) => InvoiceRecord.fromMap(r)).toList();
  }

  static Future<List<InvoiceRecord>> getInvoices() async {
    final db = await database;
    final rows = await db.query('invoices', orderBy: 'issued_at DESC');
    return rows.map((r) => InvoiceRecord.fromMap(r)).toList();
  }

  static Future<InvoiceRecord?> getInvoice(int id) async {
    final db = await database;
    final rows = await db.query(
      'invoices',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return InvoiceRecord.fromMap(rows.first);
  }

  static Future<void> setInvoicesPaidForVisit(
    int visitId,
    bool paid,
  ) async {
    final db = await database;
    final now = DateTime.now().toIso8601String();
    await db.update(
      'invoices',
      {
        'paid_at': paid ? now : null,
        'updated_at': now,
      },
      where: 'visit_id = ?',
      whereArgs: [visitId],
    );
  }

  // ==================== STATISTICS ====================

  static Future<Map<String, dynamic>> getStats() async {
    final db = await database;
    final totalClients = Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM clients')) ??
        0;
    final totalHorses = Sqflite.firstIntValue(
            await db.rawQuery('SELECT COUNT(*) FROM horses')) ??
        0;
    final upcomingVisits = Sqflite.firstIntValue(await db.rawQuery(
            "SELECT COUNT(*) FROM visits WHERE datetime >= ? AND paid = 0",
            [DateTime.now().toIso8601String()])) ??
        0;
    final unpaidVisits = Sqflite.firstIntValue(await db.rawQuery(
            "SELECT COUNT(*) FROM visits WHERE paid = 0 AND datetime < ?",
            [DateTime.now().toIso8601String()])) ??
        0;

    final revenueResult = await db.rawQuery('''
      SELECT COALESCE(SUM(sl.price), 0) as total
      FROM service_lines sl
      INNER JOIN visits v ON v.id = sl.visit_id
      WHERE v.paid = 1
    ''');
    final totalRevenue =
        (revenueResult.first['total'] as num?)?.toDouble() ?? 0.0;

    final outstandingResult = await db.rawQuery('''
      SELECT COALESCE(SUM(sl.price), 0) as total
      FROM service_lines sl
      INNER JOIN visits v ON v.id = sl.visit_id
      WHERE v.paid = 0
    ''');
    final outstandingRevenue =
        (outstandingResult.first['total'] as num?)?.toDouble() ?? 0.0;

    return {
      'totalClients': totalClients,
      'totalHorses': totalHorses,
      'upcomingVisits': upcomingVisits,
      'unpaidVisits': unpaidVisits,
      'totalRevenue': totalRevenue,
      'outstandingRevenue': outstandingRevenue,
    };
  }
}
