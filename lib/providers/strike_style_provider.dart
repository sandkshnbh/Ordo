import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StrikeStyle {
  straight, // خط مستقيم
  zigzag, // متعرج
  scribble, // تخريبش
  dashed, // متقطع
  wave, // موجي
  aqua, // مائي
  flame, // ناري
}

class StrikeStyleProvider extends ChangeNotifier {
  static const String _key = 'strike_style';
  StrikeStyle _style = StrikeStyle.scribble;

  StrikeStyle get style => _style;

  StrikeStyleProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_key);
    if (index != null && index >= 0 && index < StrikeStyle.values.length) {
      _style = StrikeStyle.values[index];
      notifyListeners();
    }
  }

  Future<void> setStyle(StrikeStyle style) async {
    _style = style;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, style.index);
    notifyListeners();
  }
}
