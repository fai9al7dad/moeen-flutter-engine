import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final int? index;
  final void Function()? onTap;
  final Widget? title;
  final Widget? subtitle;
  final IconData? trailingIcon;
  const ListItem(
      {Key? key,
      this.index,
      this.onTap,
      required this.title,
      required this.subtitle,
      this.trailingIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      onTap: onTap,
      leading: index != null
          ? Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: const Color(0xffecfdf5),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: const Color(0xffd1fae5))),
              child: Center(
                  child: Text(
                "${index! + 1}",
                style: const TextStyle(color: Color(0xff047857), fontSize: 12),
              )),
            )
          : null,
      title: title,
      subtitle: subtitle,
      trailing: Icon(
        trailingIcon,
        color: const Color(0xff059669),
      ),
    );
  }
}
