import 'package:flutter/material.dart';
import 'package:moeen/common/presentation/atoms/list_item.dart';
import 'package:moeen/helpers/general/GeneralHelpers.dart';
import 'package:moeen/helpers/models/werds_model.dart';
import 'package:moeen/providers/auth/auth_provider.dart';
import 'package:moeen/screens/werds/werd_highlights/view_werd_highlights.dart';
import 'package:provider/provider.dart';

class WerdCard extends StatefulWidget {
  final WerdsModel werd;
  final int index;
  final String type;
  final String duoName;
  const WerdCard(
      {Key? key,
      required this.werd,
      required this.index,
      required this.type,
      required this.duoName})
      : super(key: key);

  @override
  State<WerdCard> createState() => _WerdCardState();
}

class _WerdCardState extends State<WerdCard> {
  final DateTime now = DateTime.now();
  final GeneralHelpers _generalHelpers = GeneralHelpers();

  bool isNew = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfNew();
  }

  void checkIfNew() {
    final today = _generalHelpers.parseDate(
        date: DateTime(now.year, now.month, now.day).toString());
    final yesterday = _generalHelpers.parseDate(
        date: DateTime(now.year, now.month, now.day - 1).toString());
    final werdDate = _generalHelpers.parseDate(date: widget.werd.createdAt);

    if (werdDate == today || werdDate == yesterday) {
      setState(() {
        isNew = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListItem(
      index: widget.index,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ViewWerdHighlights(
                  werdID: widget.werd.id,
                  isAccepted: widget.werd.isAccepted,
                  type: widget.type))),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isNew)
            Text("جديد",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 12)),
          Text(
            widget.werd.reciterID ==
                    Provider.of<AuthProvider>(context, listen: false)
                        .authUser
                        ?.id
                ? "وردك"
                : "ورد ${widget.duoName}",
          ),
        ],
      ),
      trailing: SizedBox(
        width: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (widget.werd.isAccepted != true &&
                widget.werd.reciterID ==
                    Provider.of<AuthProvider>(context, listen: false)
                        .authUser
                        ?.id)
              Text(
                "لم تقبله",
                style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).primaryColor.withOpacity(0.7)),
              ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
      subtitle:
          Text("${_generalHelpers.parseDate(date: widget.werd.createdAt)}"),
    );
  }
}
