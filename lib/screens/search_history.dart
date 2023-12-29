import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:gurbani_app/models/baani_lines_model.dart';
import 'package:gurbani_app/screens/home_screen.dart';
import 'package:gurbani_app/widgets/constraints.dart';
import 'package:gurbani_app/widgets/helper.dart';
import 'package:gurmukhi_utils/gurmukhi_utils.dart';



class SearchHistory extends StatelessWidget {
  final List<BaaniLineModel> searchHistoryItems;
  final Future<void> Function(int) onFunctionCalled;
  final VoidCallback onClearAllHistory;
  const SearchHistory({Key? key, required this.searchHistoryItems, required this.onFunctionCalled, required this.onClearAllHistory}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: whiteColor,),
          onPressed: () {
            // Handle back button press
            Navigator.pop(context);
          },
        ),
        title: Text('Search History', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings,color: whiteColor,),
            onPressed: () {
              // Handle settings tool icon spress
              // Add your functionality here
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: searchHistoryItems.length,
          itemBuilder: (context, index) {
            return SwipeActionCell(
              key: ObjectKey("history${searchHistoryItems[index]}"),
              trailingActions: [
                SwipeAction(
                  onTap: (CompletionHandler handler) async {
                    // Delete item
                    await onFunctionCalled(index);

                    // Complete the swipe action
                    handler(true);
                  },
                  color: Colors.red,
                  icon: Icon(Icons.delete, size: 30),
                ),
              ],
              child: Container(
                color: Colors.grey[300],
                child: ListTile(
                  title: Text(asciiToGurmukhi(searchHistoryItems[index].gurmukhi).removeVishraams()),
                    onTap: (){
                      Helper.toScreen(context, HomeScreen(title: "Shabad" , searchView: true, searchedAng: searchHistoryItems[index].sourcePage, searchedBaaniLine: searchHistoryItems[index],));
                    }
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Delete All History ?'),
                content: Text('Are you sure you want to delete the complete history?''\n\n'
                    'If you want to delete only selected search records, swipe right.'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Delete All'),
                    onPressed: () {
                      // Handle delete all functionality
                      // Add your logic here
                      onClearAllHistory();
                      Navigator.of(context).pop(); // Close the AlertDialog
                    },
                  ),
                ],
              );
            },
          );


        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.delete),
      ),
    );
  }
}