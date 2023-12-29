import 'package:gurbani_app/models/baani_lines_model.dart';
import 'package:gurbani_app/models/db_result.dart';
import 'package:gurbani_app/models/nitnem_model.dart';
import 'data_service.dart';

int bookOneStartsAt = 1;
int bookOneEndsAt = 60555;
int bookTwoStartsAt = 60556;
int bookTwoEndsAt = 128313;
int bookThreeStartsAt = 128314;
int bookThreeEndsAt = 135898;
int bookFourStartsAt =135899;
int bookFourEndsAt =138659;
int bookFiveStartsAt = 138660;
int bookFiveEndsAt = 139465;
int bookSixStartsAt = 139466;
int bookSixEndsAt = 140486;
int bookSevenStatsAt =140487;
int bookSevenEndsAt =140817;
int bookEightStatsAt =140818;
int bookEightEndsAt =141169;
int bookNineStatsAt =141170;
// int bookNineEndsAt =140817;
// int bookTenStatsAt =140487;
// int bookTenEndsAt =140817;

/*
* fetch query from database
* SELECT
    lines.*,
    MAX(CASE WHEN languages.name_english = 'English' THEN transliterations.transliteration END) AS english_transliteration,
    MAX(CASE WHEN languages.name_english = 'Punjabi' THEN transliterations.transliteration END) AS punjabi_transliteration,
    MAX(CASE WHEN languages.name_english = 'Spanish' THEN transliterations.transliteration END) AS spanish_transliteration,
    MAX(CASE WHEN languages.name_english = 'Hindi' THEN transliterations.transliteration END) AS hindi_transliteration,
    MAX(CASE WHEN languages.name_english = 'Urdu' THEN transliterations.transliteration END) AS urdu_transliteration
FROM
    lines
LEFT JOIN
    transliterations ON lines.id = transliterations.line_id
LEFT JOIN
    languages ON transliterations.language_id = languages.id
GROUP BY
    lines.id, lines.shabad_id, lines.source_page, lines.source_line, lines.first_letters,
    lines.vishraam_first_letters, lines.gurmukhi, lines.pronunciation,
    lines.pronunciation_information, lines.type_id, lines.order_id;
    *
    *
    *
SELECT
    lines.*,
    MAX(CASE WHEN languages.name_english = 'English' THEN transliterations.transliteration END) AS english_transliteration,
    MAX(CASE WHEN languages.name_english = 'Punjabi' THEN transliterations.transliteration END) AS punjabi_transliteration,
    MAX(CASE WHEN languages.name_english = 'Spanish' THEN transliterations.transliteration END) AS spanish_transliteration,
    MAX(CASE WHEN languages.name_english = 'Hindi' THEN transliterations.transliteration END) AS hindi_transliteration,
    MAX(CASE WHEN languages.name_english = 'Urdu' THEN transliterations.transliteration END) AS urdu_transliteration
FROM
    (SELECT * FROM lines WHERE lines.source_page = 1 AND lines.order_id <= 60555 order by lines.order_id asc) as lines
LEFT JOIN
    transliterations ON lines.id = transliterations.line_id
LEFT JOIN
    languages ON transliterations.language_id = languages.id
GROUP BY
    lines.id, lines.shabad_id, lines.source_page, lines.source_line, lines.first_letters,
    lines.vishraam_first_letters, lines.gurmukhi, lines.pronunciation,
    lines.pronunciation_information, lines.type_id, lines.order_id
ORDER by
	lines.order_id

    var result = await DataService.database.rawQuery("""
      SELECT
    lines.*,
    MAX(CASE WHEN languages.name_english = 'English' THEN transliterations.transliteration END) AS english_transliteration,
    MAX(CASE WHEN languages.name_english = 'Punjabi' THEN transliterations.transliteration END) AS punjabi_transliteration,
    MAX(CASE WHEN languages.name_english = 'Spanish' THEN transliterations.transliteration END) AS spanish_transliteration,
    MAX(CASE WHEN languages.name_english = 'Hindi' THEN transliterations.transliteration END) AS hindi_transliteration,
    MAX(CASE WHEN languages.name_english = 'Urdu' THEN transliterations.transliteration END) AS urdu_transliteration
FROM
    (SELECT * FROM lines WHERE lines.source_page = $sourcePageNo AND ${getBookRange(bookNo)} ORDER BY lines.order_id asc LIMIT $lines OFFSET ${(pageNo-1)*lines}) AS lines
LEFT JOIN
    transliterations ON lines.id = transliterations.line_id
LEFT JOIN
    languages ON transliterations.language_id = languages.id
GROUP BY
    lines.id, lines.shabad_id, lines.source_page, lines.source_line, lines.first_letters,
    lines.vishraam_first_letters, lines.gurmukhi, lines.pronunciation,
    lines.pronunciation_information, lines.type_id, lines.order_id
ORDER by
	lines.order_id
    """)
 */

