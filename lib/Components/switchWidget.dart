

// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:popup_banner/popup_banner.dart';

SwitchWiget({theme,context,text,switchVal,onChanged,img,showCheckBox = true,bgClr = false,GestureTapCallback? onTap}){
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          image: bgClr==false? DecorationImage(
              image: AssetImage("assets/buttonBg.png"),
              fit: BoxFit.fill
          ):null,
        color: bgClr==true? DynamicColor.secondaryClr:Colors.transparent
      ),
      child: Row(
        children: [
          Image(image: AssetImage(img??"assets/musicIcon.png")
          ),
          SizedBox(
            width: 10,
          ),
          Text(text??"Link your iTunes account",
            style: poppinsRegularStyle(
                fontSize: 16,
                color: theme.primaryColor,
                context: context
            ),
          ),
          Spacer(),
          showCheckBox == false?SizedBox.shrink(): SizedBox(
            height: 30,
            child: Switch(
              inactiveThumbColor: DynamicColor.blackClr,
              activeColor: DynamicColor.blackClr,
              inactiveTrackColor: DynamicColor.whiteClr,
              activeTrackColor: DynamicColor.whiteClr,
              value: switchVal,onChanged: onChanged, /*onChanged: (v){
                iTuneVal.value = v;
              }*/),
          )
        ],
      ),
    ),
  );
}

eventDateTime({theme,context,text,img,bool icon =false,Color? iconClr,Color? iconBgClr,double? iconSize, Color? textClr,
IconData? Iconss,
  double? widths,
}) {
  return Padding( padding: EdgeInsets.symmetric(horizontal: 12.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor:iconBgClr?? theme.primaryColor,
          child:icon==false? ImageIcon(AssetImage(img??"assets/clock2.png"),
            color:iconClr?? DynamicColor.grayClr,
            size: iconSize?? 21,
          ):Icon(Iconss??Icons.location_on_sharp,
            color:iconClr?? DynamicColor.grayClr,
            size:iconSize?? 21,
          ),
        ),
        SizedBox(
          width:widths?? Get.width/1.2,
          child: Padding(
            padding: EdgeInsets.only(left: 6.0),
            child: Text(text??"04:00pm to 10:00pm",
              style: poppinsRegularStyle(
                fontSize: 12,
                context: context,
                color:textClr?? theme.primaryColor,
              ),
            ),
          ),
        )
      ],
    ),
  );
}

eventsTitles({text}) {
  return Container(
    width: Get.width,
    padding: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
    color: DynamicColor.avatarBgClr.withOpacity(0.44),
    child: Text(text??"Contact Information",
      style: poppinsRegularStyle(
          fontSize: 16,
          color: DynamicColor.lightRedClr
      ),
    ),
  );
}

