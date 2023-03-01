import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final int? index;
  final void Function()? onTap;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final Widget? leading;
  final Color? iconColor;
  const ListItem(
      {Key? key,
      this.index,
      this.onTap,
      required this.title,
      this.subtitle,
      this.leading,
      this.iconColor,
      this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          border: Border.all(color: Theme.of(context).colorScheme.secondary),
          borderRadius: BorderRadius.circular(7)),
      child: ListTile(
        // tileColor: Theme.of(context).colorScheme.background,
        onTap: onTap,
        leading: index != null
            ? Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: const Color(0xFF10B981))),
                child: Center(
                    child: Text(
                  "${index! + 1}",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 12),
                )),
              )
            : leading,
        title: title,
        subtitle: subtitle,
        trailing: trailing,
        iconColor: iconColor,
      ),
    );
  }
}
