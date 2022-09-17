import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyTheme {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFF1F2937),
    fontFamily: "montserrat",
    primaryColor: Colors.white,
    colorScheme: const ColorScheme.dark().copyWith(
        primary: const Color(0xFF10B981),
        background: const Color(0xFF374151),
        secondaryContainer: const Color(0xff4A576B),
        secondary: const Color(0xFF4B5563)),
  );
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFFF7F0E7),
    fontFamily: "montserrat",
    primaryColor: Colors.black,
    textTheme: const TextTheme(),
    colorScheme: const ColorScheme.light().copyWith(
        primary: const Color(0xFF10B981),
        background: const Color(0xFFFEFCF7),
        secondaryContainer: const Color(0xFFE8E3D7),
        secondary: const Color(0xFFE5E7EB)),
  );
}
