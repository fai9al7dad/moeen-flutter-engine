import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:moeen/providers/auth/auth_provider.dart';
import 'package:provider/provider.dart';

class DuosScreen extends StatelessWidget {
  const DuosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      if (!authProvider.isAuth) {
        return Text("not auth");
      }
      return Text("auth");
    });
  }
}
