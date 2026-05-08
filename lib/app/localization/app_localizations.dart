import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  const AppLocalizations(this.locale, this._values);

  final Locale locale;
  final Map<String, String> _values;

  static const supportedLocales = [Locale('tr'), Locale('en')];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String t(String key) => _values[key] ?? key;
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['tr', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final code = locale.languageCode == 'tr' ? 'tr' : 'en';
    final raw = await rootBundle.loadString('lib/app/localization/$code.json');
    final decoded = (jsonDecode(raw) as Map).map(
      (key, value) => MapEntry(key.toString(), value.toString()),
    );
    return AppLocalizations(Locale(code), decoded);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
