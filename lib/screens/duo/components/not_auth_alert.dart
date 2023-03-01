import 'package:flutter/material.dart';
import 'package:moeen/components/CustomAppBar.dart';
import 'package:moeen/components/CustomButton.dart';

class NotAuthAlert extends StatelessWidget {
  const NotAuthAlert({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "الثنائيات",
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(
                  image: AssetImage("assets/images/not_auth_warning.png")),
              const SizedBox(height: 20),
              const Text(
                "تحتاج لأن تكون مسجل الدخول للإستمرار",
                style: TextStyle(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CustomButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/login");
                  },
                  text: "تسجيل الدخول | تسجيل حساب")
            ]),
      ),
    );
  }
}
