import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 테마 모드 저장/로드를 담당하는 서비스
///
/// SharedPreferences를 사용하여 사용자의 테마 설정을 영구 저장합니다.
/// 지원하는 테마 모드: light, dark, system
class ThemeService {
  static const String _themeKey = 'theme_mode';

  final SharedPreferences _prefs;

  ThemeService(this._prefs);

  /// 저장된 테마 모드를 불러옵니다
  ///
  /// 저장된 값이 없으면 시스템 기본값(ThemeMode.system)을 반환합니다.
  ///
  /// Returns:
  ///   - ThemeMode.light: 라이트 모드
  ///   - ThemeMode.dark: 다크 모드
  ///   - ThemeMode.system: 시스템 설정 따르기 (기본값)
  ThemeMode getThemeMode() {
    final String? themeModeString = _prefs.getString(_themeKey);

    if (themeModeString == null) {
      return ThemeMode.system; // 기본값
    }

    switch (themeModeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  /// 테마 모드를 저장합니다
  ///
  /// Parameters:
  ///   - themeMode: 저장할 테마 모드
  ///
  /// Returns:
  ///   - true: 저장 성공
  ///   - false: 저장 실패
  Future<bool> saveThemeMode(ThemeMode themeMode) async {
    String themeModeString;

    switch (themeMode) {
      case ThemeMode.light:
        themeModeString = 'light';
        break;
      case ThemeMode.dark:
        themeModeString = 'dark';
        break;
      case ThemeMode.system:
        themeModeString = 'system';
        break;
    }

    return await _prefs.setString(_themeKey, themeModeString);
  }

  /// 저장된 테마 설정을 삭제합니다
  ///
  /// 삭제 후에는 기본값(ThemeMode.system)이 사용됩니다.
  ///
  /// Returns:
  ///   - true: 삭제 성공
  ///   - false: 삭제 실패
  Future<bool> clearThemeMode() async {
    return await _prefs.remove(_themeKey);
  }
}
