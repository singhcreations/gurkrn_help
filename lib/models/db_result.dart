import 'baani_lines_model.dart';

class DBResult{
  List<BaaniLineModel> baaniLines;
  int count;
  DBResult({required this.baaniLines, required this.count});

  factory DBResult.fromJson(Map<String, dynamic> json) {
    return DBResult(
      baaniLines: List<BaaniLineModel>.from(json['baaniLines'].map((line) => BaaniLineModel.fromJson(line))),
      count: json['count'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'baaniLines': baaniLines.map((line) => line.toJson()).toList(),
      'count': count,
    };
    return data;
  }

}