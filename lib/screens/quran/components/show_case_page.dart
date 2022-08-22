import 'package:flutter/material.dart';
import 'package:moeen/components/CustomShowCase.dart';

import 'package:moeen/screens/quran/components/page_header.dart';
import 'package:moeen/screens/quran/components/page_words.dart';
import 'package:showcaseview/showcaseview.dart';

GlobalKey _one = GlobalKey();
GlobalKey _two = GlobalKey();
GlobalKey _three = GlobalKey();

class ShowCasePage extends StatefulWidget {
  final List page;
  final double fixedFontSizePercentage;
  final double fixedLineHeightPercentage;
  final double fixedFontSizePercentageForHeader;
  const ShowCasePage(
      {Key? key,
      required this.page,
      required this.fixedFontSizePercentage,
      required this.fixedFontSizePercentageForHeader,
      required this.fixedLineHeightPercentage})
      : super(key: key);

  @override
  State<ShowCasePage> createState() => _RenderPageState();
}

class _RenderPageState extends State<ShowCasePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ShowCaseWidget.of(context).startShowCase([_one, _two]);
      // ShowCaseWidget.of(context).startShowCase([_one]);
    });
  }

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return
        // Text(mistakes[0]['id'].toString()),
        Column(
      children: [
        SizedBox(
            height: widget.fixedFontSizePercentageForHeader < 13 ? 10 : 50),

        CustomShowCase(
          caseKey: _two,
          title: 'الشريط العلوي',
          description:
              'بالنقر على الأيقونة الخضراء يمكنك الانتقال الى صفحة الثنائيات وللإنتقال السريع في المصحف أنقر على اسم السورة أو رقم الصفحة',
          child: PageHeader(
            page: widget.page[0],
            fixedFontSizePercentageForHeader:
                widget.fixedFontSizePercentageForHeader,
          ),
        ),
        const SizedBox(height: 10),
        widget.page[0]["pageNumber"] == 1 || widget.page[0]["pageNumber"] == 2
            ? Expanded(
                child: Center(
                child: CustomShowCase(
                  caseKey: _one,
                  title: 'مصحفك',
                  description:
                      'هنا يمكنك مراجعة حفظك وستظهر الأخطاء والتنبيهات الخاصة بك ويمكنك تعديلها بالنقر عليها',
                  child: PageWords(
                    page: widget.page,
                    fixedFontSizePercentage: widget.fixedFontSizePercentage,
                    fixedLineHeightPercentage: widget.fixedLineHeightPercentage,
                  ),
                ),
              ))
            : PageWords(
                page: widget.page,
                fixedFontSizePercentage: widget.fixedFontSizePercentage,
                fixedLineHeightPercentage: widget.fixedLineHeightPercentage,
              ),
        // PageWords(page: page),
      ],
    );
  }
}
