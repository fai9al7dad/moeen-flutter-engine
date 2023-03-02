import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moeen/features/quran/domain/usecases/quran_provider.dart';
import 'package:moeen/common/domain/use_cases/theme_provider.dart';
import 'package:moeen/screens/on_boarding_screen.dart';
import 'package:moeen/screens/quran/quran_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkOnBoarding();
    Provider.of<QuranProvider>(context, listen: false).getData();
    Provider.of<ThemeProvider>(context, listen: false).fetchTheme();
    // changeScreen(context);
  }

  void checkOnBoarding() async {
    final prefs = await SharedPreferences.getInstance();

    bool? finishedOnBoarding = prefs.getBool("finishedOnBoarding");

    if (finishedOnBoarding != true || finishedOnBoarding == null) {
      changeScreen(context, OnBoardingScreen.routeName);
    } else {
      changeScreen(context, QuranScreen.routeName);
    }
  }

  void changeScreen(context, route) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushNamedAndRemoveUntil(context, route, (Route route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container());
  }
}