class Reader{
  static String getBookRange(int bookNo){
    switch(bookNo){
      case 1:
        return 'lines.order_id <= $bookOneEndsAt';
      case 2:
        return 'lines.order_id > $bookOneEndsAt AND lines.order_id <= $bookTwoEndsAt';
      case 3:
        return 'lines.order_id > $bookTwoEndsAt AND lines.order_id <= $bookThreeEndsAt';
      case 4:
        return 'lines.order_id > $bookThreeEndsAt AND lines.order_id <= $bookFourEndsAt';
      case 5:
        return 'lines.order_id > $bookFourEndsAt AND lines.order_id <= $bookFiveEndsAt';
      case 6:
        return 'lines.order_id > $bookFiveEndsAt AND lines.order_id <= $bookSixEndsAt';
      case 7:
        return 'lines.order_id > $bookSixEndsAt AND lines.order_id <= $bookSevenEndsAt';
      case 8:
        return 'lines.order_id > $bookSevenEndsAt AND lines.order_id <= $bookEightEndsAt';
      case 9:
        return 'lines.order_id > $bookEightEndsAt AND lines.order_id <= $bookNineStatsAt';
      default:
        return 'lines.order_id > $bookNineStatsAt';
    }
  }

  static Future<List<NitnemModel>> getNitnems(){
    return DataService.database.rawQuery('SELECT * FROM banis')
    .then((value) {
      List<NitnemModel> nitnems = List.empty(growable: true);
      value?.forEach((element) {
        nitnems.add(NitnemModel.fromJson(element));
      });
      return nitnems;
    });
  }

  static Future<DBResult> getNitnemAngs({required int nitnemId}) async {
    print(nitnemId);
    var count = await DataService.database.rawQuery('SELECT COUNT(*) FROM bani_lines where bani_id = $nitnemId')
        .then((value) {
      // print(value);
      return value[0]['COUNT(*)'] as int;
    });
    // print(count);

    var result = await DataService.database.rawQuery("""
      SELECT
    lines.*,
    MAX(CASE WHEN languages.name_english = 'English' THEN transliterations.transliteration END) AS english_transliteration,
    MAX(CASE WHEN languages.name_english = 'Punjabi' THEN transliterations.transliteration END) AS punjabi_transliteration,
    MAX(CASE WHEN languages.name_english = 'Spanish' THEN transliterations.transliteration END) AS spanish_transliteration,
    MAX(CASE WHEN languages.name_english = 'Hindi' THEN transliterations.transliteration END) AS hindi_transliteration,
    MAX(CASE WHEN languages.name_english = 'Urdu' THEN transliterations.transliteration END) AS urdu_transliteration,
    MAX(CASE WHEN translations.translation_source_id = 1 THEN translations.translation END) AS translation_english,
    MAX(CASE WHEN translations.translation_source_id = 3 THEN translations.translation END) AS translation_punjabi,
    MAX(CASE WHEN translations.translation_source_id = 5 THEN translations.translation END) AS translation_faridkot_teeka,
    MAX(CASE WHEN translations.translation_source_id = 6 THEN translations.translation END) AS translation_punjabi_teeka
FROM
    (SELECT * FROM lines WHERE lines.id IN (SELECT bani_lines.line_id FROM bani_lines WHERE bani_lines.bani_id = $nitnemId)) AS lines
LEFT JOIN
    transliterations ON lines.id = transliterations.line_id
LEFT JOIN
    languages ON transliterations.language_id = languages.id
LEFT JOIN
    translations ON lines.id = translations.line_id
GROUP BY
    lines.id, lines.shabad_id, lines.source_page, lines.source_line, lines.first_letters,
    lines.vishraam_first_letters, lines.gurmukhi, lines.pronunciation,
    lines.pronunciation_information, lines.type_id, lines.order_id
ORDER BY
    lines.order_id;
    """)
        .then((value) {
      List<BaaniLineModel> baaniLines = List.empty(growable: true);
      value?.forEach((element) {
        baaniLines.add(BaaniLineModel.fromJson(element));
      });
      return baaniLines;
    });
    return DBResult(baaniLines: result, count: count);
  }

