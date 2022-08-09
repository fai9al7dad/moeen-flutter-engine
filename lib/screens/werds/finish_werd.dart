import 'package:flutter/material.dart';
import 'package:moeen/components/CustomAppBar.dart';
import 'package:moeen/helpers/general/constants.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:provider/provider.dart';

class FinishWerd extends StatelessWidget {
  const FinishWerd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<QuranProvider>(
      builder: (context, quranProvider, child) => Scaffold(
          appBar: const CustomAppBar(
            title: "انهاء الورد",
            showLoading: false,
          ),
          floatingActionButton: Directionality(
            textDirection: TextDirection.rtl,
            child: FloatingActionButton.extended(
                backgroundColor: const Color(0xff059669),
                icon: const Icon(Icons.stop_circle_rounded),
                onPressed: () {
                  quranProvider.finishWerd();
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/", (Route route) => false);
                },
                label: const Text("إنهاء الورد")),
          ),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "انهاء وردك مع ${quranProvider.werd['username']} ؟",
                    style: const TextStyle(
                        fontSize: 20, fontFamily: "montserrat-bold"),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(int.parse(MistakesColors.mistake))),
                        height: 15,
                        width: 15,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "عدد الأخطاء ${quranProvider.werd['mistakesCounter']}",
                        style: const TextStyle(
                            fontSize: 14, fontFamily: "montserrat-bold"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(int.parse(MistakesColors.warning))),
                        height: 15,
                        width: 15,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "عدد التنبيهات ${quranProvider.werd['warningsCounter']}",
                        style: const TextStyle(
                            fontSize: 14, fontFamily: "montserrat-bold"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
