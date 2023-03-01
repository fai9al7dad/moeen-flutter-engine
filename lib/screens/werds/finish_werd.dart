import 'package:flutter/material.dart';
import 'package:moeen/common/presentation/atoms/CustomAppBar.dart';
import 'package:moeen/helpers/dio/api.dart';
import 'package:moeen/helpers/general/constants.dart';
import 'package:moeen/providers/quran/quran_provider.dart';
import 'package:provider/provider.dart';

class FinishWerd extends StatefulWidget {
  const FinishWerd({Key? key}) : super(key: key);

  @override
  State<FinishWerd> createState() => _FinishWerdState();
}

class _FinishWerdState extends State<FinishWerd> {
  late WerdDetails werdDetails;
  bool loading = true;
  @override
  void initState() {
    super.initState();

    fetchWerd();
  }

  void fetchWerd() async {
    final Api api = Api();

    var data = await api.getHighlightsByWerdID(
      werdID: Provider.of<QuranProvider>(context, listen: false).werd["werdID"],
    );
    int _mistakesCount = 0;
    int _warningsCount = 0;
    int _revertCount = 0;
    for (int i = 0; i < data.length; i++) {
      if (data[i].type == "mistake") {
        _mistakesCount++;
      }
      if (data[i].type == "warning") {
        _warningsCount++;
      }
      if (data[i].type == "revert") {
        _revertCount++;
      }
    }
    if (mounted) {
      setState(() {
        werdDetails = WerdDetails(
          mistakesCount: _mistakesCount,
          warningsCount: _warningsCount,
          revertCount: _revertCount,
        );
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuranProvider>(
      builder: (context, quranProvider, child) => Scaffold(
          appBar: const CustomAppBar(
            title: "انهاء الورد",
            showLoading: false,
          ),
          floatingActionButton: Directionality(
            textDirection: TextDirection.rtl,
            child: FloatingActionButton.extended(
                backgroundColor: const Color(0xff059669),
                icon: const Icon(Icons.stop_circle_rounded),
                onPressed: () {
                  quranProvider.finishWerd();
                  Navigator.pushNamedAndRemoveUntil(
                      context, "/", (Route route) => false);
                },
                label: const Text("إنهاء الورد",
                    style: TextStyle(color: Colors.white))),
          ),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "انهاء وردك مع ${quranProvider.werd['username']} ؟",
                    style: const TextStyle(
                        fontSize: 20, fontFamily: "montserrat-bold"),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 20),
                  loading
                      ? const CircularProgressIndicator()
                      : _counters(werdDetails),
                ],
              ),
            ),
          )),
    );
  }

  Column _counters(WerdDetails werdDetails) {
    return Column(children: [
      Row(
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(int.parse(MistakesColors.revert))),
            height: 15,
            width: 15,
          ),
          const SizedBox(width: 10),
          Text(
            "عدد التصحيحات ${werdDetails.revertCount}",
            style: const TextStyle(fontSize: 14, fontFamily: "montserrat-bold"),
          ),
        ],
      ),
      const SizedBox(height: 20),
      Row(
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(int.parse(MistakesColors.mistake))),
            height: 15,
            width: 15,
          ),
          const SizedBox(width: 10),
          Text(
            "عدد الأخطاء ${werdDetails.mistakesCount}",
            style: const TextStyle(fontSize: 14, fontFamily: "montserrat-bold"),
          ),
        ],
      ),
      const SizedBox(height: 20),
      Row(
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(int.parse(MistakesColors.warning))),
            height: 15,
            width: 15,
          ),
          const SizedBox(width: 10),
          Text(
            "عدد التنبيهات ${werdDetails.warningsCount}",
            style: const TextStyle(fontSize: 14, fontFamily: "montserrat-bold"),
          ),
        ],
      ),
    ]);
  }
}

class WerdDetails {
  int mistakesCount;
  int warningsCount;
  int revertCount;

  WerdDetails({
    required this.mistakesCount,
    required this.warningsCount,
    required this.revertCount,
  });
}
