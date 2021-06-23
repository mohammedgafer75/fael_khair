import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class SetLocalization {
  final Locale locale;

  SetLocalization(this.locale);

  static SetLocalization of(BuildContext context) {
    return Localizations.of<SetLocalization>(context, SetLocalization);
  }

  static LocalizationsDelegate<SetLocalization> localizationsDelegate =
      getLocalizationDelegate();
  Map<String, String> localizedValues;

  Future load() async {
    String values =
        await rootBundle.loadString('langs/${locale.languageCode}.json');

    Map<String, dynamic> mappedJson = json.decode(values);
    localizedValues =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String getTranslateValue(String key) {
    return localizedValues[key];
  }
}

class getLocalizationDelegate extends LocalizationsDelegate<SetLocalization> {
  const getLocalizationDelegate();
  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<SetLocalization> load(Locale locale) async {
    SetLocalization localization = new SetLocalization(locale);
    await localization.load();

    return localization;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<SetLocalization> old) {
    return false;
  }
}
