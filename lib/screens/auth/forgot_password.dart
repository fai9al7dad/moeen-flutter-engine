import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:moeen/components/CustomAppBar.dart';
import 'package:moeen/components/CustomButton.dart';
import 'package:moeen/components/CustomInput.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'نسيت كلمة المرور ؟ 😔',
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
          'لا بأس أدخل بريدك الإلكتروني الذي سجلت به وستصلك رسالة منا',
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
                  prefixIcon: Icons.email_outlined,
                  label: "الإيميل",
                  validator: (v) => null),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 5,
              ),
              CustomButton(
                  onPressed: () => {widget.changeStep(2)}, text: "ادخل"),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'تم ارسال الرمز بنجاح',
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
          'الرجاء ادخال الرمز الذي وصلك على الإيميل، ثم غير كلمة المرور',
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
                  prefixIcon: Icons.numbers_outlined,
                  label: "الرمز",
                  validator: (v) => null),
              const SizedBox(
                height: 20,
              ),
              CustomInput(
                  prefixIcon: Icons.lock_outline,
                  obsecureText: true,
                  label: "الرقم السري الجديد",
                  validator: (v) => null),
              const SizedBox(
                height: 20,
              ),
              CustomInput(
                  prefixIcon: Icons.lock_outline,
                  obsecureText: true,
                  label: "أعد كتابة الرقم السري",
                  validator: (v) => null),
              const SizedBox(
                height: 20,
              ),
              CustomButton(
                  onPressed: () => {widget.changeStep(2)}, text: "ادخل"),
            ],
          ),
        )
      ],
    );
  }
}
