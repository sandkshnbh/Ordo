// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get app_title => 'Ordo';

  @override
  String get settings => 'Настройки';

  @override
  String get add_task => 'Добавить задачу';

  @override
  String get edit_task => 'Редактировать задачу';

  @override
  String get save_task => 'Сохранить задачу';

  @override
  String get delete => 'Удалить';

  @override
  String get edit => 'Редактировать';

  @override
  String active_tasks(Object count) {
    return 'У вас $count активная задача';
  }

  @override
  String active_tasks_other(Object count) {
    return 'У вас $count активных задач';
  }

  @override
  String get no_tasks => 'В настоящее время нет задач';

  @override
  String get task_title => 'Заголовок';

  @override
  String get task_description => 'Описание (необязательно)';

  @override
  String get priority => 'Приоритет';

  @override
  String get urgent => 'Срочно';

  @override
  String get important => 'Важно';

  @override
  String get normal => 'Обычно';

  @override
  String get confirm_delete => 'Подтвердить удаление';

  @override
  String get delete_question => 'Вы уверены, что хотите удалить эту задачу?';

  @override
  String get cancel => 'Отмена';

  @override
  String get unexpected_error => 'Произошла непредвиденная ошибка, попробуйте еще раз.';

  @override
  String get blur_selected_text => 'Размыть выбранный текст';

  @override
  String get select_text_first => 'Сначала выберите текст для размытия.';

  @override
  String get language => 'Язык';

  @override
  String get liquid_glass_theme => 'Тема Жидкое Стекло';

  @override
  String get enable_liquid_glass => 'Включить тему Жидкое Стекло';

  @override
  String get liquid_glass_description => 'Применить дизайн жидкого стекла с продвинутыми визуальными эффектами';

  @override
  String get profile_card_title => 'Карточка профиля';

  @override
  String get profile_card_subtitle => 'Разработчик приложений Flutter';

  @override
  String get profile_card_description => 'Я Sand Kshnbh, разработчик приложений Flutter, интересующийся разработкой программного обеспечения с открытым исходным кодом.\nСвяжитесь со мной через: Telegram и Twitter X';

  @override
  String get profile_card_telegram => 'Мой канал в Telegram';

  @override
  String get profile_card_twitter => 'Мой аккаунт в Twitter X';

  @override
  String get strike_style => 'Стиль зачёркивания';

  @override
  String get strike_straight => 'Прямая';

  @override
  String get strike_zigzag => 'Зигзаг';

  @override
  String get strike_scribble => 'Каляка-маляка';

  @override
  String get strike_dashed => 'Пунктир';

  @override
  String get strike_wave => 'Волна';

  @override
  String get strike_aqua => 'Вода';

  @override
  String get strike_flame => 'Огонь';

  @override
  String get audio_feature_in_progress => 'Аудиофункция в разработке';

  @override
  String get pin => 'Закрепить';

  @override
  String get pin_feature_in_progress => 'Функция закрепления в разработке';
}
