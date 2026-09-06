import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations.dart';

/// App localization configuration.
///
/// Arabic is primary (RTL), English and French are secondary.
/// Always use AppLocalizations.of(context) for user-facing text.
const supportedLocales = [
  Locale('ar', ''), // Arabic (primary)
  Locale('en', ''), // English
  Locale('fr', ''), // French
];

const localizationsDelegates = [
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

/// Default locale is Arabic.
const defaultLocale = Locale('ar', '');

/// Check if locale is RTL.
bool isRtl(Locale locale) => locale.languageCode == 'ar';
