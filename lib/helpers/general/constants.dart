import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moeen/screens/about/about_app.dart';
import 'package:moeen/screens/auth/forgot_password.dart';
import 'package:moeen/screens/auth/login_screen.dart';
import 'package:moeen/screens/auth/register_screen.dart';
import 'package:moeen/screens/delete_user/delete_user_screen.dart';
import 'package:moeen/screens/duo/duosScreen.dart';
import 'package:moeen/screens/on_boarding/on_boarding.dart';
import 'package:moeen/screens/quran/render_quran_list.dart';
import 'package:moeen/screens/search_users/search_users.dart';
import 'package:moeen/screens/settings/settings.dart';
import 'package:moeen/screens/surahList/surah_list.dart';
import 'package:moeen/screens/werds/finish_werd.dart';
import 'package:moeen/screens/werds/werd_highlights/view_werd_highlights.dart';
import 'package:moeen/screens/werds/werds_screen.dart';

class MistakesColors {
  static const warning = "0xfff59e0b";
  static const mistake = "0xffe11d48";
  static const revert = "0xff000000";
}

class CustomRouter {
  static var routes = {
    '/': (context) => const RenderQuranList(),
    '/surah-list': (context) => const SurahList(),
    '/login': (context) => const LoginScreen(),
    '/duos': (context) => const DuosScreen(),
    '/register': (context) => const RegisterScreen(),
    '/forgot-password': (context) => const ForgotPassword(),
    '/search-users': (context) => const SearchUsers(),
    '/werds': (context) => const WerdsScreen(),
    '/finish-werd': (context) => const FinishWerd(),
    '/view-werd-highlights': (context) => const ViewWerdHighlights(),
    '/settings': (context) => const Settings(),
    '/delete-user': (context) => const DeleteUserScreen(),
    '/about-app': (context) => const AboutApp(),
  };
}

class Tertiary {
  final Color s50 = const Color(0xffecfdf5);
  final Color s100 = const Color(0xffd1fae5);
  final Color s200 = const Color(0xffa7f3d0);
  final Color s300 = const Color(0xff6ee7b7);
  final Color s400 = const Color(0xff34d399);
  final Color s500 = const Color(0xff10b981);
  final Color s600 = const Color(0xff059669);
  final Color s700 = const Color(0xff047857);
  final Color s800 = const Color(0xff065f46);
  final Color s900 = const Color(0xff064e3b);

  Tertiary();
}
