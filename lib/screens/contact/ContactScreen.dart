import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:moeen/components/CustomAppBar.dart';
import 'package:moeen/components/CustomButton.dart';
import 'package:moeen/components/CustomInput.dart';
import 'package:moeen/helpers/dio/api.dart';
import 'package:moeen/providers/auth/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ContactScreen extends StatefulWidget {
  final String? authUserName;
  final String? authEmail;
  const ContactScreen({Key? key, this.authEmail, this.authUserName})
      : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  bool isLoading = false;
  bool showSyncDialog = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      nameController.text = widget.authUserName ?? "";

      emailController.text = widget.authEmail ?? "";
    });
  }

  void send({payload}) async {
    final api = Api();
    setState(() {
      isLoading = true;
    });
    try {
      await api.sendEmail(
        payload: payload,
      );
      nameController.clear();
      emailController.clear();
      titleController.clear();
      subjectController.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green[200],
          content: Text(
            'تم ارسال الإيميل بنجاح',
            style: TextStyle(color: Colors.green[900]),
          )));
      setState(() {
        isLoading = false;
      });
    } on DioError catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red[200],
          content: Text(
            "${e.response?.data["message"][0]}: حصل خطأ ما",
            style: TextStyle(color: Colors.red[900]),
          )));
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomAppBar(title: "تواصل معنا", showLoading: isLoading),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'يا مرحبا 👋',
                        textAlign: TextAlign.start,
                        style: TextStyle(
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
                        'نسعد جدا لسماع اقتراحاتكم والتعليقات والاقتراحات الخاصة بالتطبيق',
                        textAlign: TextAlign.right,
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
                              controller: nameController,
                              prefixIcon: Icons.person_outline,
                              label: "اسمك",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء ادخال اسمك';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomInput(
                                  controller: emailController,
                                  prefixIcon: Icons.email_outlined,
                                  label: "ايميلك",
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'الرجاء ادخال ايميلك';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                    'نحتاج الإيميل، لكي نتمكن من الرد عليك',
                                    // textAlign: TextAlign.end,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomInput(
                              controller: titleController,
                              prefixIcon: Icons.subject_rounded,
                              label: "عنوان الرسالة",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء ادخال عنوان الرسالة';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomInput(
                              controller: subjectController,
                              prefixIcon: Icons.subject_rounded,
                              keyboardType: TextInputType.multiline,
                              minLines: 5,
                              maxLength: 255,
                              maxLines: 5,
                              label: "موضوع الرسالة",
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء ادخال موضوع الرسالة';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomButton(
                                onPressed: () async {
                                  PackageInfo packageInfo =
                                      await PackageInfo.fromPlatform();

                                  String version = packageInfo.version;

                                  Map payload = {
                                    "name": nameController.text,
                                    "email": emailController.text,
                                    "title": titleController.text,
                                    "subject":
                                        "\nالإصدار: $version\n  ${subjectController.text}",
                                  };
                                  if (_formKey.currentState!.validate() &&
                                      !isLoading) {
                                    send(payload: payload);
                                  }
                                },
                                text: "ارسل"),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
