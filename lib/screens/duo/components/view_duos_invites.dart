import 'dart:developer';

import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:moeen/components/CustomShowCase.dart';
import 'package:moeen/components/list_item.dart';
import 'package:moeen/helpers/dio/API.dart';
import 'package:moeen/helpers/models/duos_model.dart';
import 'package:moeen/screens/settings/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

GlobalKey _one = GlobalKey();

class ViewDuoInvites extends StatefulWidget {
  const ViewDuoInvites({Key? key}) : super(key: key);

  @override
  State<ViewDuoInvites> createState() => _ViewDuoInvitesState();
}

class _ViewDuoInvitesState extends State<ViewDuoInvites> {
  final Api api = Api();

  late List<DuoInviteModel> invites;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    fetchInvites();
    checkIfFirstTime();
  }

  void checkIfFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    bool? firstTime = prefs.getBool("seenDuoInvitesShowcase");
    if (firstTime == null || firstTime != true) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        return ShowCaseWidget.of(context).startShowCase([_one]);
      });
      await prefs.setBool("seenDuoInvitesShowcase", true);
    }
  }

  void fetchInvites() async {
    try {
      var recievedInvites = await api.getDuosInvites();
      var pendingInvites = await api.getPendingDuoInvites();
      List<DuoInviteModel> _invites = [];

      for (DuoInviteModel invite in recievedInvites) {
        _invites.add(DuoInviteModel(
            firstUser: invite.firstUser, id: invite.id, type: "recieved"));
      }
      for (DuoInviteModel invite in pendingInvites) {
        _invites.add(DuoInviteModel(
            firstUser: invite.secondUser, id: invite.id, type: "pending"));
      }
      if (mounted) {
        setState(() {
          invites = _invites;
          loading = false;
        });
      }
    } on Dio.DioError catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (invites.isEmpty) {
      return const Center(
        child: Text("لا يوجد لديك طلبات إضافة"),
      );
    }
    return Container(
      padding: const EdgeInsets.all(20),
      child: GroupedListView<dynamic, String>(
          elements: invites,
          // separatorBuilder: (context, index) => const Divider(
          //       thickness: 0.8,
          //     ),
          groupBy: (element) {
            return element.type;
          },
          groupSeparatorBuilder: (value) => SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 8.0, 8.0, 8.0),
                  child: Text(
                    value == "recieved" ? "طلبات إضافة" : "دعوات أرسلتها",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          separator: const Divider(
            height: 0,
            thickness: 0.8,
          ),
          order: GroupedListOrder.DESC,
          indexedItemBuilder: (context, element, index) {
            int num = 2 + 1;

            if (element.type == "recieved") {
              if (index == 0) {
                return CustomShowCase(
                    caseKey: _one,
                    title: "لديك طلب إضافة",
                    description: "بعد قبول الطلب، يمكنكم تصحيح مصاحفكم عن بعد ",
                    child: AcceptOrRejectInvite(
                        num: num,
                        index: 1,
                        id: element.firstUser?.id,
                        fetchInvites: fetchInvites,
                        username: element.firstUser?.username));
              }
              return AcceptOrRejectInvite(
                  num: num,
                  index: 1,
                  id: element.firstUser?.id,
                  fetchInvites: fetchInvites,
                  username: element.firstUser?.username);
            } else {
              return ListItem(
                title: Text("${element.firstUser?.username}"),
                subtitle: const Text("بإنتظار القبول"),
                trailing: TextButton(
                  child: Text("إلغاء",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary)),
                  onPressed: () async {
                    try {
                      await api.deletePendingDuoInvite(
                          toUserID: element.firstUser?.id);
                      fetchInvites();
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
              );
            }
          }),
    );
  }
}

class AcceptOrRejectInvite extends StatelessWidget {
  final int num;
  final int index;
  final String? username;
  final int? id;
  final Function? fetchInvites;
  const AcceptOrRejectInvite(
      {Key? key,
      required this.username,
      required this.id,
      required this.num,
      required this.fetchInvites,
      required this.index})
      : super(key: key);

  void acceptOrRejectInvite({inviteID, type, context}) async {
    final Api api = Api();
    // try {
    //   await api.acceptOrRejectInvite(fromUserID: inviteID, type: type);
    //   // ignore: use_build_context_synchronously
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       backgroundColor: Colors.green[200],
    //       content: Text(
    //         type == "accept" ? "تم القبول 👍✅" : "تم الرفض 👍❌",
    //         style: TextStyle(color: Colors.green[900]),
    //       )));
    //   fetchInvites!();
    // } on Dio.DioError catch (e) {
    //   print(e.response?.data);
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       backgroundColor: Colors.red[200],
    //       content: Text(
    //         e.response?.data["message"],
    //         style: TextStyle(color: Colors.red[900]),
    //       )));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ListItem(
        title: Text("${username}"),
        subtitle: Text("رقم المعرف: ${id}"),
        trailing: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 130),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                // crossAxisAlignment: Cr,\
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 25, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("قبول",
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.5),
                          fontSize: 10))
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                // crossAxisAlignment: Cr,\
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.highlight_off_outlined,
                      size: 25,
                      color: Theme.of(context).primaryColor.withOpacity(0.5)),
                  const SizedBox(
                    height: 5,
                  ),
                  Text("رفض",
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.5),
                          fontSize: 10))
                ],
              ),
              // ElevatedButton(
              //     onPressed: () => acceptOrRejectInvite(
              //         inviteID: id, type: "accept", context: context),
              //     child: const Text("قبول")),
              // TextButton(
              //     onPressed: () => acceptOrRejectInvite(
              //         inviteID: id, type: "reject", context: context),
              //     child: const Text(
              //       "رفض",
              //       style: TextStyle(color: Colors.red),
              //     )),
            ],
          ),
        ));
  }
}
