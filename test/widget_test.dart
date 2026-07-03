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
    await tester.runAsync(() async {
      await tester.pumpWidget(const FarrierLogApp());
      // The root route is gated behind an async onboarding check backed
      // by real (isolate-based) sqflite I/O, which the fake test clock
      // doesn't advance on its own — pump a few real ticks to let it
      // resolve instead of pumpAndSettle, which never settles while the
      // interim CircularProgressIndicator is animating.
      for (var i = 0; i < 10; i++) {
        await Future.delayed(const Duration(milliseconds: 50));
        await tester.pump();
      }
    });

    // Fresh install with no clients lands on onboarding; existing
    // installs land on the home screen. Either way, the app should
    // start up successfully and render something FarrierLog-branded.
    expect(find.textContaining('FarrierLog'), findsWidgets);
  });
}
