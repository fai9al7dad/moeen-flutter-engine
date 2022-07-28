import 'package:dio/dio.dart' as Dio;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moeen/helpers/dio/API.dart';
import 'package:moeen/helpers/models/duos_model.dart';

class ViewDuoInvites extends StatefulWidget {
  const ViewDuoInvites({Key? key}) : super(key: key);

  @override
  State<ViewDuoInvites> createState() => _ViewDuoInvitesState();
}

class _ViewDuoInvitesState extends State<ViewDuoInvites> {
  late List<DuoInviteModel> invites;
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchInvites();
  }

  void fetchInvites() async {
    try {
      final Api api = Api();
      var response = await api.getDuosInvites();
      setState(() {
        invites = response;
        loading = false;
      });
    } on Dio.DioError catch (e) {
      print(e);
    }
  }

  void acceptOrRejectInvite({inviteID, type}) async {
    final Api api = Api();
    try {
      var r = await api.acceptOrRejectInvite(fromUserID: inviteID, type: type);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green[200],
          content: Text(
            type == "accept" ? "تم القبول 👍✅" : "تم الرفض 👍❌",
            style: TextStyle(color: Colors.green[900]),
          )));
      fetchInvites();
    } on Dio.DioError catch (e) {
      print(e.response?.data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red[200],
          content: Text(
            e.response?.data["message"],
            style: TextStyle(color: Colors.red[900]),
          )));
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
      child: ListView.separated(
          itemCount: invites.length,
          separatorBuilder: (context, index) => const Divider(
                thickness: 0.8,
                height: 1,
                color: Color(0xffe4e4e7),
              ),
          itemBuilder: (context, index) {
            int num = index + 1;
            return ListTile(
                tileColor: Colors.white,
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
                    style:
                        const TextStyle(color: Color(0xff047857), fontSize: 12),
                  )),
                ),
                title: Text("${invites[index].firstUser?.username}"),
                subtitle: Text("رقم المعرف: ${invites[index].firstUser?.id}"),
                trailing: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 130),
                  child: Row(
                    children: [
                      ElevatedButton(
                          onPressed: () => acceptOrRejectInvite(
                              inviteID: invites[index].firstUser?.id,
                              type: "accept"),
                          child: Text("قبول")),
                      TextButton(
                          onPressed: () => acceptOrRejectInvite(
                              inviteID: invites[index].firstUser?.id,
                              type: "reject"),
                          child: const Text(
                            "رفض",
                            style: TextStyle(color: Colors.red),
                          )),
                    ],
                  ),
                ));
          }),
    );
  }
}
