import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/screens.dart';

void main() => runApp(const FarrierLogApp());

class FarrierLogApp extends StatelessWidget {
  const FarrierLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FarrierLog',
      debugShowCheckedModeBanner: false,
      // Required so showDatePicker respects the locale: parameter, which
      // we use to honour the user's start-week-on-Monday preference.
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('en', 'US'), // Sunday-first
        Locale('en', 'GB'), // Monday-first
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.brown,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.brown,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
