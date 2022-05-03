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
    return defaultTheme.copyWith(
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: defaultTheme.colorScheme.primary,
          primary: defaultTheme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
