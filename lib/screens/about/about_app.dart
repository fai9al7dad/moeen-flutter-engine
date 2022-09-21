import 'package:flutter/material.dart';

import 'package:moeen/components/CustomAppBar.dart';
import 'package:moeen/components/list_item.dart';
import 'package:moeen/screens/settings/settings.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(
          title: 'عن التطبيق',
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: const Image(
                  image: AssetImage('assets/images/logo.png'),
                  height: 100,
                ),
              ),
              const SizedBox(height: 5),
              const Text("تطبيق معين", style: TextStyle(fontSize: 14)),
              const SizedBox(height: 5),
              Text("الإصدار 1.0.0",
                  style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).primaryColor.withOpacity(0.5))),
              const SizedBox(height: 20),
              const ListItem(
                title: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    textAlign: TextAlign.right,
                    "تطبيق معين هو تطبيق يهدف الى المساعدة في تقوية الحفظ وتثبيت المراجعة عن طريق معرفة نقاط الضعف من خلال التحديد على التنبيهات والأخطاء",
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
