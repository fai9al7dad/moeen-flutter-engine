import 'package:flutter/material.dart';

import 'package:moeen/providers/auth/auth_provider.dart';
import 'package:moeen/screens/duo/components/NotAuthAlert.dart';
import 'package:provider/provider.dart';

class DuosScreen extends StatelessWidget {
  const DuosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      if (!authProvider.isAuth) {
        return const NotAuthAlert();
      }
      return DefaultTabController(
        length: 2,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              // elevation: 0,
              title: const Text(
                "اختر الثنائي",
                style: TextStyle(fontFamily: "montserrat", fontSize: 14),
              ),
              centerTitle: true,
              bottom: const TabBar(tabs: [
                Tab(text: "الثنائيات"),
                Tab(text: "طلبات الإضافة"),
              ]),
            ),
            body: const TabBarView(children: [
              Text("page 1"),
              Text("page 2"),
            ]),
          ),
        ),
      );
    });
  }
}
