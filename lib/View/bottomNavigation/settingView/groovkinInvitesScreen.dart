


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class GroovkinInviteScreen extends StatefulWidget {
  GroovkinInviteScreen({Key? key}) : super(key: key);

  @override
  State<GroovkinInviteScreen> createState() => _GroovkinInviteScreenState();
}

class _GroovkinInviteScreenState extends State<GroovkinInviteScreen> {
  List<UserClass> list = [];

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    list.add(UserClass(emailController: TextEditingController(),selectedVal: false.obs));
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {

    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme,text: "Groovkin Invites"),
      body:Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
               ListView.builder(
                 itemCount: list.length,
                   shrinkWrap: true,
                   physics: NeverScrollableScrollPhysics(),
                   itemBuilder: (BuildContext context,index){
                 return Padding(
                   padding: const EdgeInsets.only(top: 10.0),
                   child: CustomTextFields(
                     suffixWidget: GestureDetector(
                       onTap: (){
                         if(list[index].selectedVal!.value == true){
                           list.remove(list[index]);
                           setState(() {
                           });
                         }
                       },
                       child: Icon(Icons.delete_forever,
                         color: DynamicColor.grayClr,
                       ),
                     ),
                     iconShow: list[index].selectedVal!.value ==false?false: true,
                     labelText: "email",
                   ),
                 );
               }),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        borderClr: Colors.transparent,
                        color1: DynamicColor.blackClr,
                        color2: DynamicColor.blackClr,
                        widths: Get.width/2.3,
                        onTap: (){
                          Get.toNamed(Routes.sendInvitationScreen);
                        },
                        text:/*sp.read("role") == "eventOrganizer"? "Groovkin Venue Manager":*/"Send",
                      ),
                      CustomButton(
                        borderClr: Colors.transparent,
                        backgroundClr: false,
                        color1: DynamicColor.lightWhite,
                        color2: DynamicColor.lightWhite,
                        textClr: theme.scaffoldBackgroundColor,

                        widths: Get.width/2.3,
                        onTap: (){

                          list.add(UserClass(emailController: TextEditingController(),selectedVal: true.obs));
                          setState(() {
                          });
                          // if(sp.read("role") !="User"){
                          //   Get.toNamed(Routes.groovkinManagerScreen);
                          // }else{
                          //   Get.toNamed(Routes.sendInvitationScreen);
                          //   // Get.back();
                          // }
                        },
                        text:"Add",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
          // list.isEmpty?SizedBox(
          //   height: double.infinity,
          //   width: double.infinity,
          //   child: Image(image: AssetImage("assets/inviteGroovkin.png"),),
          // ):
          // ListView.builder(
          //     itemCount: list.length,
          //     shrinkWrap: true,
          //     physics: AlwaysScrollableScrollPhysics(),
          //     itemBuilder: (BuildContext context,index){
          //       return Obx(
          //         ()=> Padding(
          //           padding: EdgeInsets.symmetric(vertical: 4.0),
          //           child: Row(
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Container(
          //                 height:35,
          //                 // width:width?? 100,
          //                 padding: EdgeInsets.symmetric(horizontal: 8,vertical: 6),
          //                 decoration: BoxDecoration(
          //                   color:DynamicColor.lightBlackClr.withOpacity(0.8),
          //                   borderRadius: BorderRadius.circular(8),
          //                 ),
          //                 child:Row(
          //                   crossAxisAlignment: CrossAxisAlignment.center,
          //                   children: [
          //                     Text(list[index].name!,
          //                       style: poppinsRegularStyle(
          //                           fontSize: 12,
          //                           context: context,
          //                           color:DynamicColor.whiteClr
          //                       ),
          //                     ),
          //                     SizedBox(
          //                       width: list[index].selectedVal!.value !=true?0:10,
          //                     ),
          //                     list[index].selectedVal!.value !=true?SizedBox.shrink():  GestureDetector(
          //                       onTap: (){
          //                         list[index].selectedVal!.value = !list[index].selectedVal!.value;
          //                       },
          //                       child: CircleAvatar(
          //                         radius: 8,
          //                         backgroundColor: DynamicColor.lightWhite,
          //                         child: Icon(Icons.clear,
          //                           size: 10,
          //                         ),
          //                       ),
          //                     )
          //                   ],
          //                 ),
          //               ),
          //               list[index].selectedVal!.value==true?SizedBox.shrink(): GestureDetector(
          //                 onTap: (){
          //                   list[index].selectedVal!.value = !list[index].selectedVal!.value;
          //                 },
          //                 child: Container(
          //                   height:30,
          //                   // width:width?? 100,
          //                   padding: EdgeInsets.symmetric(horizontal: 6,vertical: 3),
          //                   decoration: BoxDecoration(
          //                     color:DynamicColor.lightBlackClr.withOpacity(0.8),
          //                     borderRadius: BorderRadius.circular(8),
          //                   ),
          //                   child:Row(
          //                     crossAxisAlignment: CrossAxisAlignment.center,
          //                     children: [
          //                       Icon(Icons.add,
          //                         size: 18,
          //                         color: theme.primaryColor,,
          //                       ),
          //                       SizedBox(
          //                         width: 2,
          //                       ),
          //                       Text("Add",
          //                         style: poppinsRegularStyle(
          //                             fontSize: 12,
          //                             context: context,
          //                             color:DynamicColor.whiteClr
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //
          //             ],
          //           ),
          //         ),
          //       );
          //     }),
        ),
      ),
    );
  }
}

class UserClass {
  String? name;
  RxBool? selectedVal = false.obs;
  TextEditingController emailController = TextEditingController();
  UserClass({this.name,this.selectedVal,required this.emailController});
}
