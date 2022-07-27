import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:moeen/components/CustomButton.dart';
import 'package:moeen/components/CustomInput.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "حساب جديد",
            style: TextStyle(fontFamily: "montserrat", fontSize: 14),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'مستخدم جديد 🥳',
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
                  'الرجاء تسجيل حساب للإستمرار',
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
                          prefixIcon: Icons.person_outline,
                          label: "اسم المستخدم",
                          validator: (v) => null),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomInput(
                              prefixIcon: Icons.email_outlined,
                              label: "البريد الإلكتروني",
                              validator: (v) => null),
                          const SizedBox(
                            height: 5,
                          ),
                          const Text('تحتاج الإيميل في حال نسيت كلمة المرور',
                              // textAlign: TextAlign.end,
                              style: TextStyle(
                                fontFamily: "montserrat",
                                fontSize: 10,
                                color: Colors.grey,
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomInput(
                        prefixIcon: Icons.lock_outline,
                        label: "كلمة المرور",
                        obsecureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomInput(
                        prefixIcon: Icons.lock_outline,
                        label: "تأكيد كلمة المرور",
                        obsecureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomButton(onPressed: () => {}, text: "سجل"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            'لديك حساب ؟',
                            style: TextStyle(
                                fontFamily: "montserrat", fontSize: 10),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/login");
                            },
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.all(3)),
                            child: const Text('تسجيل الدخول',
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
