import 'package:flutter/material.dart';

class CardCustomizationProvider extends ChangeNotifier {
  bool _showShadow = true;
  bool get showShadow => _showShadow;
  void setShowShadow(bool value) {
    if (_showShadow != value) {
      _showShadow = value;
      notifyListeners();
    }
  }

  bool _useCustomColor = false;
  bool get useCustomColor => _useCustomColor;
  void setUseCustomColor(bool value) {
    if (_useCustomColor != value) {
      _useCustomColor = value;
      notifyListeners();
    }
  }

  Color _customColor = const Color(0xFF2196F3); // أزرق فاتح
  Color get customColor => _customColor;
  void setCustomColor(Color color) {
    _customColor = color;
    notifyListeners();
  }
}
