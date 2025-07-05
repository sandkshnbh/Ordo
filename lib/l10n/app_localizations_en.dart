// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get app_title => 'Ordo';

  @override
  String get settings => 'Settings';

  @override
  String get add_task => 'Add Task';

  @override
  String get edit_task => 'Edit Task';

  @override
  String get save_task => 'Save Task';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String active_tasks(Object count) {
    return 'You have $count active task';
  }

  @override
  String active_tasks_other(Object count) {
    return 'You have $count active tasks';
  }

  @override
  String get no_tasks => 'No tasks currently';

  @override
  String get task_title => 'Title';

  @override
  String get task_description => 'Description (optional)';

  @override
  String get priority => 'Priority';

  @override
  String get urgent => 'Urgent';

  @override
  String get important => 'Important';

  @override
  String get normal => 'Normal';

  @override
  String get confirm_delete => 'Confirm Delete';

  @override
  String get delete_question => 'Are you sure you want to delete this task?';

  @override
  String get cancel => 'Cancel';

  @override
  String get unexpected_error => 'An unexpected error occurred, please try again.';

  @override
  String get blur_selected_text => 'Blur Selected Text';

  @override
  String get select_text_first => 'Select text first to blur.';

  @override
  String get language => 'Language';

  @override
  String get liquid_glass_theme => 'Liquid Glass Theme';

  @override
  String get enable_liquid_glass => 'Enable Liquid Glass Theme';

  @override
  String get liquid_glass_description => 'Apply liquid glass design with advanced visual effects';

  @override
  String get profile_card_title => 'Profile Card';

  @override
  String get profile_card_subtitle => 'Flutter App Developer';

  @override
  String get profile_card_description => 'I\'m Sand Kshnbh, a Flutter app developer interested in open source software development.\nContact me via: Telegram and Twitter X';

  @override
  String get profile_card_telegram => 'My Telegram Channel';

  @override
  String get profile_card_twitter => 'My Twitter X Account';

  @override
  String get strike_style => 'Strike Style';

  @override
  String get strike_straight => 'Straight';

  @override
  String get strike_zigzag => 'Zigzag';

  @override
  String get strike_scribble => 'Scribble';

  @override
  String get strike_dashed => 'Dashed';

  @override
  String get strike_wave => 'Wave';

  @override
  String get strike_aqua => 'Aqua';

  @override
  String get strike_flame => 'Flame';

  @override
  String get audio_feature_in_progress => 'Audio feature is under development';

  @override
  String get pin => 'Pin';

  @override
  String get pin_feature_in_progress => 'Pin feature is under development';
}
