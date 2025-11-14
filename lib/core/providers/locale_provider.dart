import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/locale_service.dart';

/// Locale state notifier for managing app language
class LocaleNotifier extends StateNotifier<Locale> {
  final LocaleService _localeService;

  LocaleNotifier(this._localeService) : super(const Locale('en')) {
    // Load saved locale on initialization
    _loadSavedLocale();
  }

  /// Load saved locale from SharedPreferences
  Future<void> _loadSavedLocale() async {
    final savedLocale = await _localeService.getSavedLocale();
    state = savedLocale;
  }

  /// Change app locale
  Future<void> setLocale(Locale locale) async {
    // Validate locale
    if (!_localeService.isSupportedLocale(locale)) {
      debugPrint('Unsupported locale: ${locale.languageCode}');
      return;
    }

    // Update state
    state = locale;

    // Save to SharedPreferences
    final saved = await _localeService.saveLocale(locale);
    if (!saved) {
      debugPrint('Failed to save locale: ${locale.languageCode}');
    }
  }

  /// Reset to default locale (English)
  Future<void> resetToDefault() async {
    state = _localeService.defaultLocale;
    await _localeService.clearLocale();
  }

  /// Get current locale
  Locale get currentLocale => state;

  /// Check if current locale is the default
  bool get isDefaultLocale => state.languageCode == 'en';
}

/// Provider for LocaleService
final localeServiceProvider = Provider<LocaleService>((ref) {
  return LocaleService();
});

/// Provider for LocaleNotifier
/// This is the main provider to use in the app
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final localeService = ref.watch(localeServiceProvider);
  return LocaleNotifier(localeService);
});
