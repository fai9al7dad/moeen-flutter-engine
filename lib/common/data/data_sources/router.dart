import 'package:moeen/screens/on_boarding_screen.dart';
import 'package:moeen/screens/quran/quran_screen.dart';
import 'package:moeen/screens/quran/surah_list_screen.dart';
import 'package:moeen/screens/splash_screen.dart';

class CustomRouter {
  static var routes = {
    '/': (context) => const SplashScreen(),
    OnBoardingScreen.routeName: (context) => const OnBoardingScreen(),
    QuranScreen.routeName: (context) => const QuranScreen(),
    SurahListScreen.routeName: (context) => const SurahListScreen(),
    // '/surah-list': (context) => const SurahTabsWrapper(),
    // '/login': (context) => const LoginScreen(),
    // '/duos': (context) => const DuosScreen(),
    // '/register': (context) => const RegisterScreen(),
    // '/forgot-password': (context) => const ForgotPassword(),
    // '/register-welcome': (context) => const RegisterWelcome(),
    // '/search-users': (context) => const SearchUsers(),
    // '/werds': (context) => const WerdsScreen(),
    // '/finish-werd': (context) => const FinishWerd(),
    // '/view-werd-highlights': (context) => const ViewWerdHighlights(),
    // '/settings': (context) => const Settings(),
    // '/delete-user': (context) => const DeleteUserScreen(),
    // '/about-app': (context) => const AboutApp(),
    // '/contact-us': (context) => const ContactScreen(),
    // '/werd-introduction': (context) => const WerdIntroductionScreen(),
    // '/extra-screens-container': (context) => const ExtraScreensContainer(),
  };
}
