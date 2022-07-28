import 'package:moeen/screens/auth/forgot_password.dart';
import 'package:moeen/screens/auth/login_screen.dart';
import 'package:moeen/screens/auth/register_screen.dart';
import 'package:moeen/screens/duo/duosScreen.dart';
import 'package:moeen/screens/quran/render_quran_list.dart';
import 'package:moeen/screens/surahList/surah_list.dart';

class MistakesColors {
  static const warning = "0xfff59e0b";
  static const mistake = "0xffe11d48";
  static const revert = "0xff000000";
}

class CustomColors {
  static const textColor = "0xffae8f74";
}

class CustomRouter {
  static var routes = {
    '/': (context) => const RenderQuranList(),
    '/surah-list': (context) => const SurahList(),
    '/login': (context) => const LoginScreen(),
    '/duos': (context) => const DuosScreen(),
    '/register': (context) => const RegisterScreen(),
    '/forgot-password': (context) => const ForgotPassword(),
  };
}
