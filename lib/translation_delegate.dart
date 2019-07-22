import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hapo_flutter01/translations.dart';

class TranslationsDelegate extends LocalizationsDelegate<Translations> {
  const TranslationsDelegate();

  @override
  bool isSupported(Locale locale) => ['ko', 'en' ,'ja', 'ru', 'zh'].contains(locale.languageCode);

  @override
  Future<Translations> load(Locale locale) async {
    Translations localizations = new Translations(locale);
    await localizations.load();

    print("Load ${locale.languageCode}");
    print("Load ${locale.countryCode}");

    return localizations;
  }

  @override
  bool shouldReload(TranslationsDelegate old) => false;
}