

// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/switchWidget.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/userHomeController.dart';

class UserMyGroovkinScreen extends StatelessWidget {
  const UserMyGroovkinScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme,text: "My Groovkin",backArrow: false),
      body: GetBuilder<UserHomeController>(
        builder: (controller) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 12,
                  ),
                  lifeStyleWidget(theme: theme,context: context,editShow: false,text: "Music Preference",
                  titleClr: DynamicColor.lightRedClr
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SwitchWiget(text: "iTunes Linked",theme: theme,context: context,showCheckBox: false,
                      bgClr: true),
                  SizedBox(height: 10,),
                  SwitchWiget(text: "Spotify Linked",img: "assets/spotifyIcon.png",theme: theme,
                      context: context,bgClr: true,showCheckBox: false,
                    onTap: (){
                      // Get.toNamed(Routes.groovkinPreferenceDetails,
                      //     arguments: {
                      //       "appBarTitle": "Spotify Linked",
                      //     }
                      // );
                    },
                  ),
                  SizedBox(
                    height: 22,
                  ),
                  musicGenreWidget(
                  text: "Lifestyle",
                    showImg: false,
                    onTap: (){
                      // Get.toNamed(Routes.groovkinPreferenceDetails,
                      //     arguments: {
                      //       "appBarTitle": "Lifestyle",
                      //     }
                      // );
                    },
                    theme: theme,context: context,icon:Icons.arrow_forward_ios,),
                  SizedBox(
                    height: 10,
                  ),
                  musicGenreWidget(
                    text: "Music Genre",
                    showImg: false,
                    theme: theme,context: context,icon:Icons.arrow_forward_ios,
                  onTap: (){
                      // Get.toNamed(Routes.groovkinPreferenceDetails,
                      // arguments: {
                      //   "appBarTitle": "Music Genre",
                      // }
                      // );
                  }
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(top: 4.0),
                  //   child: Visibility(
                  //     visible: controller.gaming.value,
                  //     child: Container(
                  //       padding: EdgeInsets.symmetric(horizontal: 15,vertical: 12),
                  //       decoration: BoxDecoration(
                  //         image: DecorationImage(
                  //             image: AssetImage("assets/buttonBg.png"),
                  //             fit: BoxFit.fill
                  //         ),
                  //         borderRadius: BorderRadius.circular(8),
                  //       ),
                  //       child: ListView.builder(
                  //           itemCount: 5,
                  //           shrinkWrap: true,
                  //           physics: AlwaysScrollableScrollPhysics(),
                  //           itemBuilder: (BuildContext context,index){
                  //             return Row(
                  //               children: [
                  //                 Text('Vinyl Turntables',
                  //                   style: poppinsRegularStyle(
                  //                       fontSize: 12,color:
                  //                   color: theme.primaryColor,
                  //                       context: context
                  //                   ),
                  //                 ),
                  //                 Spacer(),
                  //                 Theme(
                  //                   data: Theme.of(context).copyWith(
                  //                     unselectedWidgetColor: Colors.white,
                  //                   ),
                  //                   child: Checkbox(activeColor: DynamicColor.yellowClr,value: false, onChanged: (v){
                  //
                  //                   }),
                  //                 )
                  //               ],
                  //             );
                  //           }),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // lifeStyleWidget(theme: theme,penClr: DynamicColor.whiteClr,context: context,editBgClr: DynamicColor.yellowClr,editShow: false,text: "Linked Accounts",titleClr: DynamicColor.lightRedClr),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // SwitchWiget(text: "iTunes Linked",theme: theme,context: context,showCheckBox: false/*switchVal: controller.iTunes.value,*/
                  // // onChanged: (v){
                  // //   controller.iTunes.value = v;
                  // //   controller.update();
                  // // }
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // SwitchWiget(text: "Spotify Linked",img: "assets/spotifyIcon.png",theme: theme,context: context,switchVal: controller.spotifyVal.value,
                  // onChanged: (v){
                  //   controller.spotifyVal.value = v;
                  //   controller.update();
                  // }
                  // ),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // lifeStyleWidget(theme: theme,context: context,text: "Music Genre"),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // SizedBox(
                  //   height: kToolbarHeight/1.3,
                  //   child: ListView.builder(
                  //       shrinkWrap: true,
                  //       scrollDirection: Axis.horizontal,
                  //       itemBuilder: (BuildContext context,index){
                  //     return Padding(
                  //       padding: EdgeInsets.only(left: 8.0),
                  //       child: Container(
                  //         padding: EdgeInsets.symmetric(horizontal: 10,vertical: 6),
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(10),
                  //           image: DecorationImage(
                  //             fit: BoxFit.fill,
                  //             image: AssetImage("assets/grayClor.png")
                  //           )
                  //         ),
                  //         child: Center(
                  //           child: Text("#60’s Rock",
                  //           style: poppinsRegularStyle(
                  //             fontSize: 12,
                  //             context: context,
                  //             color: theme.primaryColor,
                  //           ),
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   }),
                  // )
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Widget lifeStyleWidget({theme,context,text,Color? titleClr,Color? editBgClr, bool? editShow = true,Color? penClr}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text??"Lifestyle",
          style: poppinsMediumStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              context: context,
              color:titleClr?? theme.primaryColor,
          ),
        ),
        editShow==false?SizedBox.shrink():  Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color:editBgClr?? theme.primaryColor,
          ),
          child: Icon(Icons.edit,
            color:penClr?? DynamicColor.yellowClr,
          ),
        )
      ],
    );
  }

  Widget musicGenreWidget({context,theme,text,GestureTapCallback? onTap,IconData? icon,String? img,showImg = true}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        decoration: BoxDecoration(
            // image: DecorationImage(
            //     image: AssetImage("assets/buttonBg.png"),
            //     fit: BoxFit.fill
            // ),
            color: DynamicColor.secondaryClr,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          children: [
            showImg== true? CircleAvatar(
                backgroundColor: theme.primaryColor,
                radius:15,child: Image(image: AssetImage(img??'assets/foodies.png'))):
            SizedBox.shrink(),
            SizedBox(
              width: 6,
            ),
            Text(text??'Sport Fan',
              style: poppinsMediumStyle(
                fontSize: 16,
                context: context,
                color: theme.primaryColor,
              ),
            ),
            Spacer(),
            Icon(icon,
              size: 20,
              color: theme.primaryColor,
            )
          ],
        ),
      ),
    );
  }
}


class GroovkinPreferenceDetails extends StatelessWidget {
  GroovkinPreferenceDetails({Key? key}) : super(key: key);

  String title = Get.arguments['appBarTitle'];

  RxBool foodies = true.obs;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar:
      AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/grayClor.png"),
                fit: BoxFit.fill
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Text(title.toString(),
          style:poppinsMediumStyle(
            fontSize: 17,
            color: theme.primaryColor,
          ),),
      actions: [
        GestureDetector(
          onTap: (){
            if(title == "Lifestyle" || title=="Spotify Linked"){
              Get.toNamed(Routes.surveyLifeStyleScreen,
              arguments: {
                "update": true,
                "appBarTitle": title
              }
              );
            }else{
              Get.toNamed(Routes.quickSurveyScreen,
                  arguments: {
                    "addMoreService": 2,
                    "title": "Edit Music Genre"
                  }
              );
            }
          },
          child: Row(
            children: [
              Icon(Icons.edit,
                size: 17,
                color: DynamicColor.secondaryClr,
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Text("Edit",
                    style:poppinsMediumStyle(
                      fontSize: 17,
                      color: theme.primaryColor,
                    ),),)
            ],
          ),
        )
      ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            musicGenreWidget(
              onTap: (){
                foodies.value = !foodies.value;
              },
              theme: theme,context: context,icon: foodies.value?Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,),
            SizedBox(
              height: 3,
            ),
            Obx(
              ()=> Visibility(
                visible: foodies.value,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15,),
                  decoration: BoxDecoration(
                    // image: DecorationImage(
                    //     image: AssetImage("assets/buttonBg.png"),
                    //     fit: BoxFit.fill
                    // ),
                    color: DynamicColor.dropDownClr,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context,index){
                        return Column(
                          children: [
                            Row(
                              children: [
                                Text('Vinyl Turntables',
                                  style: poppinsRegularStyle(
                                      fontSize: 12,color:
                                  theme.primaryColor,
                                      context: context
                                  ),
                                ),
                                Spacer(),
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    unselectedWidgetColor: Colors.white,
                                  ),
                                  child: Checkbox(activeColor: DynamicColor.yellowClr,value: false, onChanged: (v){

                                  }),
                                )
                              ],
                            ),
                            Divider(height: 1,),
                          ],
                        );
                      }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget musicGenreWidget({context,theme,text,GestureTapCallback? onTap,IconData? icon,String? img}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6,horizontal: 10),
      decoration: BoxDecoration(
        // image: DecorationImage(
        //     image: AssetImage("assets/buttonBg.png"),
        //     fit: BoxFit.fill
        // ),
          color: DynamicColor.secondaryClr,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [
          CircleAvatar(
              backgroundColor: theme.primaryColor,
              radius:15,child: Image(image: AssetImage(img??'assets/foodies.png'))),
          SizedBox(
            width: 6,
          ),
          Text(text??'Hip Hop',
            style: poppinsMediumStyle(
              fontSize: 16,
              context: context,
              color:  theme.primaryColor,
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: onTap,
            child: Icon(icon,
              size: 35,
              color: theme.primaryColor,
            ),
          )
        ],
      ),
    );
  }
}

