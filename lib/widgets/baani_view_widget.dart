
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gurbani_app/models/baani_lines_model.dart';
import 'package:gurbani_app/models/db_result.dart';
import 'package:gurbani_app/utils/languages.dart';
import 'package:gurbani_app/utils/spans.dart';
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
  final bool isLoading;
  final bool showAng;
  final bool showPageNo;
  final BaaniLineModel? searchedLine;

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
    this.isLoading = false,
    this.showAng = true,
    this.showPageNo = true,
    this.searchedLine,
  }) ;

  final DBResult baaniLines;

  @override
  Widget build(BuildContext context) {
    // print(MediaQuery.of(context).size.height);
    return isLoading ? Center(
      child: CircularProgressIndicator(),
    ) : baaniLines.count == 0 ? Center(
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
                          showAng ? RichText(
                            text: getSpan('Ang: ${baaniLines.baaniLines[index].sourcePage}', style: baaniTextStyle(fontSize:12)),
                          ) : Container(),
                          Spacer(),
                          showPageNo ? RichText(
                            text: getSpan('$pageNo/$totalPages', style: baaniTextStyle(fontSize:12)),
                          ): Container(),
                        ],
                      )
                    : Container(),
                SizedBox(
                  height: 10.h,
                ),
                showEnglishTransliteration && baaniLines.baaniLines[index].englishTransliteration != null ? RichText(
                  text: getSpan(
                    baaniLines.baaniLines[index].englishTransliteration,
                    style: baaniTextStyle(),
                  ),
                  textAlign: TextAlign.center,
                ): Container(),
                SizedBox(
                  height: 1.h,
                ),
                showEnglishTranslation && baaniLines.baaniLines[index].translationEnglish != null ? RichText(
                  text: getSpan(
                    baaniLines.baaniLines[index].translationEnglish ?? "",
                    style: baaniTextStyle(),
                  ),
                  textAlign: TextAlign.center,
                ) : Container(),
                SizedBox(
                  height: 1.h,
                ),
                showPunjabiTranslation && baaniLines.baaniLines[index].translationPunjabi != null ? RichText(
                  text: getSpan(
                    baaniLines.baaniLines[index].translationPunjabi ?? "",
                    style: baaniTextStyle(),
                  ),
                  textAlign: TextAlign.center,
                ) : Container(),
                SizedBox(
                  height: 1.h,
                ),
                showPunjabiTeekaTranslation && baaniLines.baaniLines[index].translationPunjabiTeeka != null ? RichText(
                  text: getSpan(
                    baaniLines.baaniLines[index].translationPunjabiTeeka ?? "",
                    style: baaniTextStyle(),
                  ),
                  textAlign: TextAlign.center,
                ) : Container(),
                SizedBox(
                  height: 1.h,
                ),
                showFaridkotTeekaTranslation && baaniLines.baaniLines[index].translationFaridkotTeeka != null ? RichText(
                  text: getSpan(
                    baaniLines.baaniLines[index].translationFaridkotTeeka ?? "",
                    style: baaniTextStyle(),
                  ),
                  textAlign: TextAlign.center,
                ) : Container(),
                SizedBox(
                  height: 1.h,
                ),
                showHindiTranslation && baaniLines.baaniLines[index].translationHindi != null ? RichText(
                  text: getSpan(
                    baaniLines.baaniLines[index].translationHindi ?? "",
                    style: baaniTextStyle(),
                  ),
                  textAlign: TextAlign.center,
                ) : Container(),
                SizedBox(
                  height: 1.h,
                ),
                showHindiTeekaTranslation && baaniLines.baaniLines[index].translationHindiTeeka != null ? RichText(
                  text: getAsscciiSpan(
                    baaniLines.baaniLines[index].translationHindiTeeka,
                    style: baaniTextStyle(),
                  ),
                  textAlign: TextAlign.center,
                ) : Container(),
                SizedBox(
                  height: 1.h,
                ),
                language == Languages.Gurmukhi ? RichText(
                  text: getAsscciiSpan(baaniLines.baaniLines[index].gurmukhi,
                  style: baaniTextStyle(
                    color: searchedLine?.orderId == baaniLines.baaniLines[index].orderId ? Colors.white : null, backgroundColor: searchedLine?.orderId == baaniLines.baaniLines[index].orderId ? Colors.red : null),
                    ),
                  textAlign: TextAlign.center,
                  // key: searchedLine?.orderId == baaniLines.baaniLines[index].orderId ? scrollKey : null,
                ) : language == Languages.Hindi ? RichText(
                  text: getAsscciiSpan(
                    baaniLines.baaniLines[index].hindiTransliteration,
                    style: baaniTextStyle(),
                  ),
                  textAlign: TextAlign.center,
                ) : language == Languages.Both ? Column(
                  children: [
                    RichText(
                      text: getAsscciiSpan(
                        baaniLines.baaniLines[index].hindiTransliteration,
                        style: baaniTextStyle(),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    RichText(
                      text: getAsscciiSpan(baaniLines.baaniLines[index].gurmukhi,
                        style: baaniTextStyle(
                            color: searchedLine?.orderId == baaniLines.baaniLines[index].orderId ? Colors.white : null, backgroundColor: searchedLine?.orderId == baaniLines.baaniLines[index].orderId ? Colors.red : null),
                      ),
                      textAlign: TextAlign.center,
                      // key: searchedLine?.orderId == baaniLines.baaniLines[index].orderId ? scrollKey : null,
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