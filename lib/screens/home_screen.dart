import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gurbani_app/models/baani_lines_model.dart';
import 'package:gurbani_app/widgets/baani_view_widget.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:math' as math;

import 'package:flip_widget/flip_widget.dart';

//ToDo: This class has to be renamed because this won't be the homescreen

class HomeScreen extends StatefulWidget {
  final int offset;
  const HomeScreen({super.key, required this.offset});

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

  Offset _oldPosition = Offset.zero;
  @override
  void initState() {
    super.initState();

    GetIt.I<Database>()
        .rawQuery(
            'SELECT * FROM lines order by order_id LIMIT 10 OFFSET ${widget.offset}')
        .then((value) {
      value?.forEach((element) {
        baaniLines.add(BaaniLineModel.fromJson(element));
      });
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
        Size size = MediaQuery.sizeOf(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            SizedBox(
              width: size.width,
              height: size.height,
              child: GestureDetector(
                child: FlipWidget(
                  key: _flipKey,
                  textureSize: size * 2,
                  child: Container(
                    color: Colors.black,
                    child: Center(
                      child: BaaniPageView(baaniLines: baaniLines),
                    ),
                  ),
                  // leftToRight: true,
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
                },
                onHorizontalDragEnd: (details) {
                  _flipKey.currentState?.stopFlip();
                },
                onHorizontalDragCancel: () {
                  _flipKey.currentState?.stopFlip();
                },
              ),
            ),
            Positioned(
                bottom: 10,
                right: 10,
                child: Column(
                  children: [
                    IconButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                      offset: widget.offset - 10,
                                    ))),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        )),
                    IconButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                      offset: widget.offset + 10,
                                    ))),
                        icon: const Icon(Icons.arrow_forward,
                            color: Colors.white)),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
