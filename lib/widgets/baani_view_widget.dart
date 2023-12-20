
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gurbani_app/models/baani_lines_model.dart';
import 'package:gurbani_app/models/db_result.dart';
import 'package:gurbani_app/utils/languages.dart';
import 'package:gurbani_app/utils/theme.dart';
import 'package:gurmukhi_utils/gurmukhi_utils.dart';

class BaaniPageView extends StatelessWidget {
  final bool showEnglishTransliteration;
  final bool showEnglishTranslation;
  final bool showPunjabiTranslation;
  final bool showPunjabiTeekaTranslation;
  final bool showFaridkotTeekaTranslation;
  final bool showHindiTranslation;
  final bool showHindiTeekaTranslation;
  final Languages language;
  final int pageNo;
  final int totalPages;
  final int linesPerPage;
  const BaaniPageView({
    super.key,
    required this.baaniLines,
    this.pageNo = 1,
    this.totalPages = 1,
    this.linesPerPage = 10,
    this.showEnglishTransliteration = false,
    this.showEnglishTranslation = true,
    this.showPunjabiTranslation = true,
    this.showPunjabiTeekaTranslation = false,
    this.showFaridkotTeekaTranslation = false,
    this.showHindiTranslation = false,
    this.showHindiTeekaTranslation = false,
    this.language = Languages.Gurmukhi,
  });

  final DBResult baaniLines;

  @override
  Widget build(BuildContext context) {
    // print(MediaQuery.of(context).size.height);
    return baaniLines.count == 0 ? Center(
      child: Text('------------- End of Baani ---------------'),
    ) : ListView.builder(
        itemCount: baaniLines.baaniLines.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            child: Column(
              children: [
                index == 0
                    ? Row(
                        children: [
                          Text(
                            'Ang: ${baaniLines.baaniLines[index].sourcePage}',
                            style: baaniTextStyle(12.sp),
                          ),
                          Spacer(),
                          Text(
                            '$pageNo/$totalPages',
                            style: baaniTextStyle(12.sp),
                          ),
                        ],
                      )
                    : Container(),
                SizedBox(
                  height: 10.h,
                ),
                showEnglishTransliteration
                    ? Text(
                        baaniLines.baaniLines[index].englishTransliteration ?? '',
                        style: baaniTextStyle(12.sp),
                        textAlign: TextAlign.center,
                      )
                    : Container(),
                SizedBox(
                  height: 1.h,
                ),
                showEnglishTranslation
                    ? Text(
                        baaniLines.baaniLines[index].translationEnglish ?? '',
                        style: baaniTextStyle(12.sp),
                        textAlign: TextAlign.center,
                      )
                    : Container(),
                SizedBox(
                  height: 1.h,
                ),
                showPunjabiTranslation
                    ? Text(
                        baaniLines.baaniLines[index].translationPunjabi ?? "",
                        style: baaniTextStyle(12.sp),
                        textAlign: TextAlign.center,
                      )
                    : Container(),
                SizedBox(
                  height: 1.h,
                ),
                showPunjabiTeekaTranslation
                    ? Text(
                        baaniLines.baaniLines[index].translationPunjabiTeeka ?? "",
                        style: baaniTextStyle(12.sp),
                        textAlign: TextAlign.center,
                      )
                    : Container(),
                SizedBox(
                  height: 1.h,
                ),
                showFaridkotTeekaTranslation
                    ? Text(
                        baaniLines.baaniLines[index].translationFaridkotTeeka ?? "",
                        style: baaniTextStyle(12.sp),
                        textAlign: TextAlign.center,
                      )
                    : Container(),
                SizedBox(
                  height: 1.h,
                ),
                showHindiTranslation
                    ? Text(
                        baaniLines.baaniLines[index].translationHindi ?? "",
                        style: baaniTextStyle(12.sp),
                        textAlign: TextAlign.center,
                      )
                    : Container(),
                SizedBox(
                  height: 1.h,
                ),
                showHindiTeekaTranslation
                    ? Text(
                        baaniLines.baaniLines[index].translationHindiTeeka ?? "",
                        style: baaniTextStyle(12.sp),
                        textAlign: TextAlign.center,
                      )
                    : Container(),
                SizedBox(
                  height: 1.h,
                ),
                language == Languages.Gurmukhi ? Text(
                  asciiToGurmukhi(baaniLines.baaniLines[index].gurmukhi),
                  style: baaniTextStyle(16.sp),
                  textAlign: TextAlign.center,
                ) : language == Languages.Hindi ? Text(
                  asciiToGurmukhi(baaniLines.baaniLines[index].hindiTransliteration ?? ""),
                  style: baaniTextStyle(16.sp),
                  textAlign: TextAlign.center,
                ) : language == Languages.Both ? Column(
                  children: [
                    Text(
                      asciiToGurmukhi(baaniLines.baaniLines[index].hindiTransliteration ?? ""),
                      style: baaniTextStyle(16.sp),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      asciiToGurmukhi(baaniLines.baaniLines[index].gurmukhi),
                      style: baaniTextStyle(16.sp),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ) : Container(),
                SizedBox(
                  height: 1.h,
                ),
                // Text(baaniLines[index].pronunciationInformation,
                //     textAlign: TextAlign.center, style: baaniTextStyle(10)),
              ],
            ),
          );
        });
  }
}