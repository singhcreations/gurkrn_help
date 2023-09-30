import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:gurmukhi_utils/gurmukhi_utils.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>>? _rows;
  @override
  void initState() {
    super.initState();

    // to get all tables in the database
    // GetIt.I<Database>().rawQuery(
    //   'SELECT name FROM sqlite_master WHERE type="table"',
    // ).then((value) {
    //   log(value.toString(), name: "QUERY");
    // });

    GetIt.I<Database>().rawQuery(
      'SELECT * FROM lines LIMIT 10',
    ).then((value) {
      setState(() {
        _rows = value;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: _rows == null ? [const Text("Empty")] : _rows!.map((e) => Text(
            asciiToGurmukhi(e["gurmukhi"]),
            style: const TextStyle(
              fontFamily: "AnmolUni",
            ),
          )).toList()
        ),
      ),
    );
  }
}
