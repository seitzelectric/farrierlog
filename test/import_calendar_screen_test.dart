import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:farrier_log/l10n/generated/app_localizations.dart';
import 'package:farrier_log/models/models.dart';
import 'package:farrier_log/screens/import_calendar_screen.dart';
import 'package:farrier_log/services/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late Directory tempDir;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('farrier_log_test_');
    await databaseFactoryFfi.setDatabasesPath(tempDir.path);
  });

  tearDown(() async {
    await DatabaseService.close();
    if (await tempDir.exists()) await tempDir.delete(recursive: true);
  });

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      await tester.pump();
    }
  }

  testWidgets('auto-matches clients and imports selected events',
      (tester) async {
    int? result;
    await tester.runAsync(() async {
      await DatabaseService.insertClient(Client(
        firstName: 'Ann',
        lastName: 'Johnson',
        phone: '',
        email: '',
        address: '123 Farm Rd, Springfield MO',
        notes: '',
      ));
      await DatabaseService.insertClient(Client(
        firstName: 'Bob',
        lastName: 'Smith',
        phone: '',
        email: '',
        address: '9 Hill Ln',
        notes: '',
      ));

      final events = [
        IcsEvent(
          uid: '1',
          summary: 'Trim - Johnson Ranch',
          startDateTime: DateTime(2026, 10, 1, 9),
          description: 'Front trim only',
          isRecurring: true,
          recurrenceWeeks: 6,
        ),
        IcsEvent(
          uid: '2',
          summary: 'Shoeing',
          startDateTime: DateTime(2026, 10, 2, 9),
          location: '9  hill ln.',
          isRecurring: true,
        ),
        IcsEvent(
          uid: '3',
          summary: 'Dentist',
          startDateTime: DateTime(2026, 10, 3, 9),
        ),
      ];

      await tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              result = await Navigator.push<int>(
                context,
                MaterialPageRoute(
                    builder: (_) => ImportCalendarScreen(events: events)),
              );
            },
            child: const Text('go'),
          ),
        ),
      ));
      await tester.tap(find.text('go'));
      await settle(tester);

      expect(find.text('Ann Johnson'), findsOneWidget);
      expect(find.text('Bob Smith'), findsOneWidget);
      expect(find.text('Skip — no client'), findsOneWidget);
      expect(find.text('Import Selected (2)'), findsOneWidget);
      expect(
          find.text('Repeats every 6 weeks — imported as a recurring visit'),
          findsOneWidget);
      expect(
          find.text('Repeat rule not supported — imported as a one-time visit'),
          findsOneWidget);

      await tester.tap(find.text('Import Selected (2)'));
      await settle(tester);
    });

    expect(result, 2);
    final visits = await tester.runAsync(DatabaseService.getVisits);
    expect(visits!.map((v) => v.clientName), ['Ann Johnson', 'Bob Smith']);
    expect(visits.first.notes, 'Trim - Johnson Ranch\n\nFront trim only');
    expect(visits.first.paid, isFalse);
    expect(visits.first.completed, isFalse);
    expect(visits.first.recurrenceWeeks, 6);
    expect(visits.last.recurrenceWeeks, isNull);
  });
}
