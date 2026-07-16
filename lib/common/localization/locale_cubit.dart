import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  final SharedPreferences _prefs;

  LocaleCubit(this._prefs, Locale initial) : super(initial);

  static const String _key = 'locale';
  static const String systemTag = 'system';

  static const _supported = [
    'en', 'ar', 'ru', 'ko', 'fa', 'es', 'id', 'vi', 'zh',
    'es-MX', 'pt-BR', 'fil', 'ur', 'si', 'pl',
  ];

  bool get isSystem => _prefs.getString(_key) == systemTag;

  static Locale systemLocale() {
    final device = ui.PlatformDispatcher.instance.locale;
    if (_supported.contains(device.toLanguageTag())) return device;
    if (_supported.contains(device.languageCode)) return Locale(device.languageCode);
    return const Locale('en');
  }

  void setSystem() {
    final locale = systemLocale();
    emit(locale);
    _prefs.setString(_key, systemTag);
  }

  void setLocale(Locale locale) {
    if (!_supported.contains(locale.toLanguageTag())) return;
    emit(locale);
    _prefs.setString(_key, locale.toLanguageTag());
  }
}
