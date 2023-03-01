import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:moeen/components/CustomAppBar.dart';
import 'package:moeen/components/CustomButton.dart';
import 'package:moeen/components/CustomInput.dart';
import 'package:moeen/helpers/dio/api.dart';

TextEditingController emailController = TextEditingController();
TextEditingController tokenController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  int step = 1;
  void changeStep(newStep) {
    setState(() {
      step = newStep;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const CustomAppBar(title: "استعادة كلمة المرور"),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: step == 1
                  ? Step1(changeStep: changeStep)
                  : Step2(changeStep: changeStep),
            ),
          ),
        ),
      ),
    );
  }
}

class Step1 extends StatefulWidget {
  final void Function(dynamic) changeStep;
  const Step1({
    Key? key,
    required this.changeStep,
  }) : super(key: key);

  @override
  State<Step1> createState() => _Step1State();
}

class _Step1State extends State<Step1> {
  final _formKey = GlobalKey<FormState>();
  void sendToken() async {
    if (_formKey.currentState!.validate()) {
      // await Future.delayed(Duration(seconds: 1));
      final api = Api();
      try {
        await api.createForgotPasswordToken(
          email: emailController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green[200],
            content: Text(
              "تم ارسال رابط استعادة كلمة المرور الى البريد الخاص بك",
              style: TextStyle(color: Colors.green[900]),
            )));
        widget.changeStep(2);
      } on DioError catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red[200],
            content: Text(
              e.response?.data["message"],
              style: TextStyle(color: Colors.red[900]),
            )));
      }
      // widget.changeStep(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'نسيت كلمة المرور ؟ 😔',
          textAlign: TextAlign.start,
          style:
              TextStyle(fontSize: 30, color: Colors.green[500], shadows: const [
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
          'لا بأس أدخل بريدك الإلكتروني الذي سجلت به وستصلك رسالة منا',
          textAlign: TextAlign.end,
          style: TextStyle(
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
                controller: emailController,
                prefixIcon: Icons.email_outlined,
                label: "الإيميل",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء ادخال البريد الإلكتروني';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 5,
              ),
              CustomButton(onPressed: () => sendToken(), text: "ارسل الرمز"),
            ],
          ),
        )
      ],
    );
  }
}

class Step2 extends StatefulWidget {
  final void Function(dynamic) changeStep;

  const Step2({Key? key, required this.changeStep}) : super(key: key);

  @override
  State<Step2> createState() => _Step2State();
}

class _Step2State extends State<Step2> {
  final _formKey = GlobalKey<FormState>();
  void verifyToken() async {
    if (_formKey.currentState!.validate()) {
      // await Future.delayed(Duration(seconds: 1));
      final api = Api();
      try {
        await api.verifyForgotPasswordToken(
          email: emailController.text,
          token: tokenController.text,
          password: passwordController.text,
          confirmPassword: confirmPasswordController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green[200],
            content: Text(
              "تم تأكيد الرمز الخاص بك، الآن يمكنك تسجيل الدخول برقمك السري الجديد",
              style: TextStyle(color: Colors.green[900]),
            )));
        Navigator.pop(context);
      } on DioError catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red[200],
            content: Text(
              e.response?.data["message"],
              style: TextStyle(color: Colors.red[900]),
            )));
      }
      // widget.changeStep(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'تم ارسال الرمز بنجاح',
          textAlign: TextAlign.start,
          style:
              TextStyle(fontSize: 30, color: Colors.green[500], shadows: const [
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
          'الرجاء ادخال الرمز الذي وصلك على الإيميل، ثم غير كلمة المرور',
          textAlign: TextAlign.end,
          style: TextStyle(
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
                  controller: tokenController,
                  prefixIcon: Icons.numbers_outlined,
                  label: "الرمز",
                  validator: (v) => null),
              const SizedBox(
                height: 20,
              ),
              CustomInput(
                controller: passwordController,
                prefixIcon: Icons.lock_outline,
                obsecureText: true,
                label: "الرقم السري الجديد",
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
                  obsecureText: true,
                  label: "أعد كتابة الرقم السري",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'الرجاء ادخال كلمة المرور';
                    }
                    if (value.length < 8) {
                      return 'الرجاء ادخال كلمة مرور لا تقل عن ثمانية أحرف';
                    }
                    return null;
                  }),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                  onPressed: () => {verifyToken()}, text: "غير كلمة المرور"),
            ],
          ),
        )
      ],
    );
  }
}