aboutEventCreator({String? image,String? followText, theme,context,title,text,double? horizontalPadding,organizerName,followBg,GestureTapCallback? onTap,
textClr,GestureTapCallback? rowOnTap,String roleType = "Event Organizer", IconData? icons,
authController
}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal:horizontalPadding?? 10.0),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: DynamicColor.darkGrayClr
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 12.0,left: 12,right: 12),
            child: Text(title??'About',
              style: poppinsMediumStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: DynamicColor.lightGrayClr.withOpacity(0.5),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(text??'90’s Century Western presented by Tonwsquare Media.\nGates will open at 10:30pm and music begin at night.\nParking lots open at 10:30pm.',
              style: poppinsRegularStyle(
                fontSize: 12,
                color: theme.primaryColor,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: rowOnTap,
            behavior: HitTestBehavior.opaque,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 12.0,bottom: 15),
                  child: Container(
                    height: 40,
                    width: 40,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: DynamicColor.blackClr,
                      shape:BoxShape.circle,
                      border: Border.all(color: DynamicColor.lightYellowClr),
                   image: DecorationImage(
                     image: image==null? AssetImage("assets/eventOrganizer.png"):NetworkImage(image.toString()) as ImageProvider,
                     fit: BoxFit.fill,
                   )
                    ),

                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: (){
                    // Get.toNamed(Routes.eventOrganizerScreen,
                    //     arguments: {
                    //       "eventOrganizerValue": 2,
                    //       'profileImg': "assets/eventOrganizer.png",
                    //       "manager": roleType
                    //     }
                    // );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 2.0,bottom: 30),
                    child: Text(organizerName??"Event Organizer",
                      style: poppinsRegularStyle(
                        fontSize: 14,
                        context: context,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: onTap,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                            ),
                            color:followBg
                        ),
                        child: Center(
                          child: Text(followText??"Follow",
                            style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color:textClr,
                            ),
                          ),
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


ourGuestWidget({String? networkImg,String? followText,double? followPadding = 0,theme,context,img,textTitle,venueOwner,GestureTapCallback? onTap,Color? bgClr,double? horizontalPadding,bool iconShow = false,double? verticalPadding,
 double? rowPadding,double?rowVerticalPadding,double? avatarPadding,Color? textClr,Color?followBgClr,IconData? icon,
  GestureTapCallback?followOnTap
}){
  return GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal:horizontalPadding?? 12.0,vertical:verticalPadding?? 12),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal:rowPadding?? 10,vertical:rowVerticalPadding?? 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color:bgClr?? DynamicColor.darkGrayClr
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(left:avatarPadding?? 0,top: avatarPadding??0,bottom: avatarPadding??0),
              child: Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: DynamicColor.blackClr,
                  shape:BoxShape.circle,
                  border: Border.all(color: DynamicColor.lightYellowClr),
                image: DecorationImage(
                  image:networkImg != null?NetworkImage(networkImg): AssetImage(img??"assets/profileImg.png") as ImageProvider,
                )
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0,top: avatarPadding??0,bottom:  avatarPadding??0),
              child: SizedBox(
                width: Get.width/2.2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(textTitle??'Be our guest events',
                      style: poppinsMediumStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: DynamicColor.grayClr,
                      ),
                    ),
                    Text(venueOwner??"Event Organizer",
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
            GestureDetector(
              onTap: followOnTap,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 80,
                  padding: EdgeInsets.all(followPadding!),
                  // padding: EdgeInsets.symmetric(horizontal: 20,vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                      ),
                      color:followBgClr?? DynamicColor.avatarBgClr
                  ),

                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(followText??"Follow",
                        style: poppinsRegularStyle(
                          fontSize: 14,
                          context: context,
                          color:textClr?? theme.primaryColor,
                        ),
                      ),
                    ),
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}


venueListData({theme,context,required List<String> list,GestureTapCallback? onTap,bool showViewAll = true}){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      showViewAll==false?SizedBox.shrink(): Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Venue Image',
              style: poppinsMediumStyle(
                fontSize: 16,
                context: context,
                color: theme.primaryColor,
              ),
            ),
            GestureDetector(
              onTap: onTap,
              child: Text('See more',
                style: poppinsMediumStyle(
                  underline: true,
                  fontSize: 16,
                  context: context,
                  color: theme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        height:showViewAll==false?0: 10,
      ),
      SizedBox(
        height: kToolbarHeight*2,
        child: Align(
          alignment: Alignment.centerLeft,
          child: ListView.builder(
              itemCount: list.length,
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context,index){
                return GestureDetector(
                  onTap: (){
                    PopupBanner(
                      context: context,
                      images: list,
                      fromNetwork: true,
                      useDots: false,
                      onClick: (index) {
                        debugPrint("CLICKED $index");
                      },
                    ).show();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Container(
                      height: kToolbarHeight*2,
                      width: Get.width/3,
                      decoration: BoxDecoration(
                          border: Border.all(color: DynamicColor.yellowClr),
                          borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(list[index]),
                          fit: BoxFit.fill,
                        )
                      ),
                    ),
                  ),
                );
              }),
        ),
      )
    ],
  );
}


///location widget
locationWidget({text,theme,context,Color? bgClr,double? verticalPadding}){
  return
    Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        width: Get.width/2.0,
        padding: EdgeInsets.symmetric(vertical:verticalPadding?? 4),
        decoration: BoxDecoration(
            color: bgClr??DynamicColor.darkGrayClr,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12)
            )
        ),
        child: Row(
          children: [
            ImageIcon(AssetImage("assets/location.png"),
              color: DynamicColor.grayClr,
            ),
            Text('Herkimer County Fairgrounds',style: poppinsRegularStyle(fontSize: 11,context: context,color: theme.primaryColor,
                fontWeight: FontWeight.w600),)
          ],
        ),
      ),
    );
}

///event date
eventDateWidget({theme,context,Color? bgClr,Color? textClr,date,day}){
  return Container(
    height: 38,
    width: 35,
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:bgClr?? DynamicColor.avatarBgClr.withOpacity(0.8),
        border: Border.all(color: theme.primaryColor,)
    ),
    child: Column(
      mainAxisAlignment:MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
                children: <InlineSpan>[
                  TextSpan(
                    text:date??'30',
                    style: poppinsRegularStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        context: context,
                        color: DynamicColor.redClr
                    ),
                  ),
                  TextSpan(
                    text: day??'jun',
                    style: poppinsRegularStyle(
                        fontSize: 9,
                        context: context,
                        color:textClr?? theme.primaryColor,
                    ),
                  ),
                ]
            )
        ),
        // Text("30",
        //   style: poppinsRegularStyle(
        //       fontSize: 9,
        //       fontWeight: FontWeight.w600,
        //       context: context,
        //       color: DynamicColor.redClr
        //   ),
        // ),
        // Text("jun",
        //   style: poppinsRegularStyle(
        //       fontSize: 9,
        //       context: context,
        //       color:textClr?? theme.primaryColor,
        //   ),
        // ),

      ],
    ),
  );
}


///my event card widget

myEventCardWidget({theme,context,btnText,bool showBtn = true,String? attendedPeople}){
  return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bluredImg.png'),
                fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.4), BlendMode.modulate,)
              ),
            ),
            // decoration: BoxDecoration(
            //   color: DynamicColor.blackClr.withOpacity(0.2),
            // ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/peopleAttend.png"),
                              fit: BoxFit.fill
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          )
                      ),
                      child: Center(
                        child: Text("10 Days Ago",
                          style: poppinsRegularStyle(
                            fontSize: 10,
                            color: theme.primaryColor,
                            context: context,
                          ),
                        ),
                      ),
                    ),
                    attendedPeople==null?SizedBox.shrink(): Container(
                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/eventDays.png"),
                              fit: BoxFit.fill
                          ),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomLeft: Radius.circular(8),
                          )
                      ),
                      child: Center(
                        child: Text("250 People Attended",
                          style: poppinsRegularStyle(
                            fontSize: 10,
                            color: theme.primaryColor,
                            context: context,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: kToolbarHeight,
                ),
                Text("90’s Grunge and Bowling",
                  style: poppinsMediumStyle(
                    fontSize: 20,
                    color: theme.primaryColor,
                    context: context,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text("The Burning Cactus",
                  style: poppinsMediumStyle(
                    fontSize: 16,
                    color: DynamicColor.grayClr,
                    context: context,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    locationWidget(theme: theme,context: context),
                    Align(
                      alignment: Alignment.topRight,
                      child: eventDateWidget(theme: theme,context: context),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                showBtn==true? CustomButton(
                  borderClr: DynamicColor.lightBlackClr,
                  bgImage: 'assets/grayClor.png',
                  text:btnText?? "View",
                  onTap: (){
                    Get.back();
                  },
                ):SizedBox.shrink()
              ],
            ),
          );
}



/// Venue Detail have service Widget
venueService({theme,context,image,text,Color?bgColor,double? horizontalPadding,double? fontSize,
  bool icon= false,Color? iconClr,double?radius, double? iconPadding}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 6,horizontal:horizontalPadding?? 12),
    child: Row(
      children: [
        CircleAvatar(
            radius:radius?? 15,
            backgroundColor:bgColor?? DynamicColor.avatarBgClr.withOpacity(0.8),
            child:icon==false? ImageIcon(
              AssetImage(image??"assets/djing.png"),
              size: 20,
              color: iconClr,
            ):Padding(
              padding: EdgeInsets.all(iconPadding??0.0),
              child: Image(
                image: AssetImage(image??"assets/lockIcon.png"),
              ),
            )
        ),
        SizedBox(
          width: 5,
        ),
        SizedBox(
          width: Get.width/1.2,
          child: Text(text??"DJing",
            style: poppinsMediumStyle(
              fontSize:fontSize?? 14,
              context: context,
              color: theme.primaryColor,
            ),
          ),
        ),
      ],
    ),
  );
}

