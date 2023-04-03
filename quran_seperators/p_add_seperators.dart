import 'package:flutter/material.dart';
import 'package:moeen/common/services/utils.dart';
import 'package:moeen/features/quran_seperators/seperators_provider.dart';
import 'package:moeen/features/quran_view/quran_models.dart';
import 'package:moeen/features/quran_view/quran_view_provider.dart';
import 'package:provider/provider.dart';

String replaceEnglishNumber(String input) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
// ٠١٢٣٤٥٦٧٨٩
  for (int i = 0; i < english.length; i++) {
    input = input.replaceAll(english[i], arabic[i]);
  }
  return input;
}
class AddSeperator extends StatelessWidget {
  final QuranEntity word;
  const AddSeperator({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    void navigateToQuranPage({required int page}) {
      Navigator.of(context).pop();

      Provider.of<QuranViewProvider>(context, listen: false)
          .navigateToQuranPage(page: (page - 1).toString());
    }

    return Consumer<SeperatorsProvider>(
      builder: (context, seperatorsProvider, child) => Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        height: 400,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("وضع فاصل",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
              const Text("اضفط مطولا للإنتقال إلى الموضع",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  )),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                    itemCount: seperatorsProvider.seperators.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          iconColor: Color(int.parse(
                              seperatorsProvider.seperators[index].color ??
                                  "0xffae8f74")),
                          leading:
                              seperatorsProvider.seperators[index].verseNumber != null
                                  ? const Icon(Icons.bookmark)
                                  : const Icon(Icons.bookmark_add_outlined),
                          trailing: seperatorsProvider.seperators[index].verseNumber !=
                                  null
                              ? IconButton(
                                  icon: Icon(
                                    Icons.chevron_right,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  onPressed: () => navigateToQuranPage(
                                      page: seperatorsProvider
                                          .seperators[index].pageNumber!))
                              : null,
                          onLongPress:
                              seperatorsProvider.seperators[index].pageNumber != null
                                  ? () => navigateToQuranPage(
                                      page: seperatorsProvider
                                          .seperators[index].pageNumber!)
                                  : null,
                          onTap: () {
                            Navigator.pop(context);
                            seperatorsProvider.addSeperator(
                                seperatorsProvider.seperators[index], word);
                          },
                          title: Text(
                            "${seperatorsProvider.seperators[index].name}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: seperatorsProvider.seperators[index].surah != null
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        "${seperatorsProvider.seperators[index].surah}surah",
                                        style: const TextStyle(
                                            fontSize: 22,
                                            letterSpacing: -3,
                                            fontFamily: "surahname")),
                                    Text(
                                        "أية ${replaceEnglishNumber(seperatorsProvider.seperators[index].verseNumber.toString())} صفحة ${replaceEnglishNumber(seperatorsProvider.seperators[index].pageNumber.toString())}",
                                        style: const TextStyle(fontSize: 14)),
                                  ],
                                )
                              : const Text(""));
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
