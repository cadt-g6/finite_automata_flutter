import 'package:flutter/material.dart';

class ThemeConfig {
  final bool isDarkMode;
  ThemeConfig(this.isDarkMode);

  factory ThemeConfig.dark() {
    return ThemeConfig(true);
  }

  factory ThemeConfig.light() {
    return ThemeConfig(false);
  }

  ThemeData get() {
    ThemeData defaultTheme = isDarkMode ? ThemeData.dark() : ThemeData.light();
    return defaultTheme.copyWith();
  }
}
