import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logger/logger.dart';

import '../core/data/local/locale_storage.dart';
import '../core/services/api/service.dart';

part 'locale_notifier.g.dart';

@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  final Logger _logger = Logger(
    printer: SimplePrinter(
      colors: false,
      printTime: false,
    ),
  );

  @override
  Future<Locale> build() async {
    final savedLocale = await getLocale();
    return Locale(savedLocale ?? 'tr');
  }

  Future<void> setLocale(String languageCode) async {
    await saveLocale(languageCode);
    state = AsyncValue.data(Locale(languageCode));

    try {
      final webService = ref.read(webServiceProvider);
      final success = await webService.updateLanguage(languageCode);
      if (success) {
        _logger.i('Language preference synced to server: $languageCode');
      } else {
        _logger.w('Failed to sync language to server, continuing with local change');
      }
    } catch (e) {
      _logger.e('Error syncing language to server', error: e);
    }
  }

  Future<void> syncLanguageFromServer() async {
    try {
      final webService = ref.read(webServiceProvider);
      final serverLanguage = await webService.getLanguage();

      if (serverLanguage != null && (serverLanguage == 'tr' || serverLanguage == 'en')) {
        _logger.i('Syncing language from server: $serverLanguage');
        await saveLocale(serverLanguage);
        state = AsyncValue.data(Locale(serverLanguage));
      } else {
        _logger.w('Invalid or null language from server: $serverLanguage');
      }
    } catch (e) {
      _logger.e('Error syncing language from server', error: e);
    }
  }

  Future<void> setTurkish() async {
    await setLocale('tr');
  }

  Future<void> setEnglish() async {
    await setLocale('en');
  }
}