  static Future<DBResult> getAngs({int pageNo = 1, int sourcePageNo = 1, bool loadSourceLines=true, int lines = 10, int bookNo=1}) async {
    var count = await DataService.database.rawQuery('SELECT COUNT(*) FROM lines where source_page = $sourcePageNo AND ${getBookRange(bookNo)}')
    .then((value) {
      // print(value);
      return value[0]['COUNT(*)'] as int;
    });
    // print(count);
    String theQuery = """
      SELECT
    lines.*,
    MAX(CASE WHEN languages.name_english = 'English' THEN transliterations.transliteration END) AS english_transliteration,
    MAX(CASE WHEN languages.name_english = 'Punjabi' THEN transliterations.transliteration END) AS punjabi_transliteration,
    MAX(CASE WHEN languages.name_english = 'Spanish' THEN transliterations.transliteration END) AS spanish_transliteration,
    MAX(CASE WHEN languages.name_english = 'Hindi' THEN transliterations.transliteration END) AS hindi_transliteration,
    MAX(CASE WHEN languages.name_english = 'Urdu' THEN transliterations.transliteration END) AS urdu_transliteration,
    MAX(CASE WHEN translations.translation_source_id ${bookNo == 1 ? "= 1": "= 8"} THEN translations.translation END) AS translation_english,
    MAX(CASE WHEN translations.translation_source_id = 3 THEN translations.translation END) AS translation_punjabi,
    MAX(CASE WHEN translations.translation_source_id = 5 THEN translations.translation END) AS translation_faridkot_teeka,
    MAX(CASE WHEN translations.translation_source_id = 6 THEN translations.translation END) AS translation_punjabi_teeka
FROM
    (SELECT * FROM lines WHERE lines.source_page = $sourcePageNo AND ${getBookRange(bookNo)} ORDER BY lines.order_id asc ${loadSourceLines ? "" : "LIMIT $lines OFFSET ${(pageNo - 1) * lines}"}) AS lines
LEFT JOIN
    transliterations ON lines.id = transliterations.line_id
LEFT JOIN
    languages ON transliterations.language_id = languages.id
LEFT JOIN
    translations ON lines.id = translations.line_id
GROUP BY
    lines.id, lines.shabad_id, lines.source_page, lines.source_line, lines.first_letters,
    lines.vishraam_first_letters, lines.gurmukhi, lines.pronunciation,
    lines.pronunciation_information, lines.type_id, lines.order_id
ORDER by
	lines.order_id;
    """;
    // print(theQuery);
    var result = await DataService.database.rawQuery(theQuery)
    .then((value) {
      List<BaaniLineModel> baaniLines = List.empty(growable: true);
      value?.forEach((element) {
        baaniLines.add(BaaniLineModel.fromJson(element));
      });
      return baaniLines;
    });
    return DBResult(baaniLines: result, count: count);
  }

  static Future<List<BaaniLineModel>> getAngsByGurmukhiSearch({String searchQuery = '', int pageNo = 1, int lines = 10}) async {
    var result = await DataService.database.rawQuery('SELECT * FROM lines where gurmukhi like \'%$searchQuery%\' order by order_id LIMIT $lines OFFSET ${(pageNo-1)*lines}')
    .then((value) {
      List<BaaniLineModel> baaniLines = List.empty(growable: true);
      value?.forEach((element) {
        baaniLines.add(BaaniLineModel.fromJson(element));
      });
      return baaniLines;
    });
    return result;
  }

