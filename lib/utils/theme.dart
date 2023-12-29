import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final themeData = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xffFF6A33),
      
    )
);

TextStyle baaniTextStyle({double? fontSize, Color? color, Color? backgroundColor}) => TextStyle(
      fontSize: (fontSize ?? 20).sp,
      color: color ?? Colors.amber,
      fontFamily: "AnmolUni",
      backgroundColor: backgroundColor
    );
