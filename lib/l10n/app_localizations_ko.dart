// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Flutter 데모';

  @override
  String get homePageTitle => 'Flutter 데모 홈 페이지';

  @override
  String get counterDescription => '버튼을 누른 횟수:';

  @override
  String get incrementTooltip => '증가';

  @override
  String get settings => '설정';

  @override
  String get language => '언어';

  @override
  String get theme => '테마';

  @override
  String get lightMode => '라이트 모드';

  @override
  String get darkMode => '다크 모드';

  @override
  String get systemMode => '시스템 설정';

  @override
  String get korean => '한국어';

  @override
  String get english => 'English';

  @override
  String get japanese => '日本語';

  @override
  String get welcomeMessage => 'Flutter 앱에 오신 것을 환영합니다!';
}
