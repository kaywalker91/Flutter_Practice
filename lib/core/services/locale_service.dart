import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing locale persistence
/// Handles saving and loading user's selected language
class LocaleService {
  static const String _localeKey = 'selected_locale';
  static const Locale _defaultLocale = Locale('en'); // English as default

  /// Get saved locale from SharedPreferences
  /// Returns English as default if no locale is saved
  Future<Locale> getSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localeCode = prefs.getString(_localeKey);

      if (localeCode != null) {
        return Locale(localeCode);
      }
    } catch (e) {
      debugPrint('Error loading saved locale: $e');
    }

    return _defaultLocale;
  }

  /// Save locale to SharedPreferences
  Future<bool> saveLocale(Locale locale) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_localeKey, locale.languageCode);
    } catch (e) {
      debugPrint('Error saving locale: $e');
      return false;
    }
  }

  /// Clear saved locale (reset to default)
  Future<bool> clearLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_localeKey);
    } catch (e) {
      debugPrint('Error clearing locale: $e');
      return false;
    }
  }

  /// Get default locale (English)
  Locale get defaultLocale => _defaultLocale;

  /// Check if a locale is supported
  bool isSupportedLocale(Locale locale) {
    const supportedLocaleCodes = ['en', 'ko', 'ja'];
    return supportedLocaleCodes.contains(locale.languageCode);
  }
}
