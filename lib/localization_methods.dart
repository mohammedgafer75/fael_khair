import 'package:fael_khair/set_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String getTranslate(BuildContext context, String key) {
  return SetLocalization.of(context).getTranslateValue(key);
}

const String ARABIC = 'ar';
const String ENGLISH = 'en';

const String LANG_CODE = 'LANG_CODE';

Future<Locale> setLocal(String langCode) async {
  SharedPreferences _sharedPreference = await SharedPreferences.getInstance();
  await _sharedPreference.setString(LANG_CODE, langCode);
  return _locale(langCode);
}

Locale _locale(String langCode) {
  Locale _temp;
  switch (langCode) {
    case ARABIC:
      _temp = Locale(langCode, 'EG');
      break;
    case ENGLISH:
      _temp = Locale(langCode, 'US');
      break;
    default:
      _temp = Locale(ENGLISH, 'US');
  }
  return _temp;
}

Future<Locale> getLocale() async {
  SharedPreferences _sharedPreference = await SharedPreferences.getInstance();
  String langCode = _sharedPreference.getString(LANG_CODE) ?? ENGLISH;
  return _locale(langCode);
}
