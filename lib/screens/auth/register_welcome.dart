import 'package:confetti/confetti.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:moeen/components/CustomAppBar.dart';
import 'package:moeen/components/CustomButton.dart';
import 'dart:math' as math;

import 'package:moeen/helpers/dio/api.dart';
import 'package:moeen/providers/auth/auth_provider.dart';
import 'package:provider/provider.dart';

class RegisterWelcome extends StatefulWidget {
  final Map<dynamic, dynamic>? payload;
  const RegisterWelcome({Key? key, this.payload}) : super(key: key);

  @override
  State<RegisterWelcome> createState() => _RegisterWelcomeState();
}

class _RegisterWelcomeState extends State<RegisterWelcome> {
  bool isConfettiPlaying = false;
  bool isLoading = false;
  final confettiController = ConfettiController();

  @override
  void initState() {
    super.initState();
    confettiController.play();
  }

  @override
  void dispose() {
    super.dispose();
    confettiController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      Scaffold(
          appBar: const CustomAppBar(title: "حساب جديد", showLoading: false),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const WelcomeMessage(),
                const SizedBox(),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: CustomButton(
                      onPressed: () async {
                        if (isLoading == true) return;
                        try {
                          setState(() {
                            isLoading = true;
                          });
                          Api api = Api();

                          Response res = await api.login(data: widget.payload);
                          // ignore: use_build_context_synchronously
                          Provider.of<AuthProvider>(context, listen: false)
                              .login(creds: res.data);
                          Navigator.of(context).popUntil(
                              ModalRoute.withName('/extra-screens-container'));
                        } catch (e) {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      text: "الإستمرار"),
                ),
              ],
            ),
          )),
      ConfettiWidget(
        confettiController: confettiController,
        blastDirectionality: BlastDirectionality.explosive,
        blastDirection: math.pi / 2,
        shouldLoop: true,
      )
    ]);
  }
}

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "يا مرحبا",
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).primaryColor.withOpacity(0.8),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "الآن يمكنك الإستفادة من ميزة الثنائيات، وميزات أخرى ستضاف لاحقا باذن الله",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }
}
