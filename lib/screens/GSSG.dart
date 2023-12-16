import 'package:flutter/material.dart';
import 'package:gurbani_app/widgets/constraints.dart';

class GSSGScreen extends StatefulWidget {
  const GSSGScreen({Key? key}) : super(key: key);

  @override
  _GSSGScreenState createState() => _GSSGScreenState();
}

class _GSSGScreenState extends State<GSSGScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kplayer,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_sharp,
              color: Colors.white,
            )),
        title: const Text(
          "GSSG",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}