import 'package:flutter/material.dart';

// class ThemeType {
//   static String system = "system";
//   static String light = "light";
//   static String dark = "dark";
// }

class AppTheme extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;
  set mode(ThemeMode mode) {
    _mode = mode;
    notifyListeners();
  }
}
