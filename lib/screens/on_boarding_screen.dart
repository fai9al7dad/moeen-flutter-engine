import 'package:flutter/material.dart';
import 'package:moeen/features/on_boarding/presentation/p_on_boarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingScreen extends StatelessWidget {
  static const String routeName = "/onBoardingScreen";
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          title: const Text("الشرح",
              style: TextStyle(color: Colors.black, fontSize: 14)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              prefs.setBool("finishedOnBoarding", true);
            },
          ),
        ),
        body: OnBoarding());
  }
}
