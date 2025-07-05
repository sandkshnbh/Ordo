// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get app_title => 'Ordo';

  @override
  String get settings => '설정';

  @override
  String get add_task => '작업 추가';

  @override
  String get edit_task => '작업 편집';

  @override
  String get save_task => '작업 저장';

  @override
  String get delete => '삭제';

  @override
  String get edit => '편집';

  @override
  String active_tasks(Object count) {
    return '활성 작업이 $count개 있습니다';
  }

  @override
  String active_tasks_other(Object count) {
    return 'You have $count active tasks';
  }

  @override
  String get no_tasks => '현재 작업이 없습니다';

  @override
  String get task_title => '제목';

  @override
  String get task_description => '설명 (선택사항)';

  @override
  String get priority => '우선순위';

  @override
  String get urgent => '긴급';

  @override
  String get important => '중요';

  @override
  String get normal => '일반';

  @override
  String get confirm_delete => '삭제 확인';

  @override
  String get delete_question => '이 작업을 삭제하시겠습니까?';

  @override
  String get cancel => '취소';

  @override
  String get unexpected_error => '예상치 못한 오류가 발생했습니다. 다시 시도해 주세요.';

  @override
  String get blur_selected_text => '선택된 텍스트 흐리게';

  @override
  String get select_text_first => '먼저 텍스트를 선택하여 흐리게 하세요.';

  @override
  String get language => '언어';

  @override
  String get liquid_glass_theme => '리퀴드 글래스 테마';

  @override
  String get enable_liquid_glass => '리퀴드 글래스 테마 활성화';

  @override
  String get liquid_glass_description => '고급 시각 효과가 있는 리퀴드 글래스 디자인 적용';

  @override
  String get profile_card_title => '프로필 카드';

  @override
  String get profile_card_subtitle => 'Flutter 앱 개발자';

  @override
  String get profile_card_description => '저는 Sand Kshnbh로, 오픈 소스 소프트웨어 개발에 관심이 있는 Flutter 앱 개발자입니다.\nTelegram과 Twitter X를 통해 연락해 주세요';

  @override
  String get profile_card_telegram => '내 텔레그램 채널';

  @override
  String get profile_card_twitter => '내 트위터 X 계정';

  @override
  String get strike_style => '취소선 스타일';

  @override
  String get strike_straight => '직선';

  @override
  String get strike_zigzag => '지그재그';

  @override
  String get strike_scribble => '낙서';

  @override
  String get strike_dashed => '점선';

  @override
  String get strike_wave => '물결';

  @override
  String get strike_aqua => '물';

  @override
  String get strike_flame => '불꽃';

  @override
  String get audio_feature_in_progress => '오디오 기능이 개발 중입니다';

  @override
  String get pin => '고정';

  @override
  String get pin_feature_in_progress => '고정 기능이 개발 중입니다';
}
