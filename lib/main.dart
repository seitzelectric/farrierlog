import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/generated/app_localizations.dart';
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
    DatabaseService.getLanguageCode().then((code) {
      AppUtils.initLocale(code);
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
      locale: AppUtils.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      // en_US/en_GB are kept here (in addition to AppLocalizations.supportedLocales)
      // so showDatePicker's locale: parameter can keep honouring the user's
      // start-week-on-Monday preference.
      supportedLocales: const [
        Locale('en', 'US'), // Sunday-first
        Locale('en', 'GB'), // Monday-first
        Locale('es'),
        Locale('fr'),
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
      home: FutureBuilder<bool>(
        future: DatabaseService.isOnboardingComplete(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data!
              ? const HomeScreen()
              : const OnboardingScreen();
        },
      ),
    );
  }
}
