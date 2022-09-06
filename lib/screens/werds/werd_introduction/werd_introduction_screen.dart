import 'package:flutter/material.dart';

import 'package:moeen/components/CustomAppBar.dart';
import 'package:moeen/helpers/general/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WerdIntroductionScreen extends StatefulWidget {
  const WerdIntroductionScreen({Key? key}) : super(key: key);

  @override
  State<WerdIntroductionScreen> createState() => _WerdIntroductionScreenState();
}

class _WerdIntroductionScreenState extends State<WerdIntroductionScreen> {
  bool isChecked = false;
  void startWerd(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    if (isChecked) {
      await prefs.setBool("showWerdTutorial", false);
    }
    Navigator.pushNamedAndRemoveUntil(context, "/", (Route route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "بداية الورد",
        showBackButton: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color(0xff059669),
          onPressed: () => startWerd(context),
          icon: const Icon(Icons.rocket_launch_rounded),
          label: const Text("بدأ ")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "تنبيه",
                    style: TextStyle(
                        fontFamily: "montserrat-bold",
                        fontSize: 30,
                        shadows: const [
                          Shadow(
                              blurRadius: 0,
                              color: Color.fromARGB(255, 196, 177, 14),
                              offset: Offset(1, 1))
                        ],
                        color: Color(int.parse(MistakesColors.warning))),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.info_outline_rounded,
                    size: 30,
                    color: Color(int.parse(MistakesColors.warning)),
                    shadows: const [
                      Shadow(
                          blurRadius: 0,
                          color: Color.fromARGB(255, 196, 177, 14),
                          offset: Offset(1, 1))
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "انت الآن المصحح",
                style: TextStyle(fontFamily: "montserrat-bold", fontSize: 32),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "أمامك الآن سيظهر مصحف زميلك، بالتحديدات والأخطاء المسجلة في مصحفه. ",
                style: TextStyle(fontFamily: "montserrat"),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    // constraints: const BoxConstraints(minHeight: 0, minWidth: 0),
                    backgroundColor: Colors.red,
                    radius: 12,
                    child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => {},
                        icon: const Icon(
                          Icons.group,
                          size: 12,
                          color: Colors.white,
                        )),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    "لإنهاء الورد قم بالضغط على",
                    style: TextStyle(fontFamily: "montserrat"),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                "ملاحظة: عند تحديد خطأ او تنبيه، سيتم تسجيلها في الورد ولن تسجل في مصحفه حتى يقبل الورد",
                style: TextStyle(fontFamily: "montserrat"),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "عدم عرض هذا التنبيه مرة أخرى",
                    style: TextStyle(fontFamily: "montserrat", fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
