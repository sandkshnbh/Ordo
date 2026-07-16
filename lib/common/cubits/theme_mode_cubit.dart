import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeCubit extends Cubit<ThemeMode> {
  final SharedPreferences _prefs;

  ThemeModeCubit(this._prefs, [ThemeMode initial = ThemeMode.system])
    : super(initial);

  void toggle() {
    ThemeMode newMode;
    if (state == ThemeMode.dark) {
      newMode = ThemeMode.light;
    } else if (state == ThemeMode.light) {
      newMode = ThemeMode.system;
    } else {
      newMode = ThemeMode.dark;
    }
    setMode(newMode);
  }

  void setMode(ThemeMode mode) {
    emit(mode);
    _savePreference(mode);
  }

  void _savePreference(ThemeMode mode) {
    String modeString;
    switch (mode) {
      case ThemeMode.light:
        modeString = 'light';
        break;
      case ThemeMode.dark:
        modeString = 'dark';
        break;
      default:
        modeString = 'system';
    }
    _prefs.setString('theme_mode', modeString);
  }
}

class DynamicColorCubit extends Cubit<bool> {
  final SharedPreferences _prefs;

  DynamicColorCubit(this._prefs, [bool initial = false]) : super(initial);

  void toggle() {
    emit(!state);
    _savePreference();
  }

  void setEnabled(bool enabled) {
    emit(enabled);
    _savePreference();
  }

  void _savePreference() {
    _prefs.setBool('dynamic_color', state);
  }
}

class AmoledModeCubit extends Cubit<bool> {
  final SharedPreferences _prefs;

  AmoledModeCubit(this._prefs, [bool initial = false]) : super(initial);

  void toggle() {
    emit(!state);
    _savePreference();
  }

  void setEnabled(bool enabled) {
    emit(enabled);
    _savePreference();
  }

  void _savePreference() {
    _prefs.setBool('amoled_mode', state);
  }
}

class SpecialThemeCubit extends Cubit<bool> {
  final SharedPreferences _prefs;

  SpecialThemeCubit(this._prefs, [bool initial = false]) : super(initial);

  void toggle() {
    emit(!state);
    _savePreference();
  }

  void setEnabled(bool enabled) {
    emit(enabled);
    _savePreference();
  }

  void _savePreference() {
    _prefs.setBool('special_theme', state);
  }
}

class SkipWelcomeCubit extends Cubit<bool> {
  final SharedPreferences _prefs;

  SkipWelcomeCubit(this._prefs, [bool initial = false]) : super(initial);

  void toggle() {
    emit(!state);
    _savePreference();
  }

  void setEnabled(bool enabled) {
    emit(enabled);
    _savePreference();
  }

  void _savePreference() {
    _prefs.setBool('skip_welcome', state);
  }
}

class SendButtonStyleCubit extends Cubit<bool> {
  final SharedPreferences _prefs;

  SendButtonStyleCubit(this._prefs, [bool initial = false]) : super(initial);

  void toggle() {
    emit(!state);
    _savePreference();
  }

  void setSeparate(bool separate) {
    emit(separate);
    _savePreference();
  }

  void _savePreference() {
    _prefs.setBool('send_button_separate', state);
  }
}

class SwipeToDeleteCubit extends Cubit<bool> {
  final SharedPreferences _prefs;

  SwipeToDeleteCubit(this._prefs, [bool initial = false]) : super(initial);

  void toggle() {
    emit(!state);
    _savePreference();
  }

  void setEnabled(bool enabled) {
    emit(enabled);
    _savePreference();
  }

  void _savePreference() {
    _prefs.setBool('swipe_to_delete', state);
  }
}

class CompactModeCubit extends Cubit<bool> {
  final SharedPreferences _prefs;

  CompactModeCubit(this._prefs, [bool initial = false]) : super(initial);

  void toggle() {
    emit(!state);
    _savePreference();
  }

  void setEnabled(bool enabled) {
    emit(enabled);
    _savePreference();
  }

  void _savePreference() {
    _prefs.setBool('compact_mode', state);
  }
}

class NotificationsCubit extends Cubit<bool> {
  final SharedPreferences _prefs;

  NotificationsCubit(this._prefs, [bool initial = true]) : super(initial);

  void toggle() {
    emit(!state);
    _savePreference();
  }

  void setEnabled(bool enabled) {
    emit(enabled);
    _savePreference();
  }

  void _savePreference() {
    _prefs.setBool('notifications_enabled', state);
  }
}
