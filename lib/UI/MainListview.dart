import 'package:flutter/material.dart';
import 'package:gurbani_app/UI/ak.dart';
import 'package:gurbani_app/models/custom_model.dart';
import 'package:gurbani_app/screens/GSSG.dart';
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
            fontSize: 18,
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
            padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
            itemCount: amritvelaWakeUpCallScreenList.length,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context,index){
              return Container(
                padding: const EdgeInsets.only(bottom: 8,),
                child: InkWell(
                  onTap: () {
                    if (index == 0) {
                      Helper.toScreen(context, NitnemScreen());
                      // Daily Updates
                    } else if (index == 1) {
                      Helper.toScreen(context, NitnemScreen());
                      // Nitnem
                    }
                    else if (index == 2) {
                      Helper.toScreen(context, GSSGScreen());
                      //GSSSG
                    }

                    else if(index==4){
                      Helper.toScreen(context, SucessScreen());
                      //Sangrand
                    }

                  },
                  child: Card(
                    elevation: 3,
                    margin: EdgeInsets.zero,
                    child: Container(
                      height: 110,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 75,
                            height: 75,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage("assets/images/dailyUpdates.jpg"))
                            ),
                          ),
                          Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 8,top: 8,bottom: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //title
                                    CustomText(
                                      title: amritvelaWakeUpCallScreenList[index].title,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: blackColor,
                                    ) ,
                                    //Space
                                    SizedBox(height: 5,),
                                    //subtitle
                                    CustomText(
                                      title: amritvelaWakeUpCallScreenList[index].subTitle,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      fontSize: 15,
                                      color: orangeColor,
                                    ) ,
                                    //Space
                                    SizedBox(height: 3,),
                                    //Description
                                    CustomText(
                                      title: amritvelaWakeUpCallScreenList[index].description,
                                      fontSize: 13,
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