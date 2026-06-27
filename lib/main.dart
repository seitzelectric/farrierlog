import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/screens.dart';
import 'services/database_service.dart';
import 'utils/utils.dart';

void main() => runApp(const FarrierLogApp());

class FarrierLogApp extends StatefulWidget {
  const FarrierLogApp({super.key});

  @override
  State<FarrierLogApp> createState() => _FarrierLogAppState();
}

class _FarrierLogAppState extends State<FarrierLogApp> {
  @override
  void initState() {
    super.initState();
    DatabaseService.getCurrencySymbol().then(AppUtils.initCurrencySymbol);
    DatabaseService.getDistanceUnit().then(AppUtils.initDistanceUnit);
    DatabaseService.getTerrainThemeId().then((id) {
      AppUtils.initTerrainTheme(id);
      if (mounted) setState(() {});
    });
    AppUtils.setThemeChangedCallback(() {
      if (mounted) setState(() {});
    });
  }

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
        colorSchemeSeed: AppUtils.terrainSeedColor,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: AppUtils.terrainSeedColor,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
