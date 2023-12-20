import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gurbani_app/models/nitnem_model.dart';
import 'package:gurbani_app/screens/home_screen.dart';
import 'package:gurbani_app/services/reader.dart';
import 'package:gurbani_app/widgets/constraints.dart';
import 'package:gurbani_app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:gurbani_app/widgets/customnkwell.dart';
import 'package:gurbani_app/widgets/helper.dart';
import 'package:gurmukhi_utils/gurmukhi_utils.dart';


class NitnemScreen extends StatefulWidget {
  const NitnemScreen({Key? key}) : super(key: key);

  @override
  _NitnemScreenState createState() => _NitnemScreenState();
}

class _NitnemScreenState extends State<NitnemScreen> {
  List<NitnemModel>? nitnemList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNitnems();
  }

  getNitnems() async {
    nitnemList = await Reader.getNitnems();
    setState(() {

    });
  }


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
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: whiteColor,
            ),
            bottom: TabBar(
              indicatorColor: whiteColor,
              labelPadding: EdgeInsets.symmetric(horizontal: 30.w),
              isScrollable: true,
              tabs: [
                Tab(child: Text(("Punjabi"),style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16.sp,color: whiteColor))),
                Tab(child: Text(("English"),style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16.sp,color: whiteColor))),

              ],
            ),

          ),
          body: TabBarView(
              children: [
                ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: nitnemList?.length ?? 0,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context,index){
                      return Container(
                        padding: EdgeInsets.only(bottom: 8.h,left: 16.w,right: 16.w),
                        decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1.w,
                                  color: extraLightGreyColor
                              )
                          ),
                        ),
                        child: CustomInkWell(
                          onTap: () async {
                            // print(nitnemList?[index].id);
                            Helper.toScreen(context, HomeScreen(isNitnem: true, nitnemId: (nitnemList?[index].id) ?? 1,));
                          },
                          child: Container(
                            height: 50.h,
                            padding: EdgeInsets.only(top: 5.h),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 2.w,top: 5.h,bottom: 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          //title
                                          CustomText(
                                            title: asciiToGurmukhi(nitnemList?[index].gurmukhi ?? ""),
                                            fontSize: 18.sp,
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
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: nitnemList?.length ?? 0,
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context,index){
                      return Container(
                        padding: EdgeInsets.only(bottom: 8.h,left: 16.w,right: 16.w),
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
                            Helper.toScreen(context, HomeScreen(isNitnem: true, nitnemId: (nitnemList?[index].id) ?? 1,));
                          },
                          child: Container(
                            height: 50.h,
                            padding: EdgeInsets.only(top: 5.h),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 2.w,top: 5.h,bottom: 0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          //title
                                          CustomText(
                                            title: nitnemList?[index].english ?? "",
                                            fontSize: 18.sp,
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