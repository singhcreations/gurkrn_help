import 'package:flutter/material.dart';
import 'package:gurbani_app/models/baani_lines_model.dart';
import 'package:gurbani_app/services/reader.dart';
import 'package:gurbani_app/widgets/baani_view_widget.dart';
import 'dart:math' as math;

import 'package:flip_widget/flip_widget.dart';

//ToDo: This class has to be renamed because this won't be the homescreen

class HomeScreen extends StatefulWidget {
  final int pageNo;
  const HomeScreen({super.key, this.pageNo = 1});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

const double _MinNumber = 0.008;
double _clampMin(double v) {
  if (v < _MinNumber && v > -_MinNumber) {
    if (v >= 0) {
      v = _MinNumber;
    } else {
      v = -_MinNumber;
    }
  }
  return v;
}

class _HomeScreenState extends State<HomeScreen> {
  List<BaaniLineModel> baaniLines = List.empty(growable: true);
  final GlobalKey<FlipWidgetState> _flipKey = GlobalKey();

  List<BaaniLineModel> currentAng = List.empty(growable: true);
  List<BaaniLineModel> previousAng = List.empty(growable: true);
  List<BaaniLineModel> nextAng = List.empty(growable: true);

  Future<void> updateGurbaniLists(int pageNo) async {
    currentAng = await Reader.getAngs(pageNo: pageNo);
    nextAng = await Reader.getAngs(pageNo: pageNo + 1);
    previousAng = pageNo ==0 ? List<BaaniLineModel>.empty() : await Reader.getAngs(pageNo: pageNo - 1);
    baaniLines = currentAng;
    setState(() {});
  }

  int pageNo = 1;
  bool? isLeftToRight;

  Offset _oldPosition = Offset.zero;
  @override
  void initState() {
    pageNo = widget.pageNo;
    super.initState();
    updateGurbaniLists(pageNo); //kro
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // updateGurbaniLists(pageNo);

    Size size = MediaQuery.sizeOf(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Container(
              color: Colors.black,
              child: Center(
                child: BaaniPageView(baaniLines: nextAng),
              ),
            ),

//kro ik var
//same as before just smooth onlu

            SizedBox(
              width: size.width,
              height: size.height,
              child: GestureDetector(
                child: FlipWidget(
                  key: _flipKey,
                  textureSize: size * 1,
                  // leftToRight: true, //
                  child: Container(
                    color: Colors.black,
                    child: Center(
                      child: BaaniPageView(baaniLines: currentAng),
                    ),
                  ),
                ),
                onHorizontalDragStart: (details) {
                  _oldPosition = details.globalPosition;
                  _flipKey.currentState?.startFlip();
                },
                onHorizontalDragUpdate: (details) {
                  Offset off = details.globalPosition - _oldPosition;
                  double tilt = 1 / _clampMin((-off.dy + 20) / 100);
                  double percent = math.max(0, -off.dx / size.width * 1.4);
                  percent = percent - percent / 2 * (1 - 1 / tilt);
                  _flipKey.currentState?.flip(percent, tilt);
                  if(details.primaryDelta! > 0){
                    isLeftToRight = true;
                  }else if(details.primaryDelta! < 0){
                    isLeftToRight = false;
                  }else{
                    isLeftToRight = null;
                  }
                },
                onHorizontalDragEnd: (details) {
                  _flipKey.currentState?.stopFlip();
                  if(isLeftToRight == true){
                    if(pageNo == 1){
                      return;
                    }
                    pageNo -= 1;
                  }else if(isLeftToRight == false){
                    if(nextAng.isEmpty){
                      return;
                    }
                    pageNo += 1;
                  }
                  if(isLeftToRight != null){
                    updateGurbaniLists(pageNo);//kro
                    setState(() {});
                  }

                  //ni ho reha ruk reha inbetween

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => HomeScreen(
                  //               offset: widget.offset + 10,
                  //             )));
                },
                onHorizontalDragCancel: () {
                  _flipKey.currentState?.stopFlip();
                },
              ),
            ),
            // Positioned(
            //     bottom: 10,
            //     right: 10,
            //     child: Column(//aap opera mini use krte ho? yes
            //     //left side se turn pe bhi kam kar rah h content next ka a raha h
            //       children: [
            //         IconButton(
            //             onPressed: () => Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                     builder: (context) => HomeScreen(
            //                           offset: widget.offset - 10,
            //                         ))),
            //             icon: const Icon(
            //               Icons.arrow_back,
            //               color: Colors.white,
            //             )),
            //         IconButton(
            //             onPressed: () => Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                     builder: (context) => HomeScreen(
            //                           offset: widget.offset + 10,
            //                         ))),
            //             icon: const Icon(Icons.arrow_forward,
            //                 color: Colors.white)),
            //       ],
            //     ))
          ],
        ),
      ),
    );
  }
}
