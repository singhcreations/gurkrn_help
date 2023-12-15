import 'package:flutter/material.dart';
class CustomText extends StatelessWidget {
   CustomText({
     this.title,
     this.color,
     this.fontSize,
     this.fontWeight,
     this.textAlign,
     this.overflow,
     this.maxLines,
     this.height,
     Key? key}) : super(key: key);
 String? title;
 Color? color;
 double? fontSize;
  FontWeight? fontWeight;
  TextAlign? textAlign;
   TextOverflow? overflow;
   double? height;
  int? maxLines;
  @override
  Widget build(BuildContext context) {
    return Text(title??"",
    maxLines: maxLines,
    overflow: overflow,
    textAlign: textAlign?? TextAlign.left,
    style: TextStyle(
      fontSize:fontSize,
      color: color,
      fontWeight: fontWeight,
      height: height
    ),);
  }
}