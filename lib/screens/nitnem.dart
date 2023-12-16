import 'package:gurbani_app/models/custom_model.dart';
import 'package:gurbani_app/widgets/constraints.dart';
import 'package:gurbani_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gurbani_app/widgets/customnkwell.dart';


class NitnemScreen extends StatefulWidget {
  const NitnemScreen({Key? key}) : super(key: key);

  @override
  _NitnemScreenState createState() => _NitnemScreenState();
}

class _NitnemScreenState extends State<NitnemScreen> {


  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      initialIndex: 0,
      length: 2,

      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: kplayer,
            leading: IconButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_sharp,
                  color: whiteColor,)),
            title: CustomText(
              title: "Nitnem Screen",
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: whiteColor,
            ),
            bottom: const TabBar(
              indicatorColor: whiteColor,
              labelPadding: EdgeInsets.symmetric(horizontal: 30),
              isScrollable: true,
              tabs: [
                Tab(child: Text(("Punjabi"),style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16.0,color: whiteColor))),
                Tab(child: Text(("Hindi"),style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16.0,color: whiteColor))),

              ],
            ),

          ),
          body: TabBarView(
              children: [
                ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    itemCount: nitnemScreenList.length,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context,index){
                      return Container(
                        padding: EdgeInsets.only(bottom: 8,left: 16,right: 16),
                        decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1,
                                  color: extraLightGreyColor
                              )
                          ),
                        ),
                        child: CustomInkWell(
                          onTap: () async {

                          },
                          child: Container(
                            height: 50,
                            padding: EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 2,top: 5,bottom: 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          //title
                                          CustomText(
                                            title: nitnemScreenList[index].title,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: blackColor,
                                          ) ,
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    itemCount: nitnemScreenList.length,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context,index){
                      return Container(
                        padding: EdgeInsets.only(bottom: 8,left: 16,right: 16),
                        decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1,
                                  color: extraLightGreyColor
                              )
                          ),
                        ),
                        child: CustomInkWell(
                          onTap: () async {
                          },
                          child: Container(
                            height: 50,
                            padding: EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 2,top: 5,bottom: 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          //title
                                          CustomText(
                                            title: nitnemScreenList[index].subTitle,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: blackColor,
                                          ) ,
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
              ]
          )),
    );
  }
}