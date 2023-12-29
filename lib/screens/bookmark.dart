import 'package:flutter/material.dart';
import 'package:gurbani_app/models/baani_lines_model.dart';
import 'package:gurbani_app/screens/home_screen.dart';
import 'package:gurbani_app/widgets/helper.dart';
import 'package:gurmukhi_utils/gurmukhi_utils.dart';

class MyBookmarksScreen extends StatefulWidget {
  final List<BaaniLineModel> baaniLines;
  const MyBookmarksScreen({super.key, required this.baaniLines});

  @override
  _MyBookmarksScreenState createState() => _MyBookmarksScreenState();
}

class _MyBookmarksScreenState extends State<MyBookmarksScreen> {
  // List<String> bookmarkItems = ['Item 1', 'Item 2', 'Item 3'];


  @override
  Widget build(BuildContext context) {
    widget.baaniLines.forEach((element) {
      print(element.orderId);
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Handle settings button press
              // Add your functionality here
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ReorderableListView(
          children: widget.baaniLines
              .map(
                (baani) => ListTile(
              key: Key("bookmark${baani.orderId.toString()}"),
              leading: const Icon(Icons.view_module), // Icon on the left side
              title: Text(asciiToGurmukhi(baani.gurmukhi).removeVishraams(),),
              onTap: (){
                Helper.toScreen(context, HomeScreen(title: "Shabad" , searchView: true, searchedAng: baani.sourcePage, searchedBaaniLine: baani,));
              },
              // Add your item functionality here
            ),
          )
              .toList(),
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final item = widget.baaniLines.removeAt(oldIndex);
              widget.baaniLines.insert(newIndex, item);

            });
          },
        ),
      ),
    );
  }
}
