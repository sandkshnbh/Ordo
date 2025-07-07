import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  // استدعِ هذه الدالة عند بدء التطبيق
  void setInitialLocale(List<Locale> supportedLocales, Locale deviceLocale) {
    if (_locale != null) return; // لا تغير إذا تم التعيين مسبقاً
    for (final locale in supportedLocales) {
      if (locale.languageCode == deviceLocale.languageCode) {
        _locale = locale;
        notifyListeners();
        return;
      }
    }
    // إذا لم تكن لغة الجهاز مدعومة، اجعلها افتراضياً العربية
    _locale = const Locale('ar');
    notifyListeners();
  }

  void setLocale(Locale locale) {
    if (_locale == locale) return;
    _locale = locale;
    notifyListeners();
  }
}