  static Future<List<BaaniLineModel>> getAngsByEnglishSearch({String searchQuery = '', int pageNo = 1, int lines = 10}) async {
    var result = await DataService.database.rawQuery('SELECT * FROM lines where english like \'%$searchQuery%\' order by order_id LIMIT $lines OFFSET ${(pageNo-1)*lines}')
    .then((value) {
      List<BaaniLineModel> baaniLines = List.empty(growable: true);
      value?.forEach((element) {
        baaniLines.add(BaaniLineModel.fromJson(element));
      });
      return baaniLines;
    });
    return result;
  }

  static Future<DBResult> search({required int searchType, required String searchText, int bookNo =1, String? shabadId}) async {
    switch(searchType){
      case 1:
        var count = await DataService.database.rawQuery('SELECT COUNT(*) FROM lines where ${shabadId != null ? "shabad_id = '$shabadId'" : "source_page = $searchText"} AND ${getBookRange(bookNo)}')
            .then((value) {
          // print(value);
          return value[0]['COUNT(*)'] as int;
        });

        String query = """
      SELECT
    lines.*,
    MAX(CASE WHEN languages.name_english = 'English' THEN transliterations.transliteration END) AS english_transliteration,
    MAX(CASE WHEN languages.name_english = 'Punjabi' THEN transliterations.transliteration END) AS punjabi_transliteration,
    MAX(CASE WHEN languages.name_english = 'Spanish' THEN transliterations.transliteration END) AS spanish_transliteration,
    MAX(CASE WHEN languages.name_english = 'Hindi' THEN transliterations.transliteration END) AS hindi_transliteration,
    MAX(CASE WHEN languages.name_english = 'Urdu' THEN transliterations.transliteration END) AS urdu_transliteration,
    MAX(CASE WHEN translations.translation_source_id ${bookNo == 1 ? "= 1": "= 8"} THEN translations.translation END) AS translation_english,
    MAX(CASE WHEN translations.translation_source_id = 3 THEN translations.translation END) AS translation_punjabi,
    MAX(CASE WHEN translations.translation_source_id = 5 THEN translations.translation END) AS translation_faridkot_teeka,
    MAX(CASE WHEN translations.translation_source_id = 6 THEN translations.translation END) AS translation_punjabi_teeka
FROM
    (SELECT * FROM lines WHERE ${shabadId != null ? "lines.shabad_id = '$shabadId'" : "lines.source_page = $searchText"} AND ${getBookRange(bookNo)} ORDER BY lines.order_id asc) AS lines
LEFT JOIN
    transliterations ON lines.id = transliterations.line_id
LEFT JOIN
    languages ON transliterations.language_id = languages.id
LEFT JOIN
    translations ON lines.id = translations.line_id
GROUP BY
    lines.id, lines.shabad_id, lines.source_page, lines.source_line, lines.first_letters,
    lines.vishraam_first_letters, lines.gurmukhi, lines.pronunciation,
    lines.pronunciation_information, lines.type_id, lines.order_id
ORDER by
	lines.order_id;
    """;
        var result = await DataService.database.rawQuery(query)
            .then((value) {
          List<BaaniLineModel> baaniLines = List.empty(growable: true);
          value?.forEach((element) {
            baaniLines.add(BaaniLineModel.fromJson(element));
          });
          return baaniLines;
        });
        return DBResult(baaniLines: result, count: count);
      case 2:
        var count = await DataService.database.rawQuery("SELECT COUNT(*) FROM lines where LOWER(first_letters) LIKE LOWER('$searchText%')")
            .then((value) {
          // print(value);
          return value[0]['COUNT(*)'] as int;
        });

        String query = """
      SELECT
    lines.*,
    MAX(CASE WHEN languages.name_english = 'English' THEN transliterations.transliteration END) AS english_transliteration,
    MAX(CASE WHEN languages.name_english = 'Punjabi' THEN transliterations.transliteration END) AS punjabi_transliteration,
    MAX(CASE WHEN languages.name_english = 'Spanish' THEN transliterations.transliteration END) AS spanish_transliteration,
    MAX(CASE WHEN languages.name_english = 'Hindi' THEN transliterations.transliteration END) AS hindi_transliteration,
    MAX(CASE WHEN languages.name_english = 'Urdu' THEN transliterations.transliteration END) AS urdu_transliteration,
    MAX(CASE WHEN translations.translation_source_id = 1 THEN translations.translation END) AS translation_english,
    MAX(CASE WHEN translations.translation_source_id = 3 THEN translations.translation END) AS translation_punjabi,
    MAX(CASE WHEN translations.translation_source_id = 5 THEN translations.translation END) AS translation_faridkot_teeka,
    MAX(CASE WHEN translations.translation_source_id = 6 THEN translations.translation END) AS translation_punjabi_teeka
FROM
    (SELECT * FROM lines WHERE LOWER(lines.first_letters) LIKE LOWER('$searchText%') ORDER BY lines.order_id asc) AS lines
LEFT JOIN
    transliterations ON lines.id = transliterations.line_id
LEFT JOIN
    languages ON transliterations.language_id = languages.id
LEFT JOIN
    translations ON lines.id = translations.line_id
GROUP BY
    lines.id, lines.shabad_id, lines.source_page, lines.source_line, lines.first_letters,
    lines.vishraam_first_letters, lines.gurmukhi, lines.pronunciation,
    lines.pronunciation_information, lines.type_id, lines.order_id
ORDER by
	lines.order_id;
    """;
        var result = await DataService.database.rawQuery(query)
            .then((value) {
          List<BaaniLineModel> baaniLines = List.empty(growable: true);
          value?.forEach((element) {
            baaniLines.add(BaaniLineModel.fromJson(element));
          });
          return baaniLines;
        });
        return DBResult(baaniLines: result, count: count);
      case 3:
        var count = await DataService.database.rawQuery("SELECT COUNT(*) FROM lines where LOWER(first_letters) LIKE LOWER('%$searchText%')")
            .then((value) {
          // print(value);
          return value[0]['COUNT(*)'] as int;
        });

        String query = """
      SELECT
    lines.*,
    MAX(CASE WHEN languages.name_english = 'English' THEN transliterations.transliteration END) AS english_transliteration,
    MAX(CASE WHEN languages.name_english = 'Punjabi' THEN transliterations.transliteration END) AS punjabi_transliteration,
    MAX(CASE WHEN languages.name_english = 'Spanish' THEN transliterations.transliteration END) AS spanish_transliteration,
    MAX(CASE WHEN languages.name_english = 'Hindi' THEN transliterations.transliteration END) AS hindi_transliteration,
    MAX(CASE WHEN languages.name_english = 'Urdu' THEN transliterations.transliteration END) AS urdu_transliteration,
    MAX(CASE WHEN translations.translation_source_id = 1 THEN translations.translation END) AS translation_english,
    MAX(CASE WHEN translations.translation_source_id = 3 THEN translations.translation END) AS translation_punjabi,
    MAX(CASE WHEN translations.translation_source_id = 5 THEN translations.translation END) AS translation_faridkot_teeka,
    MAX(CASE WHEN translations.translation_source_id = 6 THEN translations.translation END) AS translation_punjabi_teeka
FROM
    (SELECT * FROM lines WHERE LOWER(lines.first_letters) LIKE LOWER('%$searchText%') ORDER BY lines.order_id asc) AS lines
LEFT JOIN
    transliterations ON lines.id = transliterations.line_id
LEFT JOIN
    languages ON transliterations.language_id = languages.id
LEFT JOIN
    translations ON lines.id = translations.line_id
GROUP BY
    lines.id, lines.shabad_id, lines.source_page, lines.source_line, lines.first_letters,
    lines.vishraam_first_letters, lines.gurmukhi, lines.pronunciation,
    lines.pronunciation_information, lines.type_id, lines.order_id
ORDER by
	lines.order_id;
    """;
        var result = await DataService.database.rawQuery(query)
            .then((value) {
          List<BaaniLineModel> baaniLines = List.empty(growable: true);
          value?.forEach((element) {
            baaniLines.add(BaaniLineModel.fromJson(element));
          });
          return baaniLines;
        });
        return DBResult(baaniLines: result, count: count);
      default:
        return DBResult(baaniLines: List<BaaniLineModel>.empty(), count: 0);
    }
  }
}