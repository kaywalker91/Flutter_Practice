import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/theme_service.dart';

/// ThemeService 인스턴스를 제공하는 Provider
///
/// SharedPreferences를 주입받아 ThemeService를 생성합니다.
final themeServiceProvider = Provider<ThemeService>((ref) {
  // SharedPreferences는 main.dart에서 ProviderScope overrides로 주입됩니다
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeService(prefs);
});

/// SharedPreferences 인스턴스를 제공하는 Provider
///
/// main.dart에서 초기화된 SharedPreferences를 전역적으로 사용할 수 있게 합니다.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main.dart');
});

/// 테마 모드 상태를 관리하는 StateNotifier
///
/// 사용자가 선택한 테마 모드를 관리하고 SharedPreferences에 영구 저장합니다.
class ThemeNotifier extends StateNotifier<ThemeMode> {
  final ThemeService _themeService;

  ThemeNotifier(this._themeService) : super(ThemeMode.system) {
    // 초기화 시 저장된 테마 모드를 불러옵니다
    _loadThemeMode();
  }

  /// 저장된 테마 모드를 불러와 상태를 업데이트합니다
  void _loadThemeMode() {
    state = _themeService.getThemeMode();
  }

  /// 테마 모드를 변경하고 저장합니다
  ///
  /// Parameters:
  ///   - themeMode: 설정할 테마 모드 (light/dark/system)
  ///
  /// 상태가 변경되면 자동으로 UI가 업데이트됩니다.
  Future<void> setThemeMode(ThemeMode themeMode) async {
    // 상태를 즉시 업데이트하여 UI 반응성을 높입니다
    state = themeMode;

    // SharedPreferences에 비동기로 저장합니다
    await _themeService.saveThemeMode(themeMode);
  }

  /// 테마 설정을 초기화하고 시스템 기본값으로 되돌립니다
  Future<void> resetThemeMode() async {
    await _themeService.clearThemeMode();
    state = ThemeMode.system;
  }
}

/// 테마 모드 상태를 제공하는 StateNotifierProvider
///
/// 앱 전체에서 현재 테마 모드를 읽고 변경할 수 있습니다.
///
/// 사용 예시:
/// ```dart
/// // 테마 모드 읽기
/// final themeMode = ref.watch(themeProvider);
///
/// // 테마 모드 변경
/// ref.read(themeProvider.notifier).setThemeMode(ThemeMode.dark);
/// ```
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final themeService = ref.watch(themeServiceProvider);
  return ThemeNotifier(themeService);
});
