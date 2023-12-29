import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gurbani_app/models/baani_lines_model.dart';
import 'package:gurbani_app/models/calculated_items.dart';
import 'package:gurbani_app/models/db_result.dart';
import 'package:gurbani_app/services/reader.dart';
import 'package:gurbani_app/utils/languages.dart';
import 'package:gurbani_app/utils/spans.dart';
import 'package:gurbani_app/utils/theme.dart';
import 'package:gurbani_app/widgets/baani_view_widget.dart';
import 'dart:math' as math;

import 'package:flip_widget/flip_widget.dart';
import 'package:gurbani_app/widgets/calculated_view_widget.dart';
import 'package:gurbani_app/widgets/constraints.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final bool searchView;
  final int searchedAng;
  final String? title;
  final BaaniLineModel? searchedBaaniLine;
  const HomeScreen({super.key, this.title, this.pageNo = 1, this.bookNo = 1, this.isNitnem = false, this.searchView=false, this.nitnemId = 1, this.searchedAng = 1, this.searchedBaaniLine});

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
  final GlobalKey myPageKey = GlobalKey();

  DBResult currentAng = DBResult(baaniLines: List.empty(), count: 0);
  DBResult previousAng = DBResult(baaniLines: List.empty(), count: 0);
  DBResult nextAng = DBResult(baaniLines: List.empty(), count: 0);
  DBResult searchedAng = DBResult(baaniLines: List.empty(), count: 0);
  List<CalculatedItems> calculatedPages = <CalculatedItems>[];
  bool _showEnglishTransliteration = false;
  bool _showEnglishTranslation = true;
  bool _showPunjabiTranslation = true;
  bool _showPunjabiTeekaTranslation = false;
  bool _showHindiTranslation = false;
  bool _showHindiTeekaTranslation = false;
  bool _showFaridkotTeekaTranslation = false;
  bool _loadSourceLines = true;
  bool _isBookMarked = false;
  Languages _language = Languages.Gurmukhi;
  double _extraBottomPadding = 0;
  late Size size;

  Future<void> updateGurbaniLists() async {
    currentAng = await Reader.getAngs(sourcePageNo: _sourcePageNo,pageNo: _pageNo, loadSourceLines: _loadSourceLines, lines: _linesPerPage, bookNo: _bookNo);
    if(currentAng.baaniLines.isEmpty){
      if(_loadSourceLines){
        currentAng = DBResult(baaniLines: List.empty(), count: 0);
        nextAng = DBResult(baaniLines: List.empty(), count: 0);
        placeWidgetsToPage();
        setState(() {

        });
        return;
      }
      _sourcePageNo = _sourcePageNo + 1;
      _previousChapterTotalPages.add(_pageNo > 1? _pageNo-1 :1);
      _pageNo = 1;
      currentAng = await Reader.getAngs(sourcePageNo: _sourcePageNo,pageNo: _pageNo, lines: _linesPerPage, bookNo: _bookNo);
      // placeWidgetsToPage();
    }else{
      if(_loadSourceLines){
        placeWidgetsToPage();
        setState(() {

        });
        return;
      }
    }
    // print("=================================");
    placeWidgetsToPage();
    nextAng = await Reader.getAngs(sourcePageNo: _sourcePageNo,pageNo: _pageNo + 1, lines: _linesPerPage, bookNo: _bookNo);
    previousAng = _sourcePageNo ==1 && _pageNo ==1 ? DBResult(baaniLines: List.empty(), count: 0) : _sourcePageNo >=1 && _pageNo ==1 ? _previousChapterTotalPages.isEmpty ? DBResult(baaniLines: List.empty(), count: 0) : await Reader.getAngs(sourcePageNo: _sourcePageNo - 1,pageNo: _previousChapterTotalPages.last, lines: _linesPerPage) : await Reader.getAngs(sourcePageNo: _sourcePageNo,pageNo: _pageNo - 1, lines: _linesPerPage);
    setState(() {
      // print("calcualated");
      // print(calculatedPages.length);
    });
  }

  double _getAppbarAndStatusBarHeight(){
    return AppBar().preferredSize.height + MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom + _extraBottomPadding;
  }

  placeWidgetsToPage(){
    if(currentAng.baaniLines.isEmpty){
      return;
    }
    calculatedPages.clear();
    TextSpan angSpan = getSpan("Ang", style: baaniTextStyle(fontSize: 12));
    double height = getTextHeight(span: angSpan, maxWidth: size.width-2*8.w);
    double additionalHeight = 7.h;
    height += additionalHeight;
    CalculatedItems calculatedItems = CalculatedItems(textSpans: List.empty(growable: true), pageNo: 0, totalPages: 0, angNo: _sourcePageNo);
    currentAng.baaniLines.forEach((element) {
      if(_showEnglishTransliteration && element.englishTransliteration != null && element.englishTransliteration!.isNotEmpty){
        TextSpan span = getSpan(element.englishTransliteration, style: baaniTextStyle());
        if(height + _getAppbarAndStatusBarHeight() + getTextHeight(span: span, maxWidth: size.width-2*8.w) > size.height){
          calculatedItems.pageNo += 1;
          calculatedItems.totalPages += 1;
          calculatedPages.add(calculatedItems);
          height = getTextHeight(span: angSpan, maxWidth: size.width-2*8.w);
          calculatedItems = CalculatedItems(textSpans: List.empty(growable: true), pageNo: calculatedItems.pageNo, totalPages: calculatedItems.totalPages, angNo: _sourcePageNo);
          height += additionalHeight;
          height += getTextHeight(span: span, maxWidth: size.width-2*8.w);
          calculatedItems.textSpans.add(span);
        }else{
          height += getTextHeight(span: span, maxWidth: size.width-2*8.w);
          calculatedItems.textSpans.add(span);
          height += additionalHeight;
          printSizes(height);
        }
      }

      if(_showEnglishTranslation && element.translationEnglish != null && element.translationEnglish!.isNotEmpty){
        TextSpan span = getSpan(element.translationEnglish , style: baaniTextStyle());
        if(height + _getAppbarAndStatusBarHeight() + getTextHeight(span: span, maxWidth: size.width-2*8.w) > size.height){
          calculatedItems.pageNo += 1;
          calculatedItems.totalPages += 1;
          calculatedPages.add(calculatedItems);
          height = getTextHeight(span: angSpan, maxWidth: size.width-2*8.w);
          calculatedItems = CalculatedItems(textSpans: List.empty(growable: true), pageNo: calculatedItems.pageNo, totalPages: calculatedItems.totalPages, angNo: _sourcePageNo);
          height += additionalHeight;
          height += getTextHeight(span: span, maxWidth: size.width-2*8.w);
          calculatedItems.textSpans.add(span);
        }else{
          height += getTextHeight(span: span, maxWidth: size.width-2*8.w);
          calculatedItems.textSpans.add(span);
          height += additionalHeight;
          printSizes(height);
        }
      }

      if(_showPunjabiTranslation && element.translationPunjabi != null && element.translationPunjabi!.isNotEmpty){
        TextSpan span = getAsscciiSpan(element.translationPunjabi , style: baaniTextStyle());
        if(height + _getAppbarAndStatusBarHeight() + getTextHeight(span: span, maxWidth: size.width-2*8.w) > size.height){
          calculatedItems.pageNo += 1;
          calculatedItems.totalPages += 1;
          calculatedPages.add(calculatedItems);
          height = getTextHeight(span: angSpan, maxWidth: size.width-2*8.w);
          calculatedItems = CalculatedItems(textSpans: List.empty(growable: true), pageNo: calculatedItems.pageNo, totalPages: calculatedItems.totalPages, angNo: _sourcePageNo);
          height += additionalHeight;
          height += getTextHeight(span: span, maxWidth: size.width-2*8.w);
          calculatedItems.textSpans.add(span);
        }else{
          height += getTextHeight(span: span, maxWidth: size.width-2*8.w);
          calculatedItems.textSpans.add(span);
          height += additionalHeight;
          printSizes(height);
        }
      }

      if(_showPunjabiTeekaTranslation && element.translationPunjabiTeeka != null && element.translationPunjabiTeeka!.isNotEmpty){
        TextSpan span = getAsscciiSpan(element.translationPunjabiTeeka , style: baaniTextStyle());
        if(height + _getAppbarAndStatusBarHeight() + getTextHeight(span: span, maxWidth: size.width-2*8.w) > size.height){
          calculatedItems.pageNo += 1;
          calculatedItems.totalPages += 1;
          calculatedPages.add(calculatedItems);
          height = getTextHeight(span: angSpan, maxWidth: size.width-2*8.w);
          calculatedItems = CalculatedItems(textSpans: List.empty(growable: true), pageNo: calculatedItems.pageNo, totalPages: calculatedItems.totalPages, angNo: _sourcePageNo);
          height += additionalHeight;
          height += getTextHeight(span: span, maxWidth: size.width-2*8.w);
          calculatedItems.textSpans.add(span);
        }else{
          height += getTextHeight(span: span, maxWidth: size.width-2*8.w);
          calculatedItems.textSpans.add(span);
          height += additionalHeight;
          printSizes(height);
        }
      }

      if(_showFaridkotTeekaTranslation && element.translationFaridkotTeeka != null && element.translationFaridkotTeeka!.isNotEmpty){
        TextSpan span = getAsscciiSpan(element.translationFaridkotTeeka , style: baaniTextStyle());
        if(height + _getAppbarAndStatusBarHeight() + getTextHeight(span: span, maxWidth: size.width-2*8.w) > size.height){
          calculatedItems.pageNo += 1;
          calculatedItems.totalPages += 1;
          calculatedPages.add(calculatedItems);
          height = getTextHeight(span: angSpan, maxWidth: size.width-2*8.w);
          calculatedItems = CalculatedItems(textSpans: List.empty(growable: true), pageNo: calculatedItems.pageNo, totalPages: calculatedItems.totalPages, angNo: _sourcePageNo);
          height += additionalHeight;
          height += getTextHeight(span: span, maxWidth: size.width-2*8.w);
          calculatedItems.textSpans.add(span);
        }else{
          height += getTextHeight(span: span, maxWidth: size.width-2*8.w);
          calculatedItems.textSpans.add(span);
          height += additionalHeight;
          printSizes(height);
        }
      }

      if(_showHindiTranslation && element.translationHindi != null && element.translationHindi!.isNotEmpty){
        TextSpan span = getAsscciiSpan(element.translationHindi , style: baaniTextStyle());
        if(height + _getAppbarAndStatusBarHeight() + getTextHeight(span: span, maxWidth: size.width-2*8.w) > size.height){
          calculatedItems.pageNo += 1;
          calculatedItems.totalPages += 1;
          calculatedPages.add(calculatedItems);
          height = getTextHeight(span: angSpan, maxWidth: size.width-2*8.w);
          calculatedItems = CalculatedItems(textSpans: List.empty(growable: true), pageNo: calculatedItems.pageNo, totalPages: calculatedItems.totalPages, angNo: _sourcePageNo);
          height += additionalHeight;
          height += getTextHeight(span: span, maxWidth: size.width-2*8.w);
          calculatedItems.textSpans.add(span);
        }else{
          height += getTextHeight(span: span, maxWidth: size.width-2*8.w);
          calculatedItems.textSpans.add(span);
          height += additionalHeight;
          printSizes(height);
        }
      }

      if(_showHindiTeekaTranslation && element.translationHindiTeeka != null && element.translationHindiTeeka!.isNotEmpty){
        TextSpan span = getAsscciiSpan(element.translationHindiTeeka , style: baaniTextStyle());
        if(height + _getAppbarAndStatusBarHeight() + getTextHeight(span: span, maxWidth: size.width-2*8.w) > size.height){
          calculatedItems.pageNo += 1;
          calculatedItems.totalPages += 1;
          calculatedPages.add(calculatedItems);
          height = getTextHeight(span: angSpan, maxWidth: size.width-2*8.w);
          calculatedItems = CalculatedItems(textSpans: List.empty(growable: true), pageNo: calculatedItems.pageNo, totalPages: calculatedItems.totalPages, angNo: _sourcePageNo);
          height += additionalHeight;
          height += getTextHeight(span: span, maxWidth: size.width-2*8.w);
          calculatedItems.textSpans.add(span);
        }else{
          height += getTextHeight(span: span, maxWidth: size.width-2*8.w);
          calculatedItems.textSpans.add(span);
          height += additionalHeight;
          printSizes(height);
        }
      }

      if(_language == Languages.Both) {
        if(element.gurmukhi.isNotEmpty){
          TextSpan span =
              getAsscciiSpan(element.gurmukhi, style: baaniTextStyle());
          if (height +
                  _getAppbarAndStatusBarHeight() +
                  getTextHeight(span: span, maxWidth: size.width - 2 * 8.w) >
              size.height) {
            calculatedItems.pageNo += 1;
            calculatedItems.totalPages += 1;
            calculatedPages.add(calculatedItems);
            height =
                getTextHeight(span: angSpan, maxWidth: size.width - 2 * 8.w);
            calculatedItems = CalculatedItems(
                textSpans: List.empty(growable: true),
                pageNo: calculatedItems.pageNo,
                totalPages: calculatedItems.totalPages,
                angNo: _sourcePageNo);
            height += additionalHeight;
            height += getTextHeight(span: span, maxWidth: size.width - 2 * 8.w);
            calculatedItems.textSpans.add(span);
          } else {
            height += getTextHeight(span: span, maxWidth: size.width - 2 * 8.w);
            calculatedItems.textSpans.add(span);
            height += additionalHeight;
            printSizes(height);
          }
        }
        if( element.hindiTransliteration != null && element.hindiTransliteration!.isNotEmpty){
          TextSpan span2 = getAsscciiSpan(element.hindiTransliteration,
              style: baaniTextStyle());
          if (height +
                  _getAppbarAndStatusBarHeight() +
                  getTextHeight(span: span2, maxWidth: size.width - 2 * 8.w) >
              size.height) {
            calculatedItems.pageNo += 1;
            calculatedItems.totalPages += 1;
            calculatedPages.add(calculatedItems);
            height =
                getTextHeight(span: angSpan, maxWidth: size.width - 2 * 8.w);
            calculatedItems = CalculatedItems(
                textSpans: List.empty(growable: true),
                pageNo: calculatedItems.pageNo,
                totalPages: calculatedItems.totalPages,
                angNo: _sourcePageNo);
            height += additionalHeight;
            height +=
                getTextHeight(span: span2, maxWidth: size.width - 2 * 8.w);
            calculatedItems.textSpans.add(span2);
          } else {
            height +=
                getTextHeight(span: span2, maxWidth: size.width - 2 * 8.w);
            calculatedItems.textSpans.add(span2);
            height += additionalHeight;
            printSizes(height);
          }
        }
      }else if(_language == Languages.Gurmukhi){
        if(element.gurmukhi.isNotEmpty){
          TextSpan span =
              getAsscciiSpan(element.gurmukhi, style: baaniTextStyle());
          if (height +
                  _getAppbarAndStatusBarHeight() +
                  getTextHeight(span: span, maxWidth: size.width - 2 * 8.w) >
              size.height) {
            calculatedItems.pageNo += 1;
            calculatedItems.totalPages += 1;
            calculatedPages.add(calculatedItems);
            height =
                getTextHeight(span: angSpan, maxWidth: size.width - 2 * 8.w);
            calculatedItems = CalculatedItems(
                textSpans: List.empty(growable: true),
                pageNo: calculatedItems.pageNo,
                totalPages: calculatedItems.totalPages,
                angNo: _sourcePageNo);
            height += additionalHeight;
            height += getTextHeight(span: span, maxWidth: size.width - 2 * 8.w);
            calculatedItems.textSpans.add(span);
          } else {
            height += getTextHeight(span: span, maxWidth: size.width - 2 * 8.w);
            calculatedItems.textSpans.add(span);
            height += additionalHeight;
            printSizes(height);
          }
        }
      }else{
        if(element.hindiTransliteration != null && element.hindiTransliteration!.isNotEmpty){
          TextSpan span = getAsscciiSpan(element.hindiTransliteration,
              style: baaniTextStyle());
          if (height +
                  _getAppbarAndStatusBarHeight() +
                  getTextHeight(span: span, maxWidth: size.width - 2 * 8.w) >
              size.height) {
            calculatedItems.pageNo += 1;
            calculatedItems.totalPages += 1;
            calculatedPages.add(calculatedItems);
            height =
                getTextHeight(span: angSpan, maxWidth: size.width - 2 * 8.w);
            calculatedItems = CalculatedItems(
                textSpans: List.empty(growable: true),
                pageNo: calculatedItems.pageNo,
                totalPages: calculatedItems.totalPages,
                angNo: _sourcePageNo);
            height += additionalHeight;
            height += getTextHeight(span: span, maxWidth: size.width - 2 * 8.w);
            calculatedItems.textSpans.add(span);
          } else {
            height += getTextHeight(span: span, maxWidth: size.width - 2 * 8.w);
            calculatedItems.textSpans.add(span);
            height += additionalHeight;
            printSizes(height);
          }
        }
      }

    });
      //   change total pages of all calculated items to the length of calculated pages
    calculatedPages.forEach((element) {
      element.totalPages = calculatedPages.length;
    });


  }

  printSizes(height) {
    // print("========== Sizes ===========");
    // print(size.height);
    // print(height + _getAppbarAndStatusBarHeight());
  }

  Future<void> getSearchedAng() async {
    setState(() {
      _isLoading = true;
    });
    searchedAng = await Reader.search(searchType: 1, searchText: widget.searchedAng.toString(), shabadId: widget.searchedBaaniLine?.shabadId, bookNo: widget.searchedBaaniLine == null ? widget.bookNo : widget.searchedBaaniLine!.orderId > 60555 ? 2 : 1 );
    setState(() {
      _isLoading = false;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      // Scrollable.ensureVisible(
      //   _scrollKey.currentContext!,
      //   duration: const Duration(milliseconds: 500),
      //   curve: Curves.easeInOut,
      // );
    });
  }

  isBookmarked() async {
    final prefs = SharedPreferences.getInstance();
    final List<BaaniLineModel>? storedItems = await prefs.then((value) => value.getStringList('myBookmarksList')?.map((e) => BaaniLineModel.fromJson(jsonDecode(e))).toList());
    if (storedItems != null) {
      if(storedItems.contains(widget.searchedBaaniLine)){
        _isBookMarked = true;
      }else{
        _isBookMarked = false;
      }
      return;
    }
    _isBookMarked = false;
  }

  saveToBookmarks(BaaniLineModel baaniLine) async {
    final prefs = await SharedPreferences.getInstance();
    final List<BaaniLineModel>? storedItems = prefs.getStringList('myBookmarksList')?.map((e) => BaaniLineModel.fromJson(jsonDecode(e))).toList();
    if (storedItems != null) {
      if(storedItems.contains(baaniLine)){
        storedItems.remove(baaniLine);
        prefs.setStringList('myBookmarksList', storedItems.map((e) => jsonEncode(e.toJson())).toList());
        setState(() {
          _isBookMarked = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Removed from bookmark'),
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
      storedItems.add(baaniLine);
      prefs.setStringList('myBookmarksList', storedItems.map((e) => jsonEncode(e.toJson())).toList());
      // await isBookmarked();
      setState(() {
        _isBookMarked = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Bookmarked'),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Code to execute.
            },
          ),
        ),
      );
    } else {
      prefs.setStringList('myBookmarksList', [jsonEncode(baaniLine.toJson())]);
      setState(() {
        _isBookMarked = true;
      });
    }
  }

  Future<void> updateNitnemLists() async {
    // print(_linesPerPage);
    // print(currentAng.count);
    // print("================================");
    if(currentAng.count ==0){
      setState(() {
        _isLoading = true;
      });
      currentAng = await Reader.getNitnemAngs(nitnemId: _nitnemId);
      // placeWidgetsToPage();
    }
    // currentAng = await Reader.getNitnemAngs(nitnemId: _nitnemId);
    if(currentAng.baaniLines.isEmpty){
      currentAng = DBResult(baaniLines: List.empty(), count: 0);
      placeWidgetsToPage();
      setState(() {
        _isLoading = false;
      });
      return;
    }
    placeWidgetsToPage();
    nextAng = await Reader.getAngs(sourcePageNo: _sourcePageNo,pageNo: _pageNo + 1, lines: _linesPerPage, bookNo: _bookNo);
    previousAng = _sourcePageNo ==1 && _pageNo ==1 ? DBResult(baaniLines: List.empty(), count: 0) : _sourcePageNo >=1 && _pageNo ==1 ? _previousChapterTotalPages.isEmpty ? DBResult(baaniLines: List.empty(), count: 0) : await Reader.getAngs(sourcePageNo: _sourcePageNo - 1,pageNo: _previousChapterTotalPages.last, lines: _linesPerPage) : await Reader.getAngs(sourcePageNo: _sourcePageNo,pageNo: _pageNo - 1, lines: _linesPerPage);
    setState(() {
      _isLoading = false;
    });
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
    _extraBottomPadding = 50.h;
    super.initState();
    resetLinesPerPage();
    isBookmarked();
    // updateGurbaniLists(); //kro
    // setState(() {});
  }

  resetLinesPerPage(){
    if(widget.searchView){
      getSearchedAng();
      return;
    }
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
    // print(_bookNo);

    size = Size(MediaQuery.sizeOf(context).width, MediaQuery.sizeOf(context).height);
    // print(size.height);
    // print(widget.bookNo);
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
          title: Text( widget.title ?? 'Gurbani'),
          actions: [
            // IconButton(
            //   icon: Icon(Icons.search),
            //   onPressed: () {
            //     showSearch(
            //       context: context,
            //       delegate: BaaniSearchDelegate(),
            //     );
            //   },
            // ),
            widget.searchView && widget.searchedBaaniLine != null ? IconButton(
              icon: Icon(_isBookMarked ? Icons.favorite : Icons.favorite_outline,color: whiteColor,),
              onPressed: () async {
                await saveToBookmarks(widget.searchedBaaniLine!);
                setState(() {
                  // _isBookMarked = !_isBookMarked;
                });
              },
            ) : Container(),
            IconButton(
              icon: const Icon(Icons.build,color: whiteColor,),
              onPressed: () {
                // Handle tool icon tap
                // Add your functionality here
              },
            ),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert,color: whiteColor,),
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    child:  Text('Share as Text'),
                    // Add your functionality for Item 1
                  ),
                  const PopupMenuItem(
                    child: Text('Share as Image'),
                    // Add your functionality for Item 2
                  ),
                  // Add more PopupMenuItems as needed
                ];
              },
            ),
          ],
        ),
        body: widget.searchView ? BaaniPageView(
            baaniLines: searchedAng,
          linesPerPage: searchedAng.count,
          showEnglishTransliteration: _showEnglishTransliteration,
          showEnglishTranslation: _showEnglishTranslation,
          showPunjabiTranslation: _bookNo == 1 ? _showPunjabiTranslation : false,
          showPunjabiTeekaTranslation: _showPunjabiTeekaTranslation,
          showFaridkotTeekaTranslation: _showFaridkotTeekaTranslation,
          showHindiTranslation: _showHindiTranslation,
          showHindiTeekaTranslation: _showHindiTeekaTranslation,
          language: _language,
          isLoading: _isLoading,
          searchedLine: widget.searchedBaaniLine,
          showPageNo: false,
        ) : Stack(
          children: [
            Container(
              color: Colors.black,
              height: size.height - _getAppbarAndStatusBarHeight() + _extraBottomPadding,
              width: size.width,
              child: Center(
                child: CalculatedViewWidget(
                    baaniLines: calculatedPages.isEmpty || calculatedPages.length <=1 || calculatedPages.length >= _pageNo ? CalculatedItems(textSpans: List.empty(growable: true), pageNo: 0, totalPages: 0) : calculatedPages[_pageNo],
                  isLoading: _isLoading,
                ),
              ),
            ),

//kro ik var
//same as before just smooth onlu

            SizedBox(
              width: size.width,
              height: size.height - _getAppbarAndStatusBarHeight() + _extraBottomPadding,
              child: GestureDetector(
                child: FlipWidget(
                  key: _flipKey,
                  textureSize: Size(size.width, size.height - _getAppbarAndStatusBarHeight() + _extraBottomPadding) * 1,
                  // leftToRight: true, //
                  child: Container(
                    color: Color(0xFFaaaaaa),
                    child: Center(
                      child: CalculatedViewWidget(
                        baaniLines: calculatedPages.isEmpty ? CalculatedItems(textSpans: List.empty(growable: true), pageNo: 0, totalPages: 0) : calculatedPages[(_pageNo < 1 ? 1 : _pageNo)-1],
                        isLoading: _isLoading,
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
                      if(_sourcePageNo < 1){
                        _sourcePageNo = 1;
                      }
                      _pageNo = _previousChapterTotalPages.isEmpty ? 0 : _previousChapterTotalPages.last;
                      if(_previousChapterTotalPages.isNotEmpty){
                        _previousChapterTotalPages.removeLast();
                      }
                    }else if(_sourcePageNo >=1 && _pageNo >= 1){
                      _pageNo -= 1;
                      // print(_pageNo);
                    }
                  }else if(isLeftToRight == false){
                    _pageNo += 1;
                  }
                  if(isLeftToRight != null){
                    if(_isNitnem){
                      // if(currentAng.baaniLines.length - (_linesPerPage * (_pageNo)) <0){
                      //   _pageNo = (currentAng.baaniLines.length/_linesPerPage).ceil();
                      //   // return;
                      // }
                      if(_pageNo > calculatedPages.length){
                        _pageNo = calculatedPages.length;
                        return;
                      }

                      updateNitnemLists();
                    }else{
                      if(_loadSourceLines){
                        if(calculatedPages.length - (_pageNo) <0){
                          _pageNo = 1;
                          _sourcePageNo += 1;
                          // return;
                        }

                        // if((currentAng.baaniLines.length - (_linesPerPage * (_pageNo)) <0) && (currentAng.baaniLines.length - (_linesPerPage * (_pageNo-1)) <=0)){
                        //   _pageNo = 1;
                        //   _sourcePageNo += 1;
                        //   // return;
                        // }
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


/*
BaaniPageView(
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





                ========================================================



                BaaniPageView(
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

 */
