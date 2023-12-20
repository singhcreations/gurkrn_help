import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gurbani_app/UI/ak.dart';
import 'package:gurbani_app/models/custom_model.dart';
import 'package:gurbani_app/screens/GSSG.dart';
import 'package:gurbani_app/screens/home_screen.dart';
import 'package:gurbani_app/screens/nitnem.dart';
import 'package:gurbani_app/widgets/constraints.dart';
import 'package:gurbani_app/widgets/custom_partent.dart';
import 'package:gurbani_app/widgets/custom_text.dart';
import 'package:gurbani_app/widgets/helper.dart';

class Listitems extends StatefulWidget {
  const Listitems({Key? key}) : super(key: key);

  @override
  _ListitemsState createState() => _ListitemsState();
}

class _ListitemsState extends State<Listitems> {
  GlobalKey<ScaffoldState>? mainDrawerKey =  GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // CommonThings.size = MediaQuery.of(context).size;
    return CustomParentWidget(
      // drawerWidget: MyDrawer(),
      // mainDrawerKey: mainDrawerKey,
        appBarWidget: AppBar(
          backgroundColor:  Colors.orange,
          leading: IconButton(
              onPressed: (){
                mainDrawerKey!.currentState!.openDrawer();
              },
              icon: const Icon(Icons.menu_sharp,
                color: whiteColor,)),
          title: CustomText(
            title: "Gurbani",
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          actions: [
            IconButton(
                onPressed: (){},
                icon: Icon(Icons.search,color: Colors.white,)),
            IconButton(
                onPressed: (){},
                icon: Icon(Icons.apps_outlined,color: Colors.white,))
          ],
        ),
        bodyWidget: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 8.h),
            itemCount: amritvelaWakeUpCallScreenList.length,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context,index){
              return Container(
                padding: EdgeInsets.only(bottom: 8.h,),
                child: InkWell(
                  onTap: () {
                    // print(index);
                    if (index == 0) {
                      Helper.toScreen(context, const NitnemScreen());
                      // Daily Updates
                    } else if (index == 1) {
                      Helper.toScreen(context, const HomeScreen(bookNo: 1,));
                      // Nitnem
                    }
                    else if (index == 2) {
                      Helper.toScreen(context, const HomeScreen(bookNo: 2,));
                      //GSSSG
                    }

                    else if(index==3){
                      Helper.toScreen(context, const SucessScreen());
                      //Sangrand
                    }

                  },
                  child: Card(
                    elevation: 3,
                    margin: EdgeInsets.zero,
                    child: Container(
                      height: 110.h,
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Row(
                        children: [
                          Container(
                            width: 75.w,
                            height: 75.w,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage("assets/images/dailyUpdates.jpg"))
                            ),
                          ),
                          Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 8.w,top: 8.w,bottom: 8.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //title
                                    CustomText(
                                      title: amritvelaWakeUpCallScreenList[index].title,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600,
                                      color: blackColor,
                                    ) ,
                                    //Space
                                    SizedBox(height: 5.h,),
                                    //subtitle
                                    CustomText(
                                      title: amritvelaWakeUpCallScreenList[index].subTitle,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      fontSize: 15.sp,
                                      color: orangeColor,
                                    ) ,
                                    //Space
                                    SizedBox(height: 3.h,),
                                    //Description
                                    CustomText(
                                      title: amritvelaWakeUpCallScreenList[index].description,
                                      fontSize: 13.sp,
                                      color: greyColor,
                                    ) ,
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              );
            })
    );
  }
}