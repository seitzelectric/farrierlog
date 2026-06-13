import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:farrier_log/main.dart';
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
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  testWidgets('FarrierLog app starts', (WidgetTester tester) async {
    await tester.pumpWidget(const FarrierLogApp());

    expect(find.text('FarrierLog'), findsOneWidget);
  });
}
