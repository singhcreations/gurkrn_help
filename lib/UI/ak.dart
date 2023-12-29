import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gurbani_app/models/baani_lines_model.dart';
import 'package:gurbani_app/models/db_result.dart';
import 'package:gurbani_app/models/search_item.dart';
import 'package:gurbani_app/screens/bookmark.dart';
import 'package:gurbani_app/screens/home_screen.dart';
import 'package:gurbani_app/screens/search_history.dart';
import 'package:gurbani_app/services/reader.dart';
import 'package:gurbani_app/widgets/helper.dart';
import 'package:gurmukhi_utils/gurmukhi_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SucessScreen extends StatefulWidget {
  const SucessScreen({super.key});

  @override
  State<SucessScreen> createState() => _SucessScreenState();
}

class _SucessScreenState extends State<SucessScreen> {
  List<SearchItem> dropDownItems = [
    SearchItem(id: 1, name: 'Search by Ang'),
    SearchItem(id: 2, name: 'First Letters from Start'),
    SearchItem(id: 3, name: 'First Letters from Anywhere'),
  ];
  int _displayPage=0;
  late SearchItem selectedOption ;
  int bookNo = 1;
  bool _isLoading = false;
  DBResult suggestions = DBResult(baaniLines: <BaaniLineModel>[], count: 0);
  TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    selectedOption = dropDownItems.first;
    super.initState();
    loadItems();
  }

  List<BaaniLineModel> historyItems = [];
  final String historyKey = 'myHistoryList';
  List<BaaniLineModel> bookmarksItems = [];
  final String bookmarksKey = 'myBookmarksList';


  loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    // prefs.setStringList(bookmarksKey, []);
    final List<BaaniLineModel> fetchItems = (prefs.getStringList(historyKey) ?? []).map((e) => BaaniLineModel.fromJson(jsonDecode(e))).toList();
    final List<BaaniLineModel> fetchBookmarks = (prefs.getStringList(bookmarksKey) ?? []).map((e) => BaaniLineModel.fromJson(jsonDecode(e))).toList();

    // print(fetchBookmarks);
    setState(() {
      historyItems = fetchItems;
      bookmarksItems = fetchBookmarks;
    });
  }

  Future<void> saveItems() async {
    final prefs = await SharedPreferences.getInstance();
    // prefs.setStringList(historyKey, historyItems);
    prefs.setStringList(historyKey, historyItems.map((e) => jsonEncode(e.toJson())).toList());
  }

  bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history_edu), label: 'History'),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmarks_outlined),
            label: 'Bookmarks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
        currentIndex: _displayPage,
        onTap: (index) {
          setState(() {
            loadItems();
            _displayPage = index;
          });
        },
      ),
      body: SafeArea(
        child: _getPage(_displayPage),
      ),
    );
  }

  Widget _getPage(int index){
    switch (index) {
      case 0:
        return _buildSearchPage();
      case 1:
        return SearchHistory(
          searchHistoryItems: historyItems,
          onFunctionCalled: (int index) async {
            setState(() {
              historyItems.removeAt(index);
            });
            // Save changes to SharedPreferences
            await saveItems();
          },
          onClearAllHistory: () {
            setState(() {
              historyItems = [];
            });
            // Save changes to SharedPreferences
            saveItems();
          },);
      case 2:
        return MyBookmarksScreen(baaniLines: bookmarksItems,);
      case 3:
        return _buildMenuPage();
      default:
        return _buildSearchPage();
    }
  }

  Widget _buildSearchPage(){
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 320,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DropdownButton<SearchItem>(
              value: selectedOption,
              items: dropDownItems.map((SearchItem value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value.name),
                );
              }).toList(),
              onChanged: (item) {
                setState(() {
                  selectedOption = item!;
                });
              },
              style: const TextStyle(fontSize: 18.0, color: Colors.black),
              icon: const Icon(Icons.arrow_drop_down, size: 30.0),
            ),

          ),

          const SizedBox(height: 30),
          // radio button to select book one and book two if selectedItem is 1

          selectedOption.id == 1 ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: RadioListTile<int>(
                    title: const Text(
                      'Book One',
                      style: TextStyle(fontSize: 18.0, color: Colors.black,),
                      maxLines: 1,
                    ),
                    contentPadding: EdgeInsets.zero,
                    selected: true,
                    value: 1,
                    groupValue: bookNo,
                    onChanged: (value) {
                      setState(() {
                        bookNo = value as int;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<int>(
                    title: const Text(
                      'Book Two',
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                    ),
                    contentPadding: EdgeInsets.zero,
                    value: 2,
                    groupValue: bookNo,
                    onChanged: (value) {
                      setState(() {
                        bookNo = value as int;
                      });
                    },
                  ),
                ),
              ],
            ),
          ) : Container(),

          //
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchTextController,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(fontSize: 18.0, color: Colors.grey),
                    ),
                    keyboardType: selectedOption.id == 1 ? TextInputType.number : TextInputType.text,
                  ),
                ),
                const SizedBox(width: 18),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.purple, // Background color
                    shape: BoxShape.rectangle,
                  ),
                  child: IconButton(
                    color: Colors.white,
                    icon: const Icon(
                      Icons.search,
                      size: 30,
                    ),
                    onPressed: () async {
                      // Perform search based on selected option and entered text
                      // String searchOption = selectedOption;
                      if(_isLoading){
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Please wait for the previous search to complete'),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'Close',
                              onPressed: () {
                                // Code to execute.
                              },
                            ),
                          ),
                        );
                        return;
                      }
                      String searchText = searchTextController.text;

                      // Implement your logic for searching here
                      if(selectedOption.id ==1){
                        if(isNumeric(searchText) == false){
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Please enter a valid number'),
                              duration: const Duration(seconds: 2),
                              action: SnackBarAction(
                                label: 'Close',
                                onPressed: () {
                                  // Code to execute.
                                },
                              ),
                            ),
                          );
                          return;
                        }
                        setState(() {
                          suggestions = DBResult(baaniLines: <BaaniLineModel>[], count: 0);
                        });
                        Helper.toScreen(context, HomeScreen(bookNo: bookNo, searchView: true, searchedAng: int.parse(searchText),));
                        return;
                      }
                      setState(() {
                        _isLoading = true;
                      });
                      suggestions = await Reader.search(searchType: selectedOption.id, searchText: searchText, bookNo: bookNo);

                      setState(() {
                        _isLoading = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: _isLoading ? Center(child: const CircularProgressIndicator()) : SingleChildScrollView(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: suggestions.count,
                itemBuilder: (context, index) {
                  BaaniLineModel bani = suggestions.baaniLines[index];
                  return ListTile(
                    title: Text(asciiToGurmukhi(bani.gurmukhi ?? '').removeVishraams()),
                    onTap: () async {
                      // You can do something with the selected suggestion
                      // _controller.text = suggestions[index];
                      // print(bani.sourcePage);
                      // print(bani.shabadId);
                      if(historyItems.contains(bani) == false){
                        historyItems.add(bani);
                        await saveItems();
                      }
                      setState(() {

                      });
                      Helper.toScreen(context, HomeScreen(title: "Shabad" , bookNo: bookNo, searchView: true, searchedAng: bani.sourcePage, searchedBaaniLine: bani,));
                    },
                  );
                },
              ),
            ),
          ),


        ],
      ),
    );
  }

  // Widget _buildHistoryPage(){
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: <Widget>[
  //       const Text(
  //         'History',
  //         style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
  //       ),
  //       const SizedBox(height: 30),
  //       const Text(
  //         'No history found',
  //         style: TextStyle(fontSize: 18.0, color: Colors.grey),
  //       ),
  //       const SizedBox(height: 30),
  //       // Lottie animation
  //       ElevatedButton(
  //         onPressed: () {
  //           GoRouter.of(context).push('/home');
  //         },
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: Colors.amber, // Button color
  //           minimumSize: const Size(200, 50), // Button size
  //         ),
  //         child: const Text(
  //           'Okay',
  //           style: TextStyle(
  //             fontSize: 16,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildBookmarksPage(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Bookmarks',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        const Text(
          'No bookmarks found',
          style: TextStyle(fontSize: 18.0, color: Colors.grey),
        ),
        const SizedBox(height: 30),
        // Lottie animation
        ElevatedButton(
          onPressed: () {
            GoRouter.of(context).push('/home');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber, // Button color
            minimumSize: const Size(200, 50), // Button size
          ),
          child: const Text(
            'Okay',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuPage(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          'Menu',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        const Text(
          'No menu found',
          style: TextStyle(fontSize: 18.0, color: Colors.grey),
        ),
        const SizedBox(height: 30),
        // Lottie animation
        ElevatedButton(
          onPressed: () {
            GoRouter.of(context).push('/home');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.amber, // Button color
            minimumSize: const Size(200, 50), // Button size
          ),
          child: const Text(
            'Okay',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}