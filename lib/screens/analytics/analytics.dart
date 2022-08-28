import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:moeen/components/CustomAppBar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:moeen/helpers/database/words_colors/WordsColorsMap.dart';
import 'package:moeen/providers/auth/auth_provider.dart';
import 'package:moeen/screens/duo/components/not_auth_alert.dart';
import 'package:moeen/screens/surahList/surahs.dart';
import 'package:provider/provider.dart';

class Analytics extends StatefulWidget {
  const Analytics({Key? key}) : super(key: key);

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  final wcm = WordColorMap();
  List<ChartModel> barChartData = [];
  var surahs = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadJson();
  }

  bool _loading = true;
  void loadJson() async {
    List<ChartModel> _barChartData = [];
    String data = await rootBundle.loadString('assets/json/SURAHS.json');
    var jsonResult = json.decode(data);
    // var c = Surah.fromJson(jsonResult);
    // inspect(c);
    // List<Surah> chapters = jsonResult["chapters"];
    var chapters = jsonResult["chapters"];
    for (var chapter in chapters) {
      var chapterCode = chapter["id"].toString().padLeft(3, '0');
      var colors = await wcm.getChapterColors(chapterCode: chapterCode);
      _barChartData.add(
        ChartModel(
          id: chapter["id"],
          chapterName: chapter["name_arabic"],
          mistakesCount: colors["mistakes"] ?? 0,
          warningsCount: colors["warnings"] ?? 0,
        ),
      );
    }
    if (mounted) {
      setState(() {
        surahs = jsonResult["chapters"];
        barChartData = _barChartData;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget bottomTitles(double value, TitleMeta meta) {
      var e = surahs.firstWhere((element) => element["id"] == value);
      Widget text = Text(
        e["name_arabic"].toString(),
        style: const TextStyle(
          // color: Color(0xff7589a2),
          fontSize: 12,
        ),
      );

      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 2, //margin top
        child: text,
      );
    }

    return Consumer<AuthProvider>(builder: (context, authProvider, child) {
      return Scaffold(
          appBar: const CustomAppBar(
            title: 'الإحصائيات',
          ),
          body: _loading == true
              ? const Center(child: CircularProgressIndicator())
              : AspectRatio(
                  aspectRatio: 1,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    color: const Color(0xff2c4260),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: 2 * 15.9 * 114,
                          child: BarChart(
                            BarChartData(
                                groupsSpace: 10,
                                titlesData: FlTitlesData(
                                  show: true,
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        showTitles: true,
                                        // reservedSize: 20,
                                        getTitlesWidget: bottomTitles),
                                  ),
                                ),
                                alignment: BarChartAlignment.center,
                                maxY: 20,
                                minY: 0,
                                // groupsSpace: 12,
                                barTouchData: BarTouchData(enabled: true),
                                barGroups: barChartData
                                    .map((data) =>
                                        BarChartGroupData(x: data.id, barRods: [
                                          BarChartRodData(
                                            toY: data.mistakesCount.toDouble(),
                                            color: Colors.red,
                                            width: 12,
                                          ),
                                          BarChartRodData(
                                            toY: data.warningsCount.toDouble(),
                                            color: Colors.yellow,
                                            width: 12,
                                          ),
                                        ]))
                                    .toList()),
                          ),
                        ),
                      ),
                    ),
                  ),
                ));
    });
  }
}

class ChartModel {
  final int id;
  final String chapterName;
  final int mistakesCount;
  final int warningsCount;
  ChartModel(
      {required this.id,
      required this.chapterName,
      required this.mistakesCount,
      required this.warningsCount});
}
