import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const SkillMapApp());
}

class SkillMapApp extends StatefulWidget {
  const SkillMapApp({super.key});

  @override
  State<SkillMapApp> createState() => _SkillMapAppState();
}

class _SkillMapAppState extends State<SkillMapApp> {
  Locale _locale = const Locale('en');

  void _toggleLanguage() {
    setState(() {
      _locale = _locale.languageCode == 'en'
          ? const Locale('te')
          : const Locale('en');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SkillMap",
      theme: AppTheme.lightTheme, // ✅ Apply theme here

      locale: _locale,
      supportedLocales: const [Locale('en'), Locale('te')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: HomePage(onToggleLanguage: _toggleLanguage),
    );
  }
}
