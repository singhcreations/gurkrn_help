import 'package:flutter/material.dart';
import 'package:gurbani_app/models/baani_lines_model.dart';
import 'package:gurbani_app/models/db_result.dart';
import 'package:gurbani_app/services/reader.dart';
import 'package:gurbani_app/utils/languages.dart';
import 'package:gurbani_app/widgets/baani_view_widget.dart';
import 'dart:math' as math;

import 'package:flip_widget/flip_widget.dart';

//ToDo: This class has to be renamed because this won't be the homescreen

  // Future<void> updateGurbaniLists() async {
  //   // print(_linesPerPage);
  //   currentAng = await Reader.getAngs(sourcePageNo: _sourcePageNo,pageNo: _pageNo, loadSourceLines: true, lines: _linesPerPage, bookNo: _bookNo);
  //   if(currentAng.baaniLines.isEmpty){
  //     _sourcePageNo = _sourcePageNo + 1;
  //     _previousChapterTotalPages.add(_pageNo > 1? _pageNo-1 :1);
  //     _pageNo = 1;
  //     currentAng = await Reader.getAngs(sourcePageNo: _sourcePageNo,pageNo: _pageNo, lines: _linesPerPage, bookNo: _bookNo);
  //   }
  //   nextAng = await Reader.getAngs(sourcePageNo: _sourcePageNo,pageNo: _pageNo + 1, lines: _linesPerPage, bookNo: _bookNo);
  //   previousAng = _sourcePageNo ==1 && _pageNo ==1 ? DBResult(baaniLines: List.empty(), count: 0) : _sourcePageNo >=1 && _pageNo ==1 ? _previousChapterTotalPages.isEmpty ? DBResult(baaniLines: List.empty(), count: 0) : await Reader.getAngs(sourcePageNo: _sourcePageNo - 1,pageNo: _previousChapterTotalPages.last, lines: _linesPerPage) : await Reader.getAngs(sourcePageNo: _sourcePageNo,pageNo: _pageNo - 1, lines: _linesPerPage);
  //   setState(() {});
  // }

class HomeScreen extends StatefulWidget {
  final int pageNo;
  final int bookNo;
  final bool isNitnem;
  final int nitnemId;
  const HomeScreen({super.key, this.pageNo = 1, this.bookNo = 1, this.isNitnem = false, this.nitnemId = 1});

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
  final GlobalKey<FlipWidgetState> _flipKey = GlobalKey();

  DBResult currentAng = DBResult(baaniLines: List.empty(), count: 0);
  DBResult previousAng = DBResult(baaniLines: List.empty(), count: 0);
  DBResult nextAng = DBResult(baaniLines: List.empty(), count: 0);
  bool _showEnglishTransliteration = false;
  bool _showEnglishTranslation = true;
  bool _showPunjabiTranslation = true;
  bool _showPunjabiTeekaTranslation = false;
  bool _showHindiTranslation = false;
  bool _showHindiTeekaTranslation = false;
  bool _showFaridkotTeekaTranslation = false;
  bool _loadSourceLines = true;
  Languages _language = Languages.Gurmukhi;

  Future<void> updateGurbaniLists() async {
    currentAng = await Reader.getAngs(sourcePageNo: _sourcePageNo,pageNo: _pageNo, loadSourceLines: _loadSourceLines, lines: _linesPerPage, bookNo: _bookNo);
    if(currentAng.baaniLines.isEmpty){
      if(_loadSourceLines){
        currentAng = DBResult(baaniLines: List.empty(), count: 0);
        nextAng = DBResult(baaniLines: List.empty(), count: 0);
        setState(() {

        });
        return;
      }
      _sourcePageNo = _sourcePageNo + 1;
      _previousChapterTotalPages.add(_pageNo > 1? _pageNo-1 :1);
      _pageNo = 1;
      currentAng = await Reader.getAngs(sourcePageNo: _sourcePageNo,pageNo: _pageNo, lines: _linesPerPage, bookNo: _bookNo);
    }else{
      if(_loadSourceLines){
        setState(() {

        });
        return;
      }
    }
    nextAng = await Reader.getAngs(sourcePageNo: _sourcePageNo,pageNo: _pageNo + 1, lines: _linesPerPage, bookNo: _bookNo);
    previousAng = _sourcePageNo ==1 && _pageNo ==1 ? DBResult(baaniLines: List.empty(), count: 0) : _sourcePageNo >=1 && _pageNo ==1 ? _previousChapterTotalPages.isEmpty ? DBResult(baaniLines: List.empty(), count: 0) : await Reader.getAngs(sourcePageNo: _sourcePageNo - 1,pageNo: _previousChapterTotalPages.last, lines: _linesPerPage) : await Reader.getAngs(sourcePageNo: _sourcePageNo,pageNo: _pageNo - 1, lines: _linesPerPage);
    setState(() {});
  }

