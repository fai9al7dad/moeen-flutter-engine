import 'package:flutter/material.dart';
import 'package:moeen/components/CustomAppBar.dart';
import 'package:moeen/components/CustomButton.dart';
import 'package:moeen/components/list_item.dart';
import 'package:moeen/helpers/dio/api.dart';
import 'package:moeen/helpers/models/werds_model.dart';

class WerdsScreen extends StatefulWidget {
  final int? duoID;
  const WerdsScreen({Key? key, this.duoID}) : super(key: key);

  @override
  State<WerdsScreen> createState() => _WerdsScreenState();
}

class _WerdsScreenState extends State<WerdsScreen> {
  List<WerdsModel>? werds = [];
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWerds();
  }

  Api api = Api();
  void getWerds() async {
    setState(() {
      loading = true;
    });
    List<WerdsModel>? res = await api.getWerds(duoID: widget.duoID);
    setState(() {
      loading = false;
      werds = res;
    });
  }

  String parseDate({date}) {
    var d = DateTime.parse(date);
    return "${d.year}-${d.month}-${d.day}";
  }

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as DuosScreen;

    return Scaffold(
      appBar: const CustomAppBar(title: "الأوراد", showLoading: false),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color(0xff059669),
          onPressed: () => {},
          label: const Text("إضافة ورد")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: werds!.isNotEmpty
                      ? ListView.builder(
                          itemCount: werds!.length,
                          itemBuilder: (context, index) {
                            return ListItem(
                                index: index,
                                title: parseDate(date: werds![index].createdAt),
                                // onTap: () =>
                                //     sendInvite(toUserID: searchResult![index].id),
                                subtitle: "رقم المعرف: ${werds![index].id}",
                                trailingIcon: Icons.chevron_right);
                          })
                      : const Center(child: Text("لا يوجد أوراد بينكم"))),
            ),
    );
  }
}
