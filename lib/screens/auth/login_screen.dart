import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';

import 'package:moeen/components/CustomAppBar.dart';
import 'package:moeen/components/CustomButton.dart';
import 'package:moeen/components/CustomInput.dart';
import 'package:moeen/helpers/dio/api.dart';
import 'package:moeen/providers/auth/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomAppBar(title: "تسجيل الدخول", showLoading: isLoading),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Container(
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
                            controller: usernameController,
                            prefixIcon: Icons.person_outline,
                            label: "اسم المستخدم",
                            validator: (v) => null),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomInput(
                          controller: passwordController,
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
                                Navigator.pushNamed(
                                    context, "/forgot-password");
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
                        CustomButton(
                            onPressed: () {
                              Map payload = {
                                "password": passwordController.text,
                                "username": usernameController.text,
                              };
                              if (_formKey.currentState!.validate()) {
                                void login() async {
                                  try {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    Api api = Api();

                                    Dio.Response res =
                                        await api.login(data: payload);
                                    // ignore: use_build_context_synchronously
                                    Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .login(creds: res.data);
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

                                login();
                              }
                            },
                            text: "ادخل"),
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
      ),
    );
  }
}
