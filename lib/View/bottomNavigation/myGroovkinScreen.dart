


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class MyGroovkinScreen extends StatelessWidget {
  MyGroovkinScreen({Key? key,this.appBar}) : super(key: key);

  bool? appBar = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar:appBar==true?null: customAppBar(theme: theme,text: "My Groovkin",backArrow: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
SizedBox(
  height: 10,
),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12,horizontal: 18),
              color: DynamicColor.avatarBgClr.withOpacity(0.44),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Given Services",
                  style: poppinsRegularStyle(
                    fontSize: 16,
                    color: DynamicColor.lightRedClr
                  ),
                  ),
                  appBar==true?SizedBox.shrink(): GestureDetector(
                    onTap: (){
                      Get.toNamed(Routes.serviceScreen,
                        arguments: {
                          "addMoreService": 2
                        }
                      );
                    },
                    child: Icon(Icons.edit,
                        color: DynamicColor.yellowClr
                    ),
                  )
                ],
              ),
            ),
            serviceWidget(context: context,theme: theme),
            serviceWidget(context: context,theme: theme,text: "Lighting",image: "assets/lighting.png"),
            serviceWidget(context: context,theme: theme,text: "Photobooth",image: "assets/lighting.png"),
            serviceWidget(context: context,theme: theme,text: "Master of Ceremony",image: "assets/master.png"),
            serviceWidget(context: context,theme: theme,text: "AV Equipment",image: "assets/avEquipment.png"),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12,horizontal: 18),
              color: DynamicColor.avatarBgClr.withOpacity(0.44),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Insurance",
                    style: poppinsRegularStyle(
                        fontSize: 16,
                        color: DynamicColor.lightRedClr
                    ),
                  ),
                  appBar==true?SizedBox.shrink():    GestureDetector(
                    onTap: (){
                      Get.toNamed(Routes.insuranceScreen,
                      arguments: {
                        "insuranceNavigation":2,
                      }
                      );
                    },
                    child: Icon(Icons.edit,
                        color: DynamicColor.yellowClr
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: serviceWidget(context: context,theme: theme,text: "Insurance can be provided",image: "assets/insurance.png"),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12,horizontal: 18),
              color: DynamicColor.avatarBgClr.withOpacity(0.44),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hardware",
                    style: poppinsRegularStyle(
                        fontSize: 16,
                        color: DynamicColor.lightRedClr
                    ),
                  ),
                  appBar==true?SizedBox.shrink():   GestureDetector(
                    onTap: (){
Get.toNamed(Routes.addMoreHardwareScreen);
                    },
                    child: Icon(Icons.edit,
                        color: DynamicColor.yellowClr
                    ),
                  )
                ],
              ),
            ),
            ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (BuildContext context,index){
                  return Padding(
                    padding: EdgeInsets.only(left: 12.0,top: 6),
                    child: Row(
                      children: [
                        Image(
                          image: AssetImage("assets/headingIcons.png"),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child: Text('Vinyl Turntables',
                            style: poppinsRegularStyle(
                                fontSize: 13,color:
                            theme.primaryColor,
                                context: context
                            ),
                          ),
                        ),
                      Icon(Icons.check,
                      color: DynamicColor.lightRedClr,
                        size: 17,
                      )
                      ],
                    ),
                  );
                }),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12,horizontal: 18),
              color: DynamicColor.avatarBgClr.withOpacity(0.44),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Music Genre",
                    style: poppinsRegularStyle(
                        fontSize: 16,
                        color: DynamicColor.lightRedClr
                    ),
                  ),
                  appBar==true?SizedBox.shrink(): GestureDetector(
                    onTap: (){
                      Get.toNamed(Routes.quickSurveyScreen,
                        arguments: {
                          "addMoreService": 2
                        }
                      );
                    },
                    child: Icon(Icons.edit,
                        color: DynamicColor.yellowClr
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Wrap(
                spacing:10,
                children: <Widget>[
                  musicGenre(theme: theme,context: context),
                  musicGenre(theme: theme,context: context),
                  musicGenre(theme: theme,context: context),
                  musicGenre(theme: theme,context: context),
                  musicGenre(theme: theme,context: context),
                  musicGenre(theme: theme,context: context),
                  musicGenre(theme: theme,context: context),
                  musicGenre(theme: theme,context: context),
                  musicGenre(theme: theme,context: context),
                  musicGenre(theme: theme,context: context),
                ]),
            SizedBox(
              height: kToolbarHeight*1.5,
            ),
          ],
        ),
      ),
    );
  }

  Widget serviceWidget({theme,image,context,onChanged,djValue,text}){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6,horizontal: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor: DynamicColor.avatarBgClr.withOpacity(0.8),
            child: ImageIcon(
              AssetImage(image??"assets/djing.png"),
              size: 20,
            )
          ),
          SizedBox(
            width: 5,
          ),
          Text(text??"DJing",
            style: poppinsMediumStyle(
              fontSize: 14,
              context: context,
              color: theme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  musicGenre({theme,context}){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.0,vertical: 6),
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: AssetImage('assets/venue1.png'),
                fit: BoxFit.fill,
                colorFilter: ColorFilter.mode(DynamicColor.grayClr.withOpacity(0.3), BlendMode.modulate,)
            )
        ),
        child: Center(
          child: Text("60's\nRock",
            textAlign: TextAlign.center,
            style: poppinsMediumStyle(
              fontSize: 14,
              color: theme.primaryColor,
              context: context,
            ),
          ),
        ),
      ),
    );
  }
}
