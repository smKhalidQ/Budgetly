import 'package:flutter/material.dart';

import 'package:slice_pay/core/utilities/cache_helper.dart';

class LocaleService {
  static const _localeKey = 'locale_code';

  static const supportedLocales = [Locale('en'), Locale('ar')];

  Locale? loadSavedLocale() {
    final code = CacheHelper.getData(key: _localeKey) as String?;
    if (code == null) return null;
    return supportedLocales.firstWhere(
      (l) => l.languageCode == code,
      orElse: () => supportedLocales.first,
    );
  }

  Future<void> saveLocale(Locale locale) async {
    await CacheHelper.saveData(key: _localeKey, value: locale.languageCode);
  }
}
