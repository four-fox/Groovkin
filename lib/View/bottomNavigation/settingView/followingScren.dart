


// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';

class FollowingScreen extends StatelessWidget {
  FollowingScreen({Key? key}) : super(key: key);

  RxInt selectedVal = 0.obs;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight*2.3),
          child: Column(
              children: [
                Container(
                  height: kToolbarHeight*1.5,
                  padding: EdgeInsets.only(top: 30,left: 10),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/grayClor.png"),
                        fit: BoxFit.fill
                    )
                  ),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Center(
                        child: Text("Following",style: poppinsMediumStyle(
                          fontSize: 17,
                          color: theme.primaryColor,
                        ),),
                      ),
                      GestureDetector(
                        onTap: (){
                          Get.back();
                        },
                        child: ImageIcon(AssetImage("assets/backArrow.png"),
                          color: theme.primaryColor,
                        ),
                      )
                    ],
                  ),
                ),
                // customAppBar(theme: theme,text: "Following"),
                SizedBox(
                  height: 8,
                ),
                TabBar(
                  unselectedLabelStyle: poppinsMediumStyle(
                      fontSize: 14,
                      context: context
                  ),
                  labelStyle: poppinsMediumStyle(
                      fontSize: 14,
                      context: context
                  ),
                  labelPadding: EdgeInsets.all(6),
                  indicatorPadding: EdgeInsets.all(10),
                  indicatorColor: Colors.transparent,
                  onTap: (v){
                    selectedVal.value = v;
                  },
                  tabs: [
                    Tab(child: Obx(
                      ()=> Container(
                        height: 35,
                        // padding: EdgeInsets.symmetric(horizontal: 8,vertical: 10),
                        decoration: BoxDecoration(
                          color:selectedVal.value==0? DynamicColor.yellowClr:DynamicColor.darkGrayClr,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text("User",
                            style: poppinsRegularStyle(
                                fontSize: 12,
                                context: context,
                                color:
                                selectedVal.value==0?theme.primaryColor:DynamicColor.whiteClr.withOpacity(0.3)
                            ),
                          ),
                        ),
                      ),
                    ),),
                    Tab(child:     Obx(
                          ()=> Container(
                            height: 35,
                        // padding: EdgeInsets.symmetric(horizontal: 8,vertical: 10),
                        decoration: BoxDecoration(
                          color:selectedVal.value==1? DynamicColor.yellowClr:DynamicColor.darkGrayClr,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text("Event Organizer",
                            style: poppinsRegularStyle(
                                fontSize: 12,
                                context: context,
                                color:
                                selectedVal.value==1?theme.primaryColor:DynamicColor.whiteClr.withOpacity(0.3)
                            ),
                          ),
                        ),
                      ),
                    ),),
                    Tab(child: Obx(
                          ()=> Container(
                            height: 35,
                        padding: EdgeInsets.symmetric(horizontal: 8,vertical: 10),
                        decoration: BoxDecoration(
                          color: selectedVal.value==2? DynamicColor.yellowClr:DynamicColor.darkGrayClr,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text("Event Manager",
                            style: poppinsRegularStyle(
                                fontSize: 12,
                                context: context,
                                color:
                                selectedVal.value==2?theme.primaryColor:DynamicColor.whiteClr.withOpacity(0.3)
                            ),
                          ),
                        ),
                      ),
                    ),),
                  ],
                ),
              ]),

        ),
        body: TabBarView(
          children: [
            AllUsers(userValue: "User",),
            AllUsers(userValue: "Event Organizer",),
            AllUsers(userValue: "Event Organizer",),
          ],
        ),
      ),
    );
  }
}


class AllUsers extends StatelessWidget {
  AllUsers({Key? key,this.userValue}) : super(key: key);
  List list =[false.obs,false.obs,false.obs,false.obs,false.obs,false.obs,false.obs,false.obs,];

  String? userValue;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SizedBox(
      height: Get.height/1.25,
      child: ListView.builder(
          itemCount: list.length,
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context,index){
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 12),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: DynamicColor.darkGrayClr
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 12.0,bottom: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: DynamicColor.blackClr,
                          shape:BoxShape.circle,
                          border: Border.all(color: DynamicColor.lightYellowClr),
                        ),
                        child: Image(
                          image: AssetImage("assets/profileImg.png"),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0,top: 10,bottom: 3),
                      child: SizedBox(
                        width: Get.width/2.3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('I believe "Be our guest events',
                              style: poppinsMediumStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: DynamicColor.grayClr,
                              ),
                            ),
                            Text(userValue!,
                              style: poppinsRegularStyle(
                                fontSize: 14,
                                context: context,
                                color: theme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacer(),
                    Obx(
                          ()=> Align(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: (){
                            list[index].value = !list[index].value;
                          },
                          child: Container(
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                ),
                                color:list[index].value ==true?DynamicColor.grayClr.withOpacity(0.3): DynamicColor.grayClr
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.check,
                                  size: 25,
                                  color:list[index].value ==true?theme.primaryColor: theme.scaffoldBackgroundColor,
                                ),
                                Text(list[index].value ==true?"Following":"Follow",
                                  style: poppinsRegularStyle(
                                    fontSize: 14,
                                    context: context,
                                    color:list[index].value ==true?theme.primaryColor: theme.scaffoldBackgroundColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