  Future<void> updateNitnemLists() async {
    // print(_linesPerPage);
    if(currentAng.count ==0){
      setState(() {
        _isLoading = true;
      });
      currentAng = await Reader.getNitnemAngs(nitnemId: _nitnemId);
      setState(() {
        _isLoading = false;
      });
    }
    // currentAng = await Reader.getNitnemAngs(nitnemId: _nitnemId);
    if(currentAng.baaniLines.isEmpty){
      currentAng = DBResult(baaniLines: List.empty(), count: 0);
      return;
    }
    nextAng = await Reader.getAngs(sourcePageNo: _sourcePageNo,pageNo: _pageNo + 1, lines: _linesPerPage, bookNo: _bookNo);
    previousAng = _sourcePageNo ==1 && _pageNo ==1 ? DBResult(baaniLines: List.empty(), count: 0) : _sourcePageNo >=1 && _pageNo ==1 ? _previousChapterTotalPages.isEmpty ? DBResult(baaniLines: List.empty(), count: 0) : await Reader.getAngs(sourcePageNo: _sourcePageNo - 1,pageNo: _previousChapterTotalPages.last, lines: _linesPerPage) : await Reader.getAngs(sourcePageNo: _sourcePageNo,pageNo: _pageNo - 1, lines: _linesPerPage);
    setState(() {});
    // if(_pageNo >1 && currentAng.baaniLines.length-1 < _linesPerPage*_pageNo){
    //   // print("reducing page no");
    //   // _pageNo -= 1;
    //
    //   // _sourcePageNo += 1;
    //   // return;
    // }
  }

  int _pageNo = 1;
  int _sourcePageNo = 1;
  int _linesPerPage = 10;
  int _bookNo = 1;
  bool _isNitnem = false;
  int _nitnemId = 1;
  bool _isLoading = false;
  bool? isLeftToRight;
  List<int> _previousChapterTotalPages = <int>[];

  Offset _oldPosition = Offset.zero;
  @override
  void initState() {
    _sourcePageNo = widget.pageNo;
    _bookNo = widget.bookNo;
    _isNitnem = widget.isNitnem;
    _nitnemId = widget.nitnemId;
    super.initState();
    resetLinesPerPage();
    // updateGurbaniLists(); //kro
    // setState(() {});
  }

  resetLinesPerPage(){
    int linesToShow = 0;
    if(_language == Languages.Both){
      linesToShow = 2;
    }else{
      linesToShow = 1;
    }
    if(_bookNo == 1){
      if(_showEnglishTransliteration){
        linesToShow += 1;
      }
      if(_showEnglishTranslation){
        linesToShow += 1;
      }
      if(_showPunjabiTranslation){
        linesToShow += 1;
      }
      if(_showPunjabiTeekaTranslation){
        linesToShow += 1;
      }
      if(_showHindiTranslation){
        linesToShow += 1;
      }
      if(_showHindiTeekaTranslation){
        linesToShow += 1;
      }
      if(_showFaridkotTeekaTranslation){
        linesToShow += 1;
      }
    }else{
      if(_showEnglishTransliteration){
        linesToShow += 1;
      }
      if(_showEnglishTranslation){
        linesToShow += 1;
      }
    }
    _linesPerPage = (10-linesToShow);
    // _linesPerPage = _language == Languages.Both && _showEnglishTransliteration ? 6 : _language == Languages.Both && !_showEnglishTransliteration ? 7 : _showEnglishTransliteration ? 7 : 10;
    if(_isNitnem){
      updateNitnemLists();
    }else{
      updateGurbaniLists();
    }
  }

  // double _lineHeight({required Text textWidget}) {
  //   final textPainter = TextPainter(
  //     text: textWidget.text!.textSpan,
  //     textDirection: TextDirection.ltr,
  //     maxLines: 999, // A large number to ensure we get an accurate estimate
  //   );
  //
  //   textPainter.layout(maxWidth: widget.maxWidth);
  //   textPainter.computeLineMetrics().length;
  //   setState(() {
  //   });
  // }

  goToSourcePage(int sourcePageNo){
    _sourcePageNo = sourcePageNo;
    _pageNo = 1;
    _previousChapterTotalPages.clear();
    updateGurbaniLists();
  }

