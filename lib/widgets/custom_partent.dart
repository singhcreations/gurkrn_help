import 'package:flutter/material.dart';

class CustomParentWidget extends StatelessWidget {
  Widget? appBarWidget;
  Widget? drawerWidget;
  Widget? bodyWidget;
  Widget? bottomNavBarWidget;
  CustomParentWidget(
      {this.appBarWidget,
        this.drawerWidget,
        this.mainDrawerKey,
        this.bodyWidget,
        this.bottomNavBarWidget,
        Key? key})
      : super(key: key);

  GlobalKey<ScaffoldState>? mainDrawerKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    late MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return MediaQuery(
        data: queryData.copyWith(textScaleFactor: 1.0),
        child: SafeArea(
          child: Scaffold(
            key: mainDrawerKey ?? mainDrawerKey,
            drawer: drawerWidget ?? const SizedBox(),
            appBar: PreferredSize(
              child: appBarWidget ?? const SizedBox(),
              preferredSize: const Size.fromHeight(55),
            ),
            body: bodyWidget,
            bottomNavigationBar: bottomNavBarWidget ?? const SizedBox(),
          ),
        ));
  }
}