import 'package:gurbani_app/models/baani_lines_model.dart';
import 'data_service.dart';

class Reader{
  static Future<List<BaaniLineModel>> getAngs({int pageNo = 1, int lines = 10}) async {
    var result = await DataService.database.rawQuery('SELECT * FROM lines order by order_id LIMIT $lines OFFSET ${(pageNo-1)*lines}')
    .then((value) {
      List<BaaniLineModel> baaniLines = List.empty(growable: true);
      value?.forEach((element) {
        baaniLines.add(BaaniLineModel.fromJson(element));
      });
      return baaniLines;
    });
    return result;
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
}