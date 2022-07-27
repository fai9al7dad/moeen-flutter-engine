import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:moeen/components/CustomButton.dart';
import 'package:moeen/components/CustomInput.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "تسجيل الدخول",
            style: TextStyle(fontFamily: "montserrat", fontSize: 14),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'حياكم الله 👋',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontFamily: "montserrat-bold",
                      fontSize: 30,
                      color: Colors.green[500],
                      shadows: const [
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 0.5,
                          color: Color.fromARGB(80, 0, 0, 0),
                        ),
                      ]),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  'الرجاء تسجيل الدخول للإستمرار',
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontFamily: "montserrat",
                    fontSize: 12,
                    color: Colors.green[800],
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomInput(
                          prefixIcon: Icons.person,
                          label: "اسم المستخدم",
                          validator: (v) => null),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomInput(
                        prefixIcon: Icons.lock,
                        label: "كلمة المرور",
                        obsecureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'نسيت كلمة المرور ؟',
                            style: TextStyle(
                                fontFamily: "montserrat", fontSize: 10),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         // const RegisterPage(title: 'Register UI'),
                              //   ),
                              // );
                            },
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(3)),
                            child: const Text('اضغط هنا للإستعادة',
                                style: TextStyle(
                                    fontFamily: "montserrat", fontSize: 10)),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomButton(onPressed: () => {}, text: "ادخل"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'ليس لديك حساب ؟',
                            style: TextStyle(
                                fontFamily: "montserrat", fontSize: 10),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/register");
                            },
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(3)),
                            child: const Text('تسجيل حساب جديد',
                                style: TextStyle(
                                    fontFamily: "montserrat", fontSize: 10)),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
