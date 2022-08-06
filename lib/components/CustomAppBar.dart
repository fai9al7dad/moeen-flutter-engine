import 'package:flutter/material.dart';

import 'package:moeen/helpers/general/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool? showLoading;
  const CustomAppBar(
      {Key? key, required this.title, this.showLoading, this.actions})
      : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AppBar(
          title: Text(
            title,
            style: const TextStyle(fontFamily: "montserrat", fontSize: 14),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: Tertiary().s800,
          // elevation: 0.8,
          actions: actions,
          elevation: 0,
          bottom: showLoading == true
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(6.0),
                  child: LinearProgressIndicator(),
                )
              : null),
    );
  }
}
