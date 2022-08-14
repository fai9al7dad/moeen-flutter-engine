import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';

import 'package:moeen/components/CustomAppBar.dart';
import 'package:moeen/components/CustomButton.dart';
import 'package:moeen/components/CustomInput.dart';
import 'package:moeen/helpers/dio/api.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomAppBar(title: "حساب جديد", showLoading: isLoading),
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
                          controller: usernameController,
                          prefixIcon: Icons.person_outline,
                          label: "اسم المستخدم",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'الرجاء ادخال اسم المستخدم';
                            }
                            return null;
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomInput(
                            controller: emailController,
                            prefixIcon: Icons.email_outlined,
                            label: "البريد الإلكتروني",
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء ادخال البريد الإلكتروني';
                              }
                              return null;
                            },
                          ),
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
                        controller: passwordController,
                        prefixIcon: Icons.lock_outline,
                        label: "كلمة المرور",
                        obsecureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء ادخال كلمة المرور';
                          }
                          if (value.length < 8) {
                            return 'الرجاء ادخال كلمة مرور لا تقل عن ثمانية أحرف';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomInput(
                        controller: confirmPasswordController,
                        prefixIcon: Icons.lock_outline,
                        label: "تأكيد كلمة المرور",
                        obsecureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء ادخال تأكيد كلمة المرور';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomButton(
                          onPressed: () {
                            Map payload = {
                              "username": usernameController.text,
                              "password": passwordController.text,
                              "email": emailController.text,
                              "confirmPassword": confirmPasswordController.text,
                            };
                            if (_formKey.currentState!.validate()) {
                              void register() async {
                                try {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  Api api = Api();
                                  await api.register(data: payload);
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          backgroundColor: Colors.green[200],
                                          content: Text(
                                            "تم تسجيل حسابك بنجاح يمكنك تسجيل الدخول الآن",
                                            style: TextStyle(
                                                color: Colors.green[900]),
                                          )));
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                } on Dio.DioError catch (e) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          backgroundColor: Colors.red[200],
                                          content: Text(
                                            e.response?.data["message"],
                                            style: TextStyle(
                                                color: Colors.red[900]),
                                          )));
                                } finally {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }

                              register();
                            }
                          },
                          text: "سجل"),
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
