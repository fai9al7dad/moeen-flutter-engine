import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

PageController controller = PageController();

class OnBoarding extends StatelessWidget {
  OnBoarding({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> slides = [
    {
      "title": "التنبيهات",
      "body": "يمكنك وضع تنبيه بالضغط على الكلمة مرة واحدة فقط",
      "img": "assets/images/onboarding/warning.png",
    },
    {
      "title": "الأخطاء",
      "body":
          "يمكنك وضع خطأ بالضغط على الكلمة مرتين أو بالضغط على كلمة بها تنبيه",
      "img": "assets/images/onboarding/mistake.png",
    },
    {
      "title": "تصفح مصفحك",
      "body":
          "هنا يمكنك مراجعة حفظك وستظهر الأخطاء والتنبيهات الخاصة بك، يمكنك تعديلها بالنقر عليها",
      "img": "assets/images/onboarding/quran.png",
    },
    {
      "title": "المتابعة بالصفحة",
      "body":
          "يمكنك رؤية مجمل الأخطاء و التنبيهات في الصفحة عن طريق النظر الى الشريط العلوي",
      "img": "assets/images/onboarding/page_header.png",
    },
    {
      "title": "المتابعة بالسور",
      "body":
          "يمكنك معرفة عدد الأخطاء والتنبيهات لكل سورة عن طريق استعراض قائمة السور",
      "img": "assets/images/onboarding/surahs.png",
    },
    {
      "title": "البحث",
      "body":
          "في صفحة المصحف، قم بسحب الشاشة للأسفل للبحث عن الأية، السورة، أو الصفحة التي تريدها",
      "img": "assets/images/onboarding/search.png",
    },
    {
      "title": "تصحيح عن بعد",
      "body":
          "قم بالتصحيح عن بعد وذلك بإرسال دعوة إلى صديقك ثم بدأ ورد جديد معه ",
      "img": "assets/images/onboarding/duos.png",
    },
    {
      "title": "الثنائيات",
      "body":
          "عند اضافة صديقك سيكون هنالك صفحة تحتوي على جميع الأوراد بينكم، ويمكن بدأ ورد جديد في أي وقت، أو قبول ورد سابق ليضاف إلى مصحفك",
      "img": "assets/images/onboarding/werds.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
        controller: controller,
        itemCount: slides.length,
        reverse: true,
        itemBuilder: (context, index) {
          return Slide(
            slide: slides[index],
            index: index,
            len: slides.length,
          );
        });
  }
}

// create slides widget
class Slide extends StatelessWidget {
  final slide;
  final int index;
  final int len;
  const Slide({
    Key? key,
    required this.slide,
    required this.index,
    required this.len,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 0),
          Image.asset(
            slide["img"],
            width: 300,
          ),
          Column(children: [
            Text(slide["title"],
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text(slide["body"],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16)),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (index < len - 1)
                TextButton(
                    onPressed: () => controller.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut),
                    child: const Text("التالي")),
              if (index == len - 1)
                ElevatedButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setBool("finishedOnBoarding", true);
                      // Navigator.pushNamed(context, "/");
                    },
                    child: const Text("بدأ")),
              if (index > 0)
                TextButton(
                    onPressed: () => controller.previousPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut),
                    child: const Text("السابق"))
            ],
          )
        ],
      ),
    );
  }
}
