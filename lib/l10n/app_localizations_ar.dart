// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get app_title => 'Ordo';

  @override
  String get settings => 'الإعدادات';

  @override
  String get add_task => 'إضافة مهمة';

  @override
  String get edit_task => 'تعديل مهمة';

  @override
  String get save_task => 'حفظ المهمة';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String active_tasks(Object count) {
    return 'لديك $count مهمة نشطة';
  }

  @override
  String active_tasks_other(Object count) {
    return 'You have $count active tasks';
  }

  @override
  String get no_tasks => 'لا توجد مهام حاليًا';

  @override
  String get task_title => 'العنوان';

  @override
  String get task_description => 'الوصف (اختياري)';

  @override
  String get priority => 'الأولوية';

  @override
  String get urgent => 'عاجلة';

  @override
  String get important => 'مهمة';

  @override
  String get normal => 'عادية';

  @override
  String get confirm_delete => 'تأكيد الحذف';

  @override
  String get delete_question => 'هل أنت متأكد من رغبتك في حذف هذه المهمة؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get unexpected_error => 'حدث خطأ غير متوقع، الرجاء المحاولة مجددًا.';

  @override
  String get blur_selected_text => 'تشويش النص المحدد';

  @override
  String get select_text_first => 'حدد نصًا أولاً لتشويشه.';

  @override
  String get language => 'اللغة';

  @override
  String get liquid_glass_theme => 'ثيم Liquid Glass';

  @override
  String get enable_liquid_glass => 'تفعيل ثيم Liquid Glass';

  @override
  String get liquid_glass_description => 'تطبيق تصميم زجاجي سائل مع تأثيرات بصرية متقدمة';

  @override
  String get profile_card_title => 'بطاقة تعريف';

  @override
  String get profile_card_subtitle => 'مطور تطبيقات Flutter';

  @override
  String get profile_card_description => 'أنا سند كشنبه مطور تطبيقات Flutter واهتم بتطوير البرمجيات مفتوحة المصدر.\nللتواصل معي عبر: Telegram و Twitter X';

  @override
  String get profile_card_telegram => 'قناتي على تيليجرام';

  @override
  String get profile_card_twitter => 'حسابي على تويتر X';

  @override
  String get strike_style => 'نمط الشطب';

  @override
  String get strike_straight => 'مستقيم';

  @override
  String get strike_zigzag => 'متعرج';

  @override
  String get strike_scribble => 'تخريبش';

  @override
  String get strike_dashed => 'متقطع';

  @override
  String get strike_wave => 'موجي';

  @override
  String get strike_aqua => 'مائي';

  @override
  String get strike_flame => 'ناري';

  @override
  String get audio_feature_in_progress => 'ميزة تشغيل الصوت قيد التطوير';

  @override
  String get pin => 'تثبيت';

  @override
  String get pin_feature_in_progress => 'ميزة التثبيت قيد التطوير';
}