  @override
  Widget build(BuildContext context) {
    // updateGurbaniLists(pageNo);

    Size size = MediaQuery.sizeOf(context);
    // print(MediaQuery.of(context).size.height);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        drawer: Drawer(
          child: ListView(
            children: _bookNo == 1 ? [
              ListTile(
                title: const Text('English Transliteration'),
                trailing: Switch(
                  value: _showEnglishTransliteration,
                  onChanged: (value) {
                      _showEnglishTransliteration = value;
                      resetLinesPerPage();
                  },
                ),
              ),
              ListTile(
                title: const Text('English Translation'),
                trailing: Switch(
                  value: _showEnglishTranslation,
                  onChanged: (value) {
                      _showEnglishTranslation = value;
                      resetLinesPerPage();
                  },
                ),
              ),
              ListTile(
                title: const Text('Punjabi Translation'),
                trailing: Switch(
                  value: _showPunjabiTranslation,
                  onChanged: (value) {
                      _showPunjabiTranslation = value;
                      resetLinesPerPage();
                  },
                ),
              ),ListTile(
                title: const Text('Punjabi Teeka'),
                trailing: Switch(
                  value: _showPunjabiTeekaTranslation,
                  onChanged: (value) {
                      _showPunjabiTeekaTranslation= value;
                      resetLinesPerPage();
                  },
                ),
              ),ListTile(
                title: const Text('Faridkot Teeka'),
                trailing: Switch(
                  value: _showFaridkotTeekaTranslation,
                  onChanged: (value) {
                      _showFaridkotTeekaTranslation = value;
                      resetLinesPerPage();
                  },
                ),
              ),
              // ListTile(
              //   title: const Text('Hindi Translation'),
              //   trailing: Switch(
              //     value: _showHindiTranslation,
              //     onChanged: (value) {
              //         _showHindiTranslation = value;
              //         resetLinesPerPage();
              //     },
              //   ),
              // ),
              // ListTile(
              //   title: const Text('Hindi Teeka'),
              //   trailing: Switch(
              //     value: _showHindiTeekaTranslation,
              //     onChanged: (value) {
              //         _showHindiTeekaTranslation = value;
              //         resetLinesPerPage();
              //     },
              //   ),
              // ),
              ListTile(
                title: Text('Language'),
                trailing: DropdownButton<Languages>(
                  value: _language,
                  onChanged: (Languages? newValue) {
                      _language = newValue!;
                      resetLinesPerPage();
                  },
                  items: Languages.values
                      .map<DropdownMenuItem<Languages>>((Languages value) {
                    return DropdownMenuItem<Languages>(
                      value: value,
                      child: Text(value.toString().split('.').last),
                    );
                  }).toList(),
                ),
              ),
            ] : [
              ListTile(
                title: const Text('English Transliteration'),
                trailing: Switch(
                  value: _showEnglishTransliteration,
                  onChanged: (value) {
                    _showEnglishTransliteration = value;
                    resetLinesPerPage();
                  },
                ),
              ),
              ListTile(
                title: const Text('English Translation'),
                trailing: Switch(
                  value: _showEnglishTranslation,
                  onChanged: (value) {
                    _showEnglishTranslation = value;
                    resetLinesPerPage();
                  },
                ),
              ),
              ListTile(
                title: Text('Language'),
                trailing: DropdownButton<Languages>(
                  value: _language,
                  onChanged: (Languages? newValue) {
                    _language = newValue!;
                    resetLinesPerPage();
                  },
                  items: Languages.values
                      .map<DropdownMenuItem<Languages>>((Languages value) {
                    return DropdownMenuItem<Languages>(
                      value: value,
                      child: Text(value.toString().split('.').last),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Gurbani'),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: BaaniSearchDelegate(),
                );
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
              color: Colors.black,
              child: Center(
                child: BaaniPageView(
                    baaniLines: _loadSourceLines || _isNitnem ?
                                currentAng.baaniLines.length ~/ (_linesPerPage*(_pageNo)) ==0 ?
                                  DBResult(baaniLines: List.empty(), count: 0) :
                                  currentAng.baaniLines.length < _pageNo*_linesPerPage ?
                                    DBResult(baaniLines: List.empty(), count: 0) :
                                    DBResult(
                                      baaniLines: currentAng.baaniLines.sublist(
                                          _pageNo*_linesPerPage ,
                                          (_pageNo+1)*_linesPerPage >= currentAng.baaniLines.length ?
                                            currentAng.baaniLines.length :
                                            (_pageNo+1)*_linesPerPage),
                                      count: _linesPerPage) :
                                nextAng,
                    pageNo: (currentAng.count/_linesPerPage).ceil() == _pageNo ? 1 : _pageNo+1,
                    totalPages: _loadSourceLines || _isNitnem ? (currentAng.count/_linesPerPage).ceil() : (nextAng.count/_linesPerPage).ceil(),
                    linesPerPage: _linesPerPage,
                    showEnglishTransliteration: _showEnglishTransliteration,
                    showEnglishTranslation: _showEnglishTranslation,
                    showPunjabiTranslation: _bookNo == 1 ? _showPunjabiTranslation : false,
                    showPunjabiTeekaTranslation: _showPunjabiTeekaTranslation,
                    showFaridkotTeekaTranslation: _showFaridkotTeekaTranslation,
                    showHindiTranslation: _showHindiTranslation,
                    showHindiTeekaTranslation: _showHindiTeekaTranslation,
                    language: _language,
                  isLoading: _isLoading,
                  showAng: _isNitnem ? false : true,
                ),
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
                    color: Color(0xFFaaaaaa),
                    child: Center(
                      child: BaaniPageView(
                          baaniLines: _loadSourceLines || _isNitnem ?
                                      currentAng.baaniLines.length < _pageNo*_linesPerPage ?
                                          _pageNo >1 ?
                                            DBResult(
                                                baaniLines: currentAng.baaniLines.sublist(
                                                    (_pageNo-1)*_linesPerPage,
                                                    (_pageNo)*_linesPerPage >= currentAng.baaniLines.length ?
                                                      currentAng.baaniLines.length :
                                                      _pageNo*_linesPerPage
                                                ),
                                                count: _linesPerPage
                                            ) :
                                            DBResult(baaniLines: List.empty(), count: 0) :
                                      DBResult(
                                          baaniLines: currentAng.baaniLines.sublist(
                                              (_pageNo-1)*_linesPerPage,
                                              (_pageNo)*_linesPerPage >= currentAng.baaniLines.length ?
                                                currentAng.baaniLines.length :
                                                _pageNo*_linesPerPage
                                          ),
                                          count: _linesPerPage
                                      ) : currentAng,
                          pageNo: _pageNo,
                          totalPages: (currentAng.count/_linesPerPage).ceil(),
                          linesPerPage: _linesPerPage,
                          showEnglishTransliteration: _showEnglishTransliteration,
                          showEnglishTranslation: _showEnglishTranslation,
                          showPunjabiTranslation: _bookNo == 1 ? _showPunjabiTranslation : false,
                          showPunjabiTeekaTranslation: _showPunjabiTeekaTranslation,
                          showFaridkotTeekaTranslation: _showFaridkotTeekaTranslation,
                          showHindiTranslation: _showHindiTranslation,
                          showHindiTeekaTranslation: _showHindiTeekaTranslation,
                          language: _language,
                        isLoading: _isLoading,
                        showAng: _isNitnem ? false : true,
                      ),
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
                    if(_sourcePageNo==1 && _pageNo == 1){
                      return;
                    }else if(_sourcePageNo >=1 && _pageNo == 1){
                      _sourcePageNo -= 1;
                      _pageNo = _previousChapterTotalPages.last;
                      _previousChapterTotalPages.removeLast();
                    }else if(_sourcePageNo >=1 && _pageNo >= 1){
                      _pageNo -= 1;
                      // print(_pageNo);
                    }
                  }else if(isLeftToRight == false){
                    _pageNo += 1;
                  }
                  if(isLeftToRight != null){
                    if(_isNitnem){
                      if(currentAng.baaniLines.length - (_linesPerPage * (_pageNo)) <0){
                        _pageNo = (currentAng.baaniLines.length/_linesPerPage).ceil();
                        // return;
                      }

                      updateNitnemLists();
                    }else{
                      if(_loadSourceLines){
                        if((currentAng.baaniLines.length - (_linesPerPage * (_pageNo)) <0) && (currentAng.baaniLines.length - (_linesPerPage * (_pageNo-1)) <=0)){
                          _pageNo = 1;
                          _sourcePageNo += 1;
                          // return;
                        }
                        // updateGurbaniLists();
                        // return;
                      }
                      updateGurbaniLists();//kro
                    }
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

class BaaniSearchDelegate extends SearchDelegate<BaaniLineModel> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => Navigator.of(context).pop(),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Search Results'),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Search Suggestions'),
      ),
    );
  }
}
