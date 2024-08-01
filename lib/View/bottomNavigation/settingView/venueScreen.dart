


// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:map_location_picker/map_location_picker.dart';

class VenueScreen extends StatelessWidget {
  const VenueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight*3.3),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/grayClor.png"),
                      fit: BoxFit.fill
                  ),
                ),
                child: customAppBar(theme: theme,text: "Venue",imagee: true),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: Get.width/1.25,
                        child: SearchTextFields(
                          controller: TextEditingController(),
                          hintText: "Search Venue",
                        )),
                    GestureDetector(
                      onTap: (){
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border.all(color: DynamicColor.grayClr.withOpacity(0.6)),
                            borderRadius: BorderRadius.circular(8)
                        ),
                        child: ImageIcon(AssetImage("assets/filterIcons.png"),
                          color: DynamicColor.grayClr.withOpacity(0.6),),
                      ),
                    )
                  ],
                ),
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
                indicatorColor: theme.primaryColor,
                tabs: [
                  Tab(text: "Discover for you"),
                  Tab(text: "Organized Event",),
                ],
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DiscoverView(),
            DiscoverView(),
          ],
        ),
      ),
    );
  }
}


class DiscoverView extends StatelessWidget {
  DiscoverView({super.key});
  Prediction? initialValue;
  String address = "null";
  String autocompletePlace = "null";

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ListView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (BuildContext context,index){
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return
                  MapLocationPicker(
                    hideLocation: true,
                    // lat: double.parse(eventData.latitude.toString()),
                    // long: double.parse(eventData.longitude.toString()),
                    minMaxZoomPreference: MinMaxZoomPreference(0, 16),
                    apiKey:
                    "AIzaSyCPDZxZYp3Su6ReZTh4lHRoie6HAM2P0sU",
                    canPopOnNextButtonTaped: true,

                    onNext: (GeocodingResult? result) {
                    },
                  );

                //   MapLocationPicker(
                //   apiKey: "AIzaSyCPDZxZYp3Su6ReZTh4lHRoie6HAM2P0sU",
                //   popOnNextButtonTaped: true,
                //   currentLatLng: const LatLng(29.146727, 76.464895),
                //     stackWidget:stackWidgets(context,theme),
                //   btnOnTap: (){
                //     // Get.toNamed(Routes.hardwareProvidedScreen);
                //   },
                //   onNext: (GeocodingResult? result) {
                //     if (result != null) {
                //       address = result.formattedAddress ?? "";
                //     }
                //   },
                //   onSuggestionSelected: (PlacesDetailsResponse? result) {
                //     if (result != null) {
                //
                //       autocompletePlace =
                //           result.result.formattedAddress ?? "";
                //       // controller.update();
                //     }
                //   },
                // );
              },
            ),
          );
        },
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(list[index].img.toString()),
              ),
              // trailing:
              // Text(list[index].distance.toString(),
              //   style: poppinsRegularStyle(
              //     fontSize: 11,
              //     color: DynamicColor.lightRedClr,
              //   ),
              // ),
              trailing: SizedBox(
                width: 60,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Icon(Icons.location_on_sharp,
                      size: 12,
                        color: DynamicColor.lightRedClr,
                      ),
                      Text(list[index].distance.toString(),
                        style: poppinsRegularStyle(
                          fontSize: 11,
                          color: DynamicColor.lightRedClr,
                        ),),
                    ],
                  ),
                ),
              ),
              title: Text(list[index].title.toString(),
              style: poppinsRegularStyle(
                fontSize: 14,
                color: theme.primaryColor,
                context: context
              ),
              ),
              subtitle: Text(list[index].subtitle.toString(),
              style: poppinsRegularStyle(
                fontSize: 14,
                color: theme.primaryColor.withOpacity(0.5),
                  context: context
              ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Divider(
                color: DynamicColor.grayClr,
              ),
            )
          ],
        ),
      );
    });
  }
  List<Discover> list = [
    Discover(img: "assets/profileImg.png",title: "Herkimer County Fairgrounds",subtitle: "Event Place",distance: "1.5 miles"),
    Discover(img: "assets/profileImg.png",title: "Charles A. Gaetano Stadium",subtitle: "Event Place",distance: "1.5 miles"),
    Discover(img: "assets/profileImg.png",title: "Herkimer County Fairgrounds",subtitle: "Event Place",distance: "1.5 miles"),
    Discover(img: "assets/profileImg.png",title: "Charles A. Gaetano Stadium",subtitle: "Event Place",distance: "1.5 miles"),
    Discover(img: "assets/profileImg.png",title: "Herkimer County Fairgrounds",subtitle: "Event Place",distance: "1.5 miles"),
    Discover(img: "assets/profileImg.png",title: "Charles A. Gaetano Stadium",subtitle: "Event Place",distance: "1.5 miles"),
    Discover(img: "assets/profileImg.png",title: "Charles A. Gaetano Stadium",subtitle: "Event Place",distance: "1.5 miles"),
  ];

  Widget stackWidgets(context,theme){
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        Stack(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.arrow_back_outlined,
                size: 29,
                )),
            Align(
              alignment: Alignment.center,
              child: Text("Venue",
              style: poppinsMediumStyle(
                fontSize: 16,
                context: context,
                color: DynamicColor.blackClr,
                fontWeight: FontWeight.w600
              ),
              ),
            )
          ],
        ),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 8),
          child: Container(
              color: DynamicColor.blackClr,
              child: SearchTextFields(
                controller: TextEditingController(),
              )),
        ),
        Spacer(),
        Container(
          height: kToolbarHeight*2.5,
          color: theme.scaffoldBackgroundColor,
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/profileImg.png'),
                ),
                trailing: SizedBox(
                  width: 60,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      children: [
                        Icon(Icons.location_on_sharp,
                          size: 12,
                          color: DynamicColor.lightRedClr,
                        ),
                        Text('1.5 miles',
                          style: poppinsRegularStyle(
                            fontSize: 11,
                            color: DynamicColor.lightRedClr,
                          ),),
                      ],
                    ),
                  ),
                ),
                title: Text('Charles A. Gaetano Stadium',
                  style: poppinsRegularStyle(
                      fontSize: 14,
                      color: theme.primaryColor,
                      context: context
                  ),
                ),
                subtitle: Text('Event Place',
                  style: poppinsRegularStyle(
                      fontSize: 14,
                      color: theme.primaryColor.withOpacity(0.5),
                      context: context
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
                child: CustomButton(
                  borderClr: Colors.transparent,
                  color1: DynamicColor.blackClr,
                  color2: DynamicColor.blackClr,
                  onTap: (){
                    Get.toNamed(Routes.venueDetailsScreen);
                  },
                  text: "Next",
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }
}

class Discover{
  String? img,title,subtitle,distance;
  Discover({this.title,this.img,this.subtitle,this.distance});
}

