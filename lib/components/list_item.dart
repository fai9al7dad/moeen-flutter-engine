import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ListItem extends StatelessWidget {
  final int index;
  final void Function()? onTap;
  final String? title;
  final String? subtitle;
  final IconData? trailingIcon;
  const ListItem(
      {Key? key,
      required this.index,
      this.onTap,
      required this.title,
      required this.subtitle,
      required this.trailingIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int num = index + 1;
    return ListTile(
      tileColor: Colors.white,
      onTap: onTap,
      leading: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            color: const Color(0xffecfdf5),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: const Color(0xffd1fae5))),
        child: Center(
            child: Text(
          num.toString(),
          style: const TextStyle(color: Color(0xff047857), fontSize: 12),
        )),
      ),
      title: Text("$title"),
      subtitle: Text("$subtitle"),
      trailing: Icon(
        trailingIcon,
        color: const Color(0xff059669),
      ),
    );
  }
}
