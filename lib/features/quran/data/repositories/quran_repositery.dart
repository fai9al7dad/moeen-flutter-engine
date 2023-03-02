import 'package:moeen/features/quran/data/datasources/quran_database_api.dart';
import 'package:moeen/features/quran/domain/entities/quran_entities.dart';

class QuranRepository {
  final _quranDB = QuranDatabaseApi();
  Future<Quran> fetchQuran() async {
    Quran quran = await _quranDB.getJoinedQuran();
    return quran;
  }
}
