import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode => themeMode == ThemeMode.dark;

  // fetch theme from shared preferences
  Future<void> fetchTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getBool('isDarkMode');
    if (theme == true) {
      themeMode = ThemeMode.dark;
    } else if (theme == false) {
      themeMode = ThemeMode.light;
    } else {
      themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  void toggleTheme(bool isOn) async {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isOn);
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
