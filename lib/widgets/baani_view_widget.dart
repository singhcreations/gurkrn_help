
import 'package:flutter/material.dart';
import 'package:gurbani_app/models/baani_lines_model.dart';
import 'package:gurbani_app/utils/theme.dart';
import 'package:gurmukhi_utils/gurmukhi_utils.dart';

class BaaniPageView extends StatelessWidget {
  const BaaniPageView({
    super.key,
    required this.baaniLines,
  });

  final List<BaaniLineModel> baaniLines;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: baaniLines.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                index == 0
                    ? Row(
                        children: [
                          Text(
                            'Ang: ${baaniLines[index].sourcePage}',
                            style: baaniTextStyle(12),
                          ),
                        ],
                      )
                    : Container(),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  asciiToGurmukhi(baaniLines[index].gurmukhi),
                  style: baaniTextStyle(18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                // Text(baaniLines[index].pronunciationInformation,
                //     textAlign: TextAlign.center, style: baaniTextStyle(10)),
              ],
            ),
          );
        });
  }
}