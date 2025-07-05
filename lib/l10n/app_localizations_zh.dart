// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get app_title => 'Ordo';

  @override
  String get settings => '设置';

  @override
  String get add_task => '添加任务';

  @override
  String get edit_task => '编辑任务';

  @override
  String get save_task => '保存任务';

  @override
  String get delete => '删除';

  @override
  String get edit => '编辑';

  @override
  String active_tasks(Object count) {
    return '您有 $count 个活动任务';
  }

  @override
  String active_tasks_other(Object count) {
    return 'You have $count active tasks';
  }

  @override
  String get no_tasks => '当前没有任务';

  @override
  String get task_title => '标题';

  @override
  String get task_description => '描述（可选）';

  @override
  String get priority => '优先级';

  @override
  String get urgent => '紧急';

  @override
  String get important => '重要';

  @override
  String get normal => '普通';

  @override
  String get confirm_delete => '确认删除';

  @override
  String get delete_question => '您确定要删除此任务吗？';

  @override
  String get cancel => '取消';

  @override
  String get unexpected_error => '发生意外错误，请重试。';

  @override
  String get blur_selected_text => '模糊选中的文本';

  @override
  String get select_text_first => '请先选择要模糊的文本。';

  @override
  String get language => '语言';

  @override
  String get liquid_glass_theme => '液态玻璃主题';

  @override
  String get enable_liquid_glass => '启用液态玻璃主题';

  @override
  String get liquid_glass_description => '应用具有高级视觉效果的液态玻璃设计';

  @override
  String get profile_card_title => '个人资料卡';

  @override
  String get profile_card_subtitle => 'Flutter 应用开发者';

  @override
  String get profile_card_description => '我是 Sand Kshnbh，一名对开源软件开发感兴趣的 Flutter 应用开发者。\n通过 Telegram 和 Twitter X 联系我';

  @override
  String get profile_card_telegram => '我的 Telegram 频道';

  @override
  String get profile_card_twitter => '我的 Twitter X 账户';

  @override
  String get strike_style => '删除线样式';

  @override
  String get strike_straight => '直线';

  @override
  String get strike_zigzag => '锯齿';

  @override
  String get strike_scribble => '涂鸦';

  @override
  String get strike_dashed => '虚线';

  @override
  String get strike_wave => '波浪';

  @override
  String get strike_aqua => '水波';

  @override
  String get strike_flame => '火焰';

  @override
  String get audio_feature_in_progress => '音频功能正在开发中';

  @override
  String get pin => '置顶';

  @override
  String get pin_feature_in_progress => '置顶功能正在开发中';
}
