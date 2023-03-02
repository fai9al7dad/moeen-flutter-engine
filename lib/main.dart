import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moeen/common/data/data_sources/router.dart';
import 'package:moeen/features/quran/domain/usecases/quran_provider.dart';
import 'package:moeen/features/quran_search/domain/usecases/quran_search_provider.dart';
import 'package:moeen/common/domain/use_cases/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';
// import 'package:device_preview/device_preview.dart';

void main() {
  // debugRepaintRainbowEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
      ChangeNotifierProvider<QuranProvider>(create: (_) => QuranProvider()),
      ChangeNotifierProvider<QuranSearchProvider>(
          create: (_) => QuranSearchProvider()),
    ],
    child: const MyApp(), // Wrap your app
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) => ShowCaseWidget(
          builder: Builder(
        builder: (context) => MaterialApp(
          builder: (context, Widget? child) => Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          ),
          useInheritedMediaQuery: true,
          routes: CustomRouter.routes,
          // locale: DevicePreview.locale(context),
          // builder: DevicePreview.appBuilder,
          title: 'تطبيق معين',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: MyTheme.lightTheme,
          darkTheme: MyTheme.darkTheme,
        ),
      )),
    );
  }
}
