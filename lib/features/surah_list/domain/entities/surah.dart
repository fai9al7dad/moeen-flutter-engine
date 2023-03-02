class Surah {
  int? id;
  String? revelationPlace;
  int? revelationOrder;
  bool? bismillahPre;
  String? nameSimple;
  String? nameComplex;
  String? nameArabic;
  int? versesCount;
  List<int>? pages;
  TranslatedName? translatedName;

  Surah(
      {this.id,
      this.revelationPlace,
      this.revelationOrder,
      this.bismillahPre,
      this.nameSimple,
      this.nameComplex,
      this.nameArabic,
      this.versesCount,
      this.pages,
      this.translatedName});

  Surah.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    revelationPlace = json['revelation_place'];
    revelationOrder = json['revelation_order'];
    bismillahPre = json['bismillah_pre'];
    nameSimple = json['name_simple'];
    nameComplex = json['name_complex'];
    nameArabic = json['name_arabic'];
    versesCount = json['verses_count'];
    pages = json['pages']?.cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['revelation_place'] = revelationPlace;
    data['revelation_order'] = revelationOrder;
    data['bismillah_pre'] = bismillahPre;
    data['name_simple'] = nameSimple;
    data['name_complex'] = nameComplex;
    data['name_arabic'] = nameArabic;
    data['verses_count'] = versesCount;
    data['pages'] = pages;
    if (translatedName != null) {
      data['translated_name'] = translatedName?.toJson();
    }
    return data;
  }
}

class TranslatedName {
  String? languageName;
  String? name;

  TranslatedName({this.languageName, this.name});

  TranslatedName.fromJson(Map<String, dynamic> json) {
    languageName = json['language_name'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['language_name'] = languageName;
    data['name'] = name;
    return data;
  }
}
