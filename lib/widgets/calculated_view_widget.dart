
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gurbani_app/models/calculated_items.dart';
import 'package:gurbani_app/utils/spans.dart';
import 'package:gurbani_app/utils/theme.dart';

class CalculatedViewWidget extends StatelessWidget {
  final bool isLoading;
  final CalculatedItems baaniLines;

  const CalculatedViewWidget({
    super.key,
    required this.baaniLines,
    this.isLoading = false,
  }) ;


  @override
  Widget build(BuildContext context) {
    // print(MediaQuery.of(context).size.height);
    return isLoading ? Center(child: CircularProgressIndicator()) : baaniLines.textSpans.isEmpty ? Center(
      child: Text('------------- End of Baani ---------------'),
    ) : ListView.builder(
        itemCount: baaniLines.textSpans.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
            child: Column(
              children: [
                index == 0
                    ? Column(
                      children: [
                        Row(
                            children: [
                              RichText(
                                text: getSpan('Ang: ${baaniLines.angNo}', style: baaniTextStyle(fontSize:12)),
                              ),
                              Spacer(),
                              RichText(
                                text: getSpan('${baaniLines.pageNo}/${baaniLines.totalPages}', style: baaniTextStyle(fontSize:12)),
                              ),
                            ],
                          ),
                        RichText(
                          text: baaniLines.textSpans[index],
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                    : RichText(
                  text: baaniLines.textSpans[index],
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 1.h,
                ),
              ],
            ),
          );
        });
  }

}