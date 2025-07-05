// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get app_title => 'Ordo';

  @override
  String get settings => 'Ayarlar';

  @override
  String get add_task => 'Görev Ekle';

  @override
  String get edit_task => 'Görevi Düzenle';

  @override
  String get save_task => 'Görevi Kaydet';

  @override
  String get delete => 'Sil';

  @override
  String get edit => 'Düzenle';

  @override
  String active_tasks(Object count) {
    return '$count aktif göreviniz var';
  }

  @override
  String active_tasks_other(Object count) {
    return 'You have $count active tasks';
  }

  @override
  String get no_tasks => 'Şu anda görev yok';

  @override
  String get task_title => 'Başlık';

  @override
  String get task_description => 'Açıklama (isteğe bağlı)';

  @override
  String get priority => 'Öncelik';

  @override
  String get urgent => 'Acil';

  @override
  String get important => 'Önemli';

  @override
  String get normal => 'Normal';

  @override
  String get confirm_delete => 'Silme Onayı';

  @override
  String get delete_question => 'Bu görevi silmek istediğinizden emin misiniz?';

  @override
  String get cancel => 'İptal';

  @override
  String get unexpected_error => 'Beklenmeyen bir hata oluştu, lütfen tekrar deneyin.';

  @override
  String get blur_selected_text => 'Seçili Metni Bulanıklaştır';

  @override
  String get select_text_first => 'Önce bulanıklaştırılacak metni seçin.';

  @override
  String get language => 'Dil';

  @override
  String get liquid_glass_theme => 'Sıvı Cam Teması';

  @override
  String get enable_liquid_glass => 'Sıvı Cam Temasını Etkinleştir';

  @override
  String get liquid_glass_description => 'Gelişmiş görsel efektlerle sıvı cam tasarımını uygula';

  @override
  String get profile_card_title => 'Profil Kartı';

  @override
  String get profile_card_subtitle => 'Flutter Uygulama Geliştiricisi';

  @override
  String get profile_card_description => 'Ben Sand Kshnbh, açık kaynak yazılım geliştirmeye ilgi duyan bir Flutter uygulama geliştiricisiyim.\nTelegram ve Twitter X üzerinden benimle iletişime geçin';

  @override
  String get profile_card_telegram => 'Telegram Kanalım';

  @override
  String get profile_card_twitter => 'Twitter X Hesabım';

  @override
  String get strike_style => 'Üzeri Çizili Stil';

  @override
  String get strike_straight => 'Düz';

  @override
  String get strike_zigzag => 'Zikzak';

  @override
  String get strike_scribble => 'Karalama';

  @override
  String get strike_dashed => 'Kesikli';

  @override
  String get strike_wave => 'Dalga';

  @override
  String get strike_aqua => 'Su';

  @override
  String get strike_flame => 'Alev';

  @override
  String get audio_feature_in_progress => 'Ses özelliği geliştiriliyor';

  @override
  String get pin => 'Sabitle';

  @override
  String get pin_feature_in_progress => 'Sabitleme özelliği geliştiriliyor';
}
