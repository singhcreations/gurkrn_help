import 'package:gurbani_app/models/baani_lines_model.dart';
import 'data_service.dart';

class Reader{
  static Future<List<BaaniLineModel>> getAngs({int pageNo = 1, int limit = 10}) async {
    var result = await DataService.database.rawQuery('SELECT * FROM lines order by order_id LIMIT $limit OFFSET ${(pageNo-1)*limit}')
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