import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:moeen/components/CustomAppBar.dart';
import 'package:moeen/helpers/general/constants.dart';
import 'package:moeen/providers/auth/auth_provider.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool showAlertDialog = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'الاعدادات',
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) => SingleChildScrollView(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    if (authProvider.isAuth)
                      AuthUserInfo(
                          username: authProvider.authUser?.username,
                          userID: authProvider.authUser?.id),
                    const SizedBox(height: 20),
                    CustomListTile(
                      title: 'عن التطبيق',
                      icon: Icons.info_outline_rounded,
                      onTap: () {
                        Navigator.pushNamed(context, "/about-app");
                      },
                      isNavigation: true,
                    ),
                    const SizedBox(height: 20),
                    CustomListTile(
                        title: 'ارسال بلاغ',
                        icon: Icons.warning_amber_rounded,
                        onTap: () {},
                        isNavigation: false,
                        order: "first"),
                    CustomListTile(
                      title: 'ارسال اقتراح',
                      icon: Icons.chat_outlined,
                      onTap: () {},
                      isNavigation: false,
                    ),
                    if (authProvider.isAuth)
                      CustomListTile(
                          title: 'مزامنة البيانات على هذا الجهاز',
                          icon: Icons.sync,
                          onTap: () {},
                          isNavigation: false,
                          order: "last"),
                    const SizedBox(height: 20),
                    StyledContainer(
                        onTap: () => setState(() {
                              showAlertDialog = true;
                            }),
                        child: const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(
                            child: Text("تسجيل الخروج",
                                style: TextStyle(
                                    fontFamily: "montserrat-bold",
                                    fontSize: 14,
                                    color: Colors.red)),
                          ),
                        ))
                  ],
                ),
              ),
              if (showAlertDialog)
                AlertDialog(
                  actions: [
                    TextButton(
                      child: const Text(
                        'تسجيل الخروج',
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        authProvider.logout();
                      },
                    ),
                    TextButton(
                      child: Text(
                        'الغاء',
                        style: TextStyle(color: Colors.blueGrey.shade500),
                      ),
                      onPressed: () {
                        setState(() {
                          showAlertDialog = false;
                        });
                      },
                    ),
                  ],
                  title: const Text("هل فعلا تريد تسجيل الخروج ؟"),
                )
            ]),
          ),
        ),
      ),
    );
  }
}

class AuthUserInfo extends StatelessWidget {
  final String? username;
  final int? userID;
  const AuthUserInfo({
    Key? key,
    required this.userID,
    required this.username,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StyledContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "اسم المستخدم: $username",
              style: const TextStyle(fontFamily: "montserrat-bold"),
            ),
          ),
          Divider(
            color: Colors.grey.shade200,
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "رقم المستخدم: $userID ",
              style: const TextStyle(fontFamily: "montserrat-bold"),
            ),
          ),
        ],
      ),
    );
  }
}

class StyledContainer extends StatelessWidget {
  final Widget child;
  final Function()? onTap;
  const StyledContainer({Key? key, required this.child, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              color: const Color(0xffFFFCF7),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey.shade200, width: 1)),
          child: child),
    );
  }
}

class CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function() onTap;
  final bool isNavigation;
  final String order;
  const CustomListTile(
      {Key? key,
      required this.title,
      required this.icon,
      required this.onTap,
      this.order = "",
      required this.isNavigation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StyledContainer(
        child: GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Tertiary().s100,
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: Tertiary().s400,
                    )),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  title,
                  style: const TextStyle(fontFamily: "montserrat-bold"),
                ),
              ],
            ),
            if (isNavigation)
              Icon(
                Icons.chevron_right_outlined,
                color: Tertiary().s500,
              ),
          ],
        ),
      ),
    ));
  }
}
