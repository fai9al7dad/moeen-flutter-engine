import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moeen/helpers/general/constants.dart';
import 'package:moeen/providers/auth/auth_provider.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:moeen/providers/werd/werd_provider.dart';
import 'package:moeen/screens/quran/render_quran_list.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:showcaseview/showcaseview.dart';

void main() {
  // debugRepaintRainbowEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
      ChangeNotifierProvider<WerdProvider>(create: (_) => WerdProvider()),
      ChangeNotifierProvider<QuranProvider>(create: (_) => QuranProvider()),
    ],
    child: DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      routes: CustomRouter.routes,
      title: 'تطبيق معين',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "montserrat",
        scaffoldBackgroundColor: const Color(0xfffff8ed),
        // scaffoldBackgroundColor: const Color(0xff1f2937),
        primarySwatch: Colors.green,
      ),
    );
  }
}

// class Word extends StatefulWidget {
//   var word;
//   var pageID;
//   Word({Key? key, this.word, this.pageID}) : super(key: key);

//   @override
//   State<Word> createState() => _WordState();
// }

// class _WordState extends State<Word> {
//   Color changedColor = Colors.black;

//   changeColor() {
//     setState(() {
//       changedColor = Colors.red;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Text.rich(TextSpan(
//         text:widget.word,
//     )); 
//   }
// }
// style: TextStyle(
//             fontSize: 22,
//             fontFamily: "p${widget.pageID}",
//             color: changedColor,
//             shadows: const [
//               Shadow(
//                 offset: Offset(0, 0),
//                 blurRadius: 0.5,
//                 color: Color.fromARGB(255, 0, 0, 0),
//               ),
//             ]),