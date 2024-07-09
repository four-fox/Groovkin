


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/switchWidget.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class VenueInfoScreen extends StatelessWidget {
  const VenueInfoScreen({Key? key}) : super(key: key);

  // Get.toNamed(Routes.eventPreview,
  //   arguments: {
  //     "viewDetails": 1
  //   }
  // );

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight*2),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/grayClor.png"),
                fit: BoxFit.fill
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: (){
                    Get.back();
                  },
                  child: ImageIcon(AssetImage("assets/backArrow.png"),
                  color: theme.primaryColor,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: DynamicColor.secondaryClr,
                      child: CircleAvatar(
                        radius: 26,
                        backgroundImage: AssetImage("assets/profileImg.png"),
                      ),
                    ),
                    SizedBox(
                      width: Get.width/1.3,
                      child: Padding(padding: EdgeInsets.only(left: 7),
                      child: Text("Herkimer County Fairgrounds Event Place",
                        maxLines: 2,
                        style: poppinsRegularStyle(
                          fontSize: 15,
                          context: context,
                          color: theme.primaryColor,
                        ),
                      ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
            eventDateTime(theme: theme,context: context,
              iconBgClr: DynamicColor.grayClr.withOpacity(0.3),
            ),
            SizedBox(
              height: 10,
            ),
            eventDateTime(theme: theme,context: context,
              iconBgClr: DynamicColor.grayClr.withOpacity(0.3),
                img: "assets/groupIcon.png",
              text: "400-450"
            ),
            SizedBox(
              height: 10,
            ),
            eventDateTime(theme: theme,context: context,
                iconBgClr: DynamicColor.grayClr.withOpacity(0.3),
                icon: true,
                Iconss: Icons.location_on_sharp,
                text: "135 Cemetery St, Frankfort, NY 13340, USA"
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
            Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: SizedBox(
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
            eventDateTime(theme: theme,context: context,
                iconBgClr: DynamicColor.grayClr.withOpacity(0.3),
                img: "assets/groupIcon.png",
                text: "400-450"
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
            SizedBox(
              height: 10,
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
                          child: Text('Cabaret Licenses',
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
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
        child: CustomButton(
          borderClr: Colors.transparent,
          onTap: (){
            Get.toNamed(Routes.eventPreview,
                arguments: {
                  "viewDetails": 1
                }
            );
          },
          text: "Continue",
        ),
      ),
    );
  }
}
