


// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class VenueDetailsScreen extends StatelessWidget {
  const VenueDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme,text: "Venue Detail"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
                child: Text("About Herkimer County Fairgrounds",
                style: poppinsRegularStyle(
                  fontSize: 12,
                  color: DynamicColor.lightRedClr,
                  context: context,
                ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
    Container(
    color: DynamicColor.darkGrayClr.withOpacity(0.7),
    width: double.infinity,     padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 8),
              child: Text("Contact Information",
                style: poppinsRegularStyle(
                  fontSize: 16,
                  color: DynamicColor.lightRedClr,
                  context: context,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding( padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: DynamicColor.grayClr.withOpacity(0.3),
                    child: ImageIcon(AssetImage("assets/clock2.png"),
                      color: DynamicColor.grayClr,
                      size: 21,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 6.0),
                    child: Text("04:00pm to 10:00pm",
                    style: poppinsRegularStyle(
                      fontSize: 12,
                      context: context,
color: theme.primaryColor,
                    ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(       padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: DynamicColor.grayClr.withOpacity(0.3),
                    child: ImageIcon(AssetImage("assets/groupIcon.png"),
                      color: DynamicColor.grayClr,
                      size: 21,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 6.0),
                    child: Text("400-450",
                    style: poppinsRegularStyle(
                      fontSize: 12,
                      context: context,
color: theme.primaryColor,
                    ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(       padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: DynamicColor.grayClr.withOpacity(0.3),
                    child: Icon(Icons.location_on_sharp,
                      color: DynamicColor.grayClr,
                      size: 21,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 6.0),
                    child: Text("135 Cemetery St, Frankfort, NY 13340, USA",
                    style: poppinsRegularStyle(
                      fontSize: 12,
                      context: context,
color: theme.primaryColor,
                    ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 10,
            ),
            Container(
              color: DynamicColor.darkGrayClr.withOpacity(0.7),
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
              child: Text("Venue Image",
                style: poppinsRegularStyle(
                  fontSize: 16,
                  color: DynamicColor.lightRedClr,
                  context: context,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: kToolbarHeight*1.7,
              child: ListView.builder(
                  itemCount: 15,
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context,index){
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.0),
                  child: Container(
                    height: kToolbarHeight*1.6,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: DynamicColor.yellowClr,width: 1),
                    image: DecorationImage(
                      image: AssetImage('assets/venueImg.png'),
                      fit: BoxFit.fill
                    )
                    ),
                  ),
                );
              }),
            ),
            SizedBox(
              height: 12,
            ),
            Padding(       padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: CustomButton(
                borderClr: Colors.transparent,
                color1: DynamicColor.blackClr,
                color2: DynamicColor.blackClr,
                onTap: (){
                  // Get.toNamed(Routes.venueDetailsScreen);
                },
                text: "Next",
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: DynamicColor.darkGrayClr.withOpacity(0.7),
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
              child: Text("Max Occupancy",
                style: poppinsRegularStyle(
                  fontSize: 16,
                  color: DynamicColor.lightRedClr,
                  context: context,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: DynamicColor.grayClr.withOpacity(0.3),
                    child: ImageIcon(AssetImage('assets/oppositArrow.png'),
                    color: DynamicColor.grayClr,
                    ),
                  ),
                  Padding(  padding: EdgeInsets.only(left: 6.0),
                    child: Text("600 Square Yard",
                      style: poppinsRegularStyle(
                        fontSize: 12,
                        context: context,
                        color: theme.primaryColor,
                      ),),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: DynamicColor.darkGrayClr.withOpacity(0.7),
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
              child: Text("Amenities",
                style: poppinsRegularStyle(
                  fontSize: 16,
                  color: DynamicColor.lightRedClr,
                  context: context,
                ),
              ),
            ),
            ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
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
              color: DynamicColor.darkGrayClr.withOpacity(0.7),
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
              child: Text("Active Licenses\\Permits",
                style: poppinsRegularStyle(
                  fontSize: 16,
                  color: DynamicColor.lightRedClr,
                  context: context,
                ),
              ),
            ),
            ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
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
              color: DynamicColor.darkGrayClr.withOpacity(0.7),
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
              child: Text("House Event Capabilities",
                style: poppinsRegularStyle(
                  fontSize: 16,
                  color: DynamicColor.lightRedClr,
                  context: context,
                ),
              ),
            ),
            ListView.builder(
                itemCount: 5,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
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
              height: 12,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: CustomButton(
                borderClr: Colors.transparent,
                color1: DynamicColor.blackClr,
                color2: DynamicColor.blackClr,
                onTap: (){
                  Get.toNamed(Routes.bookingFormScreen);
                },
                text: "Send Booking Request",
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
