import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    colorScheme: ColorScheme.fromSeed(
      seedColor: Color(0xFF1565C0),
    ),

    scaffoldBackgroundColor: Color(0xFFF5F7FB),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
    ),

    cardTheme: const CardThemeData(
      elevation: 0,
      margin: EdgeInsets.zero,
    ),
  );
}