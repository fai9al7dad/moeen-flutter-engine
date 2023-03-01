import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:moeen/components/CustomAppBar.dart';
import 'package:moeen/components/list_item.dart';
import 'package:moeen/helpers/database/quran/quran_database_helper.dart';
import 'package:moeen/helpers/database/quran/quran_models.dart';
import 'package:moeen/helpers/database/words_colors/WordsColorsMap.dart';
import 'package:moeen/helpers/dio/api.dart';
import 'package:moeen/helpers/general/GeneralHelpers.dart';
import 'package:moeen/helpers/general/constants.dart';
import 'package:moeen/helpers/models/highlights_model.dart';
import 'package:moeen/providers/auth/auth_provider.dart';
import 'package:moeen/providers/theme/my_theme.dart';
import 'package:moeen/screens/contact/contactScreen.dart';
import 'package:moeen/screens/on_boarding/on_boarding.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool showAlertDialog = false;
  bool showSyncDialog = false;
  bool isLoadingSync = false;

  void onSync({userID}) async {
    if (isLoadingSync) return;
    final wcm = WordColorMap();
    final api = Api();
    final db = DatabaseHelper();

    List<HighlightsModel> colors =
        await api.getHighlightsByUserID(userID: userID);

    await wcm.deleteAllColors();
    await Future.forEach(colors, (HighlightsModel color) async {
      var colorFromType = GeneralHelpers().getColorFromType(color.type);

      Word word = await db.getWordByID(id: color.wordID);
      var data = WordColorMapModel(
          color: colorFromType,
          wordID: word.id,
          pageNumber: word.pageID,
          verseNumber: int.parse(word.verseNumber ?? "0"),
          chapterCode: word.chapterCode);
      await wcm.insertWord(data);
    });

    // show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green[200],
        content: Text(
          'تم المزامنة بنجاح',
          style: TextStyle(color: Colors.green[900]),
        )));
    setState(() {
      showSyncDialog = false;
    });
  }

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
                    children: AnimationConfiguration.toStaggeredList(
                      childAnimationBuilder: (widget) => SlideAnimation(
                        horizontalOffset: 50.0,
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                      children: [
                        if (authProvider.isAuth)
                          AuthUserInfo(
                              username: authProvider.authUser?.username,
                              userID: authProvider.authUser?.id),
                        const SizedBox(height: 20),
                        ListItem(
                          title: const Text('عن التطبيق'),
                          leading: const Icon(Icons.info_outline_rounded),
                          trailing: Icon(Icons.chevron_right,
                              color: Theme.of(context).colorScheme.primary),
                          onTap: () {
                            Navigator.pushNamed(context, "/about-app");
                          },
                        ),
                        ListItem(
                          title: const Text('تواصل معنا'),
                          leading: const Icon(Icons.chat_outlined),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContactScreen(
                                          authUserName:
                                              authProvider.authUser?.username,
                                          authEmail:
                                              authProvider.authUser?.email,
                                        )));
                          },
                        ),
                        ListItem(
                          title: const Text('شرح التطبيق'),
                          leading: const Icon(Icons.description_outlined),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OnBoarding(
                                          updateOnBoarding: () =>
                                              {Navigator.pop(context)},
                                        )));
                          },
                        ),
                        ListItem(
                          title: const Text('المظهر الليلي'),
                          leading: const Icon(Icons.mode_night_outlined),
                          trailing: Switch.adaptive(
                            value: Provider.of<ThemeProvider>(context,
                                    listen: false)
                                .isDarkMode,
                            activeColor: Theme.of(context).colorScheme.primary,
                            onChanged: (bool value) => {
                              Provider.of<ThemeProvider>(context, listen: false)
                                  .toggleTheme(value)
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (authProvider.isAuth)
                          ListItem(
                            title: const Text('مزامنة البيانات على هذا الجهاز'),
                            leading: const Icon(Icons.sync),
                            onTap: () {
                              setState(() {
                                showSyncDialog = true;
                              });
                            },
                          ),
                        const SizedBox(height: 20),
                        if (authProvider.isAuth)
                          ListItem(
                              onTap: () => setState(() {
                                    showAlertDialog = true;
                                  }),
                              title: const Center(
                                child: Text("تسجيل الخروج",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.red)),
                              ))
                      ],
                    ),
                  )),
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
                        setState(() {
                          showAlertDialog = false;
                        });
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
                ),
              if (showSyncDialog)
                AlertDialog(
                  actions: [
                    TextButton(
                      child: isLoadingSync
                          ? const CircularProgressIndicator(strokeWidth: 2)
                          : const Text(
                              'مزامنة',
                              style: TextStyle(color: Colors.red),
                            ),
                      onPressed: () {
                        onSync(userID: authProvider.authUser?.id);
                        setState(() {
                          isLoadingSync = true;
                        });
                      },
                    ),
                    TextButton(
                      child: Text(
                        'الغاء',
                        style: TextStyle(color: Colors.blueGrey.shade500),
                      ),
                      onPressed: () {
                        setState(() {
                          showSyncDialog = false;
                        });
                      },
                    ),
                  ],
                  title: const Text("هل فعلا تريد مزامنة البيانات ؟"),
                  content: const Text(
                      "سيتم إستبدال الاخطاء والتنبيهات الموجودة في هذا الجهاز، بالأخطاء والتنبيهات المربوطة بالحساب"),
                ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListItem(
          title: Text(
            "اسم المستخدم: $username",
            style: const TextStyle(),
          ),
        ),
        ListItem(
          title: Text(
            "رقم المستخدم: $userID ",
            style: const TextStyle(),
          ),
        ),
        ListItem(
          title: const Text("حذف الحساب"),
          trailing: Icon(
            Icons.delete_forever_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          onTap: () => Navigator.pushNamed(context, "/delete-user"),
        )
      ],
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
              borderRadius: BorderRadius.circular(0),
              border: Border.all(color: Colors.grey.shade200, width: 0.5)),
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
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
