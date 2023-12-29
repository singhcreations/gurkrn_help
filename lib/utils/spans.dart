import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gurmukhi_utils/gurmukhi_utils.dart';

TextSpan getSpan(String? text, {TextStyle? style}) {
  return TextSpan(
      text: text ?? "",
      style: style ?? TextStyle(
          fontSize: 20.sp,
          color: Colors.black,
          fontWeight: FontWeight.w600,
      ),
  );
}

TextSpan getAsscciiSpan(String? text, {TextStyle? style}) {
  return TextSpan(
      text: asciiToGurmukhi(text ?? "").removeVishraams(),
      style: style ?? TextStyle(
          fontSize: 20.sp,
          color: Colors.black,
          fontWeight: FontWeight.w600
      )
  );
}

double getTextHeight({required TextSpan span, required double maxWidth}) {
  final TextPainter textPainter = TextPainter(
    text: span,
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
    maxLines: 100,
  );

  textPainter.layout(maxWidth: maxWidth);
  // print("getting height");
  // print(textPainter.size.height);
  // print(textPainter.height);
  // print(textPainter.computeLineMetrics().length);


  return textPainter.size.height * 1;
}
