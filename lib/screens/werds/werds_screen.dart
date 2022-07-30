import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:moeen/components/CustomAppBar.dart';
import 'package:moeen/components/list_item.dart';
import 'package:moeen/helpers/dio/api.dart';
import 'package:moeen/helpers/general/constants.dart';
import 'package:moeen/helpers/models/highlights_model.dart';
import 'package:moeen/helpers/models/werds_model.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:moeen/providers/werd/werd_provider.dart';
import 'package:provider/provider.dart';

class WerdsScreen extends StatefulWidget {
  final int? duoID;
  final String? username;
  const WerdsScreen({Key? key, this.duoID, this.username}) : super(key: key);

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
    if (mounted) {
      setState(() {
        loading = false;
        werds = res;
      });
    }
  }

  String parseDate({date}) {
    var d = DateTime.parse(date);
    return "${d.year}-${d.month}-${d.day}";
  }

  void startWerd() async {
    var werd =
        await api.addWerd(duoID: widget.duoID, reciterID: werds![0].reciterID);

    var highlightsRes =
        await api.getHighlightsByUserID(userID: werds![0].reciterID);

    List<HighlightsModel> arr = [];

    for (var item in highlightsRes) {
      var color;
      switch (item.type) {
        case "warning":
          color = MistakesColors.warning;
          break;
        case "mistake":
          color = MistakesColors.mistake;
          break;
      }
      // arr.push({color: color, wordID: item.wordID});
      HighlightsModel data =
          HighlightsModel(color: item.color, wordID: item.wordID);
      arr.add(data);
    }

    Provider.of<WerdProvider>(context, listen: false).startWerd(creds: {
      "duoID": widget.duoID,
      "username": widget.username,
      "werdID": werd["id"]
    });
    Provider.of<QuranProvider>(context, listen: false)
        .setWerdMistakes(data: arr);
  }

  @override
  Widget build(BuildContext context) {
    // final args = ModalRoute.of(context)!.settings.arguments as DuosScreen;

    return Scaffold(
      appBar: const CustomAppBar(title: "الأوراد", showLoading: false),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color(0xff059669),
          onPressed: () => startWerd(),
          label: const Text("إضافة ورد")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: werds!.isNotEmpty
                      ? ListView.separated(
                          itemCount: werds!.length,
                          separatorBuilder: (context, index) => const Divider(
                                thickness: 0.8,
                                height: 1,
                                color: Color(0xffe4e4e7),
                              ),
                          itemBuilder: (context, index) {
                            return ListItem(
                                index: index,
                                title: parseDate(date: werds![index].createdAt),
                                subtitle: "رقم المعرف: ${werds![index].id}");
                          })
                      : const Center(child: Text("لا يوجد أوراد بينكم"))),
            ),
    );
  }
}
