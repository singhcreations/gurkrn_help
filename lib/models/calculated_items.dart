import 'package:flutter/painting.dart';

class CalculatedItems{
  int pageNo;
  int totalPages;
  int angNo;
  List<TextSpan> textSpans;
  CalculatedItems({
    this.pageNo =1,
    this.totalPages=1,
    this.angNo=1,
    required this.textSpans
  });

}