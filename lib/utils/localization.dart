import 'dart:ui' as ui;

class Localization {
  static const String _defaultLanguage = 'en';
  static String _currentLanguage = _defaultLanguage;

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_name': 'Ordo',
      'add_task': 'Add Task',
      'edit_task': 'Edit Task',
      'task_title': 'Task Title',
      'task_title_hint': 'Enter task title...',
      'task_title_required': 'Task title is required',
      'priority': 'Priority',
      'low_priority': 'Low',
      'normal_priority': 'Normal',
      'high_priority': 'High',
      'reminder': 'Reminder',
      'add': 'Add',
      'update': 'Update',
      'delete': 'Delete',
      'cancel': 'Cancel',
      'settings': 'Settings',
      'language': 'Language',
      'theme': 'Theme',
      'dark_theme': 'Dark Theme',
      'light_theme': 'Light Theme',
      'system_theme': 'System Theme',
      'task_reminder': 'Task Reminder',
      'reminder_set': 'Reminder set for',
      'reminder_removed': 'Reminder removed',
      'no_reminder': 'No reminder set',
      'developer_info': 'Developer Information',
      'developer': 'Developer',
      'developer_name': 'Sand Kshnbh',
      'telegram_channel': 'Telegram Channel',
      'delete_task': 'Delete Task',
      'delete_task_confirmation': 'Are you sure you want to delete this task?',
      'task_deleted': 'Task deleted successfully',
      'task_added': 'Task added successfully',
      'task_updated': 'Task updated successfully',
      'task_marked_complete': 'Task marked as complete',
      'task_marked_incomplete': 'Task marked as incomplete',
      'no_tasks': 'No tasks yet',
      'could_not_launch': 'Could not launch the link',
    },
    'ar': {
      'app_name': 'Ordo',
      'add_task': 'إضافة مهمة',
      'edit_task': 'تعديل المهمة',
      'task_title': 'عنوان المهمة',
      'task_title_hint': 'أدخل عنوان المهمة...',
      'task_title_required': 'عنوان المهمة مطلوب',
      'priority': 'الأولوية',
      'low_priority': 'منخفضة',
      'normal_priority': 'عادية',
      'high_priority': 'عالية',
      'reminder': 'تذكير',
      'add': 'إضافة',
      'update': 'تحديث',
      'delete': 'حذف',
      'cancel': 'إلغاء',
      'settings': 'الإعدادات',
      'language': 'اللغة',
      'theme': 'المظهر',
      'dark_theme': 'المظهر الداكن',
      'light_theme': 'المظهر الفاتح',
      'system_theme': 'مظهر النظام',
      'task_reminder': 'تذكير بالمهمة',
      'reminder_set': 'تم تعيين التذكير لـ',
      'reminder_removed': 'تم إزالة التذكير',
      'no_reminder': 'لا يوجد تذكير',
      'developer_info': 'معلومات المطور',
      'developer': 'المطور',
      'developer_name': 'سند كشنبه',
      'telegram_channel': 'قناة تيليجرام',
      'delete_task': 'حذف المهمة',
      'delete_task_confirmation': 'هل أنت متأكد من حذف هذه المهمة؟',
      'task_deleted': 'تم حذف المهمة بنجاح',
      'task_added': 'تمت إضافة المهمة بنجاح',
      'task_updated': 'تم تحديث المهمة بنجاح',
      'task_marked_complete': 'تم إكمال المهمة',
      'task_marked_incomplete': 'تم إلغاء إكمال المهمة',
      'no_tasks': 'لا توجد مهام بعد',
      'could_not_launch': 'تعذر فتح الرابط',
    },
    'ru': {
      'app_name': 'Ordo',
      'add_task': 'Добавить задачу',
      'edit_task': 'Редактировать задачу',
      'task_title': 'Название задачи',
      'task_title_hint': 'Введите название задачи...',
      'task_title_required': 'Название задачи обязательно',
      'priority': 'Приоритет',
      'low_priority': 'Низкий',
      'normal_priority': 'Средний',
      'high_priority': 'Высокий',
      'reminder': 'Напоминание',
      'add': 'Добавить',
      'update': 'Обновить',
      'delete': 'Удалить',
      'cancel': 'Отмена',
      'settings': 'Настройки',
      'language': 'Язык',
      'theme': 'Тема',
      'dark_theme': 'Темная тема',
      'light_theme': 'Светлая тема',
      'system_theme': 'Системная тема',
      'task_reminder': 'Напоминание о задаче',
      'reminder_set': 'Напоминание установлено для',
      'reminder_removed': 'Напоминание удалено',
      'no_reminder': 'Напоминание не установлено',
      'developer_info': 'Информация о разработчике',
      'developer': 'Разработчик',
      'developer_name': 'Санд Кшнбх',
      'telegram_channel': 'Канал Telegram',
      'delete_task': 'Удалить задачу',
      'delete_task_confirmation': 'Вы уверены, что хотите удалить эту задачу?',
      'task_deleted': 'Задача успешно удалена',
      'task_added': 'Задача успешно добавлена',
      'task_updated': 'Задача успешно обновлена',
      'task_marked_complete': 'Задача отмечена как выполненная',
      'task_marked_incomplete': 'Задача отмечена как невыполненная',
      'no_tasks': 'Нет задач',
      'could_not_launch': 'Не удалось открыть ссылку',
    },
    'ko': {
      'app_name': 'Ordo',
      'add_task': '작업 추가',
      'edit_task': '작업 수정',
      'task_title': '작업 제목',
      'task_title_hint': '작업 제목을 입력하세요...',
      'task_title_required': '작업 제목이 필요합니다',
      'priority': '우선순위',
      'low_priority': '낮은',
      'normal_priority': '보통',
      'high_priority': '높은',
      'reminder': '알림',
      'add': '추가',
      'update': '업데이트',
      'delete': '삭제',
      'cancel': '취소',
      'settings': '설정',
      'language': '언어',
      'theme': '테마',
      'dark_theme': '어두운 테마',
      'light_theme': '밝은 테마',
      'system_theme': '시스템 테마',
      'task_reminder': '작업 알림',
      'reminder_set': '알림 설정됨',
      'reminder_removed': '알림 제거됨',
      'no_reminder': '알림 설정안됨',
      'developer_info': '개발자 정보',
      'developer': '개발자',
      'developer_name': '샌드 크슨브',
      'telegram_channel': '텔레그램 채널',
      'delete_task': '작업 삭제',
      'delete_task_confirmation': '이 작업을 삭제하시겠습니까?',
      'task_deleted': '작업이 성공적으로 삭제되었습니다',
      'task_added': '작업이 성공적으로 추가되었습니다',
      'task_updated': '작업이 성공적으로 업데이트되었습니다',
      'task_marked_complete': '작업이 완료됨으로 표시됨',
      'task_marked_incomplete': '작업이 미완료됨으로 표시됨',
      'no_tasks': '작업이 없습니다',
      'could_not_launch': '링크를 열 수 없습니다',
    },
    'zh': {
      'app_name': 'Ordo',
      'add_task': '添加任务',
      'edit_task': '编辑任务',
      'task_title': '任务标题',
      'task_title_hint': '输入任务标题...',
      'task_title_required': '任务标题是必需的',
      'priority': '优先级',
      'low_priority': '低',
      'normal_priority': '普通',
      'high_priority': '高',
      'reminder': '提醒',
      'add': '添加',
      'update': '更新',
      'delete': '删除',
      'cancel': '取消',
      'settings': '设置',
      'language': '语言',
      'theme': '主题',
      'dark_theme': '暗色主题',
      'light_theme': '亮色主题',
      'system_theme': '系统主题',
      'task_reminder': '任务提醒',
      'reminder_set': '提醒设置为',
      'reminder_removed': '提醒已移除',
      'no_reminder': '没有设置提醒',
      'developer_info': '开发者信息',
      'developer': '开发者',
      'developer_name': '桑德·克什布',
      'telegram_channel': '电报频道',
      'delete_task': '删除任务',
      'delete_task_confirmation': '确定要删除此任务吗？',
      'task_deleted': '任务已成功删除',
      'task_added': '任务已成功添加',
      'task_updated': '任务已成功更新',
      'task_marked_complete': '任务已标记为完成',
      'task_marked_incomplete': '任务已标记为未完成',
      'no_tasks': '暂无任务',
      'could_not_launch': '无法打开链接',
    },
    'tr': {
      'app_name': 'Ordo',
      'add_task': 'Görev Ekle',
      'edit_task': 'Görevi Düzenle',
      'task_title': 'Görev Başlığı',
      'task_title_hint': 'Görev başlığını girin...',
      'task_title_required': 'Görev başlığı gerekli',
      'priority': 'Öncelik',
      'low_priority': 'Düşük',
      'normal_priority': 'Normal',
      'high_priority': 'Yüksek',
      'reminder': 'Hatırlatıcı',
      'add': 'Ekle',
      'update': 'Güncelle',
      'delete': 'Sil',
      'cancel': 'İptal',
      'settings': 'Ayarlar',
      'language': 'Dil',
      'theme': 'Tema',
      'dark_theme': 'Koyu Tema',
      'light_theme': 'Açık Tema',
      'system_theme': 'Sistem Tema',
      'task_reminder': 'Görev Hatırlatıcısı',
      'reminder_set': 'Hatırlatıcı ayarlandı',
      'reminder_removed': 'Hatırlatıcı kaldırıldı',
      'no_reminder': 'Hatırlatıcı ayarlı değil',
      'developer_info': 'Geliştirici Bilgisi',
      'developer': 'Geliştirici',
      'developer_name': 'Sand Kshnbh',
      'telegram_channel': 'Telegram Kanalı',
      'delete_task': 'Görevi Sil',
      'delete_task_confirmation':
          'Bu görevi silmek istediğinizden emin misiniz?',
      'task_deleted': 'Görev başarıyla silindi',
      'task_added': 'Görev başarıyla eklendi',
      'task_updated': 'Görev başarıyla güncellendi',
      'task_marked_complete': 'Görev tamamlandı olarak işaretlendi',
      'task_marked_incomplete': 'Görev tamamlanmadı olarak işaretlendi',
      'no_tasks': 'Henüz görev yok',
      'could_not_launch': 'Bağlantı açılamadı',
    },
  };

  static String get currentLanguage => _currentLanguage;

  static void setLanguage(String languageCode) {
    if (_localizedValues.containsKey(languageCode)) {
      _currentLanguage = languageCode;
    }
  }

  static void setDeviceLocale() {
    final deviceLocale = ui.PlatformDispatcher.instance.locale.languageCode;
    if (_localizedValues.containsKey(deviceLocale)) {
      _currentLanguage = deviceLocale;
    } else {
      _currentLanguage = _defaultLanguage;
    }
  }

  static String tr(String key) {
    return _localizedValues[_currentLanguage]?[key] ??
        _localizedValues[_defaultLanguage]?[key] ??
        key;
  }

  static List<String> get supportedLanguages => _localizedValues.keys.toList();

  static String getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      case 'ru':
        return 'Русский';
      case 'ko':
        return '한국어';
      case 'zh':
        return '中文';
      case 'tr':
        return 'Türkçe';
      default:
        return languageCode;
    }
  }
}
