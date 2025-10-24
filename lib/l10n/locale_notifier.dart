import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/data/local/locale_storage.dart';

part 'locale_notifier.g.dart';

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Future<Locale> build() async {
    final savedLocale = await getLocale();
    return Locale(savedLocale ?? 'tr');
  }

  Future<void> setLocale(String languageCode) async {
    await saveLocale(languageCode);
    state = AsyncValue.data(Locale(languageCode));
  }

  Future<void> setTurkish() async {
    await setLocale('tr');
  }

  Future<void> setEnglish() async {
    await setLocale('en');
  }
}
