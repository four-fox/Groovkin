// ignore_for_file: prefer_final_fields
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';
import 'package:groovkin/utils/responsive.dart';

class AddVenueDetailsScreen extends StatelessWidget {
  AddVenueDetailsScreen({super.key});

  ManagerController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight * 2),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/grayClor.png"),
                      fit: BoxFit.fill)),
              child: customAppBar(theme: theme, text: "Add Venue"),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Add Amenities!",
              style: poppinsMediumStyle(
                  fontSize: 18, color: theme.primaryColor, context: context),
            ),
            Text(
              'Please add property’s amenities.',
              style: poppinsRegularStyle(
                  fontSize: 12,
                  context: context,
                  color: DynamicColor.lightRedClr),
            ),
          ],
        ),
      ),
      body: GetBuilder<ManagerController>(initState: (v) {
        _controller.getAmenities(type: "amenities");
      }, builder: (controller) {
        return controller.getAmenitiesLoader.value == false
            ? SizedBox.shrink()
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 1, horizontal: 17),
                  child: LayoutGrid(
                    columnSizes: Responsive.isDesktop(context)
                        ? [1.fr, 1.fr, 1.fr, 1.fr, 1.fr]
                        : Responsive.isTablet(context)
                            ? [1.fr, 1.fr, 1.fr, 1.fr]
                            : Responsive.isMobileLarge(context)
                                ? [1.fr, 1.fr, 1.fr]
                                : Responsive.isMobile(context)
                                    ? [1.fr, 1.fr]
                                    : [1.fr], // Two columns
                    rowSizes: List.generate(10, (_) => auto),
                    children:
                        controller.amenitiesList.asMap().entries.map((datas) {
                      int index = datas.key;

                      return SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              controller.amenitiesList[index].selected!.value =
                                  !controller
                                      .amenitiesList[index].selected!.value;
                              if (controller
                                      .amenitiesList[index].selected!.value ==
                                  true) {
                                controller.selectedAmenities
                                    .add(controller.amenitiesList[index]);
                              } else {
                                controller.selectedAmenities
                                    .remove(controller.amenitiesList[index]);
                              }
                              controller.update();
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  color: controller.amenitiesList[index]
                                              .selected!.value !=
                                          false
                                      ? DynamicColor.grayClr
                                      : DynamicColor.yellowClr,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                // padding: EdgeInsets.all(4),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 45,
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: controller.amenitiesList[index]
                                                      .selected!.value ==
                                                  false
                                              ? DynamicColor.grayClr
                                              : DynamicColor.yellowClr),
                                      child: Image(
                                        image: AssetImage("assets/djing.png"),
                                      ),
                                    ),
                                    Text(
                                      controller.amenitiesList[index].name
                                          .toString(),
                                      style: poppinsRegularStyle(
                                        fontSize: 13,
                                        color: theme.primaryColor,
                                        context: context,
                                      ),
                                    )
                                  ],
                                )),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
        // GridView.custom(
        //   shrinkWrap: true,
        //   padding: EdgeInsets.symmetric(vertical: 1, horizontal: 17),
        //   // gridDelegate: SliverStairedGridDelegate(
        //   //   crossAxisSpacing: 6,
        //   //   mainAxisSpacing: 0.0,
        //   //   startCrossAxisDirectionReversed: true,
        //   //   pattern: [
        //   //     StairedGridTile(0.5, 7 / 3.3),
        //   //     StairedGridTile(0.5, 7 / 3.3),
        //   //   ],
        //   // ),
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: 2,
        //     childAspectRatio: 7 / 3.3,
        //   ),
        //   childrenDelegate: SliverChildBuilderDelegate(
        //     (context, index) {
        //       return Padding(
        //         padding: EdgeInsets.all(5.0),
        //         child: GestureDetector(
        //           onTap: () {
        //             controller.amenitiesList[index].selected!.value =
        //                 !controller.amenitiesList[index].selected!.value;
        //             if (controller.amenitiesList[index].selected!.value ==
        //                 true) {
        //               controller.selectedAmenities
        //                   .add(controller.amenitiesList[index]);
        //             } else {
        //               controller.selectedAmenities
        //                   .remove(controller.amenitiesList[index]);
        //             }
        //             controller.update();
        //           },
        //           child: Container(
        //               decoration: BoxDecoration(
        //                 color:
        //                     controller.amenitiesList[index].selected!.value !=
        //                             false
        //                         ? DynamicColor.grayClr
        //                         : DynamicColor.yellowClr,
        //                 borderRadius: BorderRadius.circular(12),
        //               ),
        //               // padding: EdgeInsets.all(4),
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Container(
        //                     height: 45,
        //                     width: 45,
        //                     padding: EdgeInsets.all(4),
        //                     decoration: BoxDecoration(
        //                         shape: BoxShape.circle,
        //                         color: controller.amenitiesList[index]
        //                                     .selected!.value ==
        //                                 false
        //                             ? DynamicColor.grayClr
        //                             : DynamicColor.yellowClr),
        //                     child: Image(
        //                       image: AssetImage("assets/djing.png"),
        //                     ),
        //                   ),
        //                   Text(
        //                     controller.amenitiesList[index].name.toString(),
        //                     style: poppinsRegularStyle(
        //                       fontSize: 13,
        //                       color: theme.primaryColor,
        //                       context: context,
        //                     ),
        //                   )
        //                 ],
        //               )),
        //         ),
        //       );
        //     },
        //     childCount: controller.amenitiesList.length,
        //   ),
        // );
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: CustomButton(
            borderClr: Colors.transparent,
            onTap: () {
              if (_controller.selectedAmenities.isNotEmpty) {
                Get.toNamed(Routes.venuePermitDetailScreen);
              } else {
                bottomToast(text: "Please Add Amenities");
              }
            },
            text: "Next",
          ),
        ),
      ),
    );
  }

}

class Amenities {
  String? text;
  RxBool? checkBoxVel = false.obs;
  Amenities({this.text, this.checkBoxVel});
}

///Add licenses and permit

class VenuePermitDetailScreen extends StatelessWidget {
  VenuePermitDetailScreen({super.key});

  ManagerController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight * 2),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/grayClor.png"),
                      fit: BoxFit.fill)),
              child: customAppBar(theme: theme, text: "Add Venue Detail"),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Licenses and permit!",
              style: poppinsMediumStyle(
                  fontSize: 18, color: theme.primaryColor, context: context),
            ),
            Text(
              'Please check out active licenses and permits.',
              style: poppinsRegularStyle(
                  fontSize: 12,
                  context: context,
                  color: DynamicColor.lightRedClr),
            ),
          ],
        ),
      ),
      body: GetBuilder<ManagerController>(initState: (v) {
        _controller.getAmenities(type: "licenses_and_permit");
      }, builder: (controller) {
        return controller.getAmenitiesLoader.value == false
            ? SizedBox.shrink()
            : ListView.builder(
                itemCount: controller.licensesPermitList.length,
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (BuildContext context, index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        controller.licensesPermitList[index].selected!.value =
                            !controller
                                .licensesPermitList[index].selected!.value;
                        if (controller
                                .licensesPermitList[index].selected!.value ==
                            true) {
                          controller.selectedLicensesPermit
                              .add(controller.licensesPermitList[index]);
                        } else {
                          controller.selectedLicensesPermit
                              .remove(controller.licensesPermitList[index]);
                        }
                        controller.update();
                      },
                      child: Container(
                          height: 40,
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: controller.licensesPermitList[index]
                                          .selected!.value ==
                                      false
                                  ? DecorationImage(
                                      image: AssetImage("assets/buttonBg.png"),
                                      fit: BoxFit.fill)
                                  : null,
                              color: controller.licensesPermitList[index]
                                          .selected!.value ==
                                      false
                                  ? Colors.transparent
                                  : DynamicColor.grayClr),
                          child: Row(
                            children: [
                              SizedBox(
                                width: Get.width / 1.3,
                                child: Text(
                                  controller.licensesPermitList[index].name
                                      .toString(),
                                  maxLines: 1,
                                  style: poppinsRegularStyle(
                                    fontSize: 13,
                                    color: theme.primaryColor,
                                    context: context,
                                  ),
                                ),
                              ),
                              Spacer(),
                              controller.licensesPermitList[index].selected!
                                          .value ==
                                      true
                                  ? Icon(
                                      Icons.check,
                                      size: 28,
                                      color: DynamicColor.blackClr,
                                    )
                                  : SizedBox.shrink(),
                            ],
                          )),
                    ),
                  );
                });
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: CustomButton(
            borderClr: Colors.transparent,
            onTap: () {
              if (_controller.selectedLicensesPermit.isNotEmpty) {
                Get.toNamed(Routes.houseEventCapabilitiesScreen);
              } else {
                bottomToast(text: "Please select licence and permit");
              }
            },
            text: "Next",
          ),
        ),
      ),
    );
  }
}

class HouseEventCapabilitiesScreen extends StatefulWidget {
  HouseEventCapabilitiesScreen({super.key});

  @override
  State<HouseEventCapabilitiesScreen> createState() =>
      _HouseEventCapabilitiesScreenState();
}

class _HouseEventCapabilitiesScreenState
    extends State<HouseEventCapabilitiesScreen> {
  ScrollController listScrollController = ScrollController();
  bool isAtMaxScroll = false;
  void scrollToMaxExtent() {
    listScrollController.animateTo(
      /*  reverced
          ? scrollController.position.minScrollExtent
          :*/
      listScrollController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.linear,
    );
  }

  @override
  void initState() {
    super.initState();
    listScrollController.addListener(() {
      if (listScrollController.position.pixels ==
          listScrollController.position.maxScrollExtent) {
        if (!isAtMaxScroll) {
          setState(() {
            isAtMaxScroll = true;
          });
        }
      } else {
        if (isAtMaxScroll) {
          setState(() {
            isAtMaxScroll = false;
          });
        }
      }
    });
  }

  ManagerController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight * 2),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/grayClor.png"),
                      fit: BoxFit.fill)),
              child: customAppBar(theme: theme, text: "Add Venue Detail"),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "House Event Capabilities!",
              style: poppinsMediumStyle(
                  fontSize: 18, color: theme.primaryColor, context: context),
            ),
            Text(
              'Please check out.',
              style: poppinsRegularStyle(
                  fontSize: 12,
                  context: context,
                  color: DynamicColor.lightRedClr),
            ),
          ],
        ),
      ),
      body: GetBuilder<ManagerController>(initState: (v) {
        _controller.getAmenities(type: "house_event_capabilities");
      }, builder: (controller) {
        return controller.getAmenitiesLoader.value == false
            ? SizedBox.shrink()
            : ListView.builder(
                itemCount: controller.houseEventPermitList.length,
                controller: listScrollController,
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (BuildContext context, index) {
                  return Obx(
                    () => Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          controller
                                  .houseEventPermitList[index].selected!.value =
                              !controller
                                  .houseEventPermitList[index].selected!.value;
                          if (controller.houseEventPermitList[index].selected!
                                  .value ==
                              true) {
                            controller.selectedHouseEventPermit
                                .add(controller.houseEventPermitList[index]);
                          } else {
                            controller.selectedHouseEventPermit
                                .remove(controller.houseEventPermitList[index]);
                          }
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: controller.houseEventPermitList[index]
                                            .selected!.value ==
                                        false
                                    ? DecorationImage(
                                        image:
                                            AssetImage("assets/buttonBg.png"),
                                        fit: BoxFit.fill)
                                    : null,
                                color: controller.houseEventPermitList[index]
                                            .selected!.value ==
                                        false
                                    ? Colors.transparent
                                    : DynamicColor.grayClr),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    controller.houseEventPermitList[index].name
                                        .toString(),
                                    maxLines: 1,
                                    style: poppinsRegularStyle(
                                      fontSize: 13,
                                      color: theme.primaryColor,
                                      context: context,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                controller.houseEventPermitList[index].selected!
                                            .value ==
                                        true
                                    ? Icon(
                                        Icons.check,
                                        size: 28,
                                        color: DynamicColor.blackClr,
                                      )
                                    : SizedBox.shrink(),
                              ],
                            )),
                      ),
                    ),
                  );
                });
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isAtMaxScroll
          ? null
          : GestureDetector(
              onTap: () {
                scrollToMaxExtent();
              },
              child: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.primaryColor,
                    ),
                    image: DecorationImage(
                        image: AssetImage('assets/eventDays.png'),
                        fit: BoxFit.fill)),
                child: Icon(
                  Icons.keyboard_double_arrow_down,
                  color: theme.primaryColor,
                  size: 25,
                ),
              ),
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: CustomButton(
            borderClr: Colors.transparent,
            onTap: () {
              if (_controller.selectedHouseEventPermit.isNotEmpty) {
                Get.toNamed(Routes.venueDetailsManagerScreen);
              } else {
                bottomToast(text: "Please add house event capabilities");
              }
            },
            text: "Next",
          ),
        ),
      ),
    );
  }

  List<Amenities> list = [
    Amenities(
        text: "DJ Booth with House Audio controlsNo Turntables",
        checkBoxVel: false.obs),
    Amenities(
        text: "DJ Booth with House Audio controlsWith CD Turntables",
        checkBoxVel: false.obs),
    Amenities(
        text: "DJ Booth with House Audio controlsWith Vinyl Turntables",
        checkBoxVel: false.obs),
    Amenities(text: "Live Entertainment License", checkBoxVel: false.obs),
    Amenities(
        text: "DJ Booth with House Audio controlsWith DJ Controller",
        checkBoxVel: false.obs),
    Amenities(text: "House Sound System", checkBoxVel: false.obs),
    Amenities(text: "Valet Parking Permit", checkBoxVel: false.obs),
    Amenities(text: "Event Room(s)", checkBoxVel: false.obs),
    Amenities(text: "No Dining", checkBoxVel: false.obs),
    Amenities(text: "Bar Only", checkBoxVel: false.obs),
    Amenities(text: "Full Bar", checkBoxVel: false.obs),
    Amenities(text: "Beer and Wine Bar", checkBoxVel: false.obs),
    Amenities(text: "Inside Dining", checkBoxVel: false.obs),
    Amenities(text: "Outside Dining", checkBoxVel: false.obs),
    Amenities(text: "House DJ Booth", checkBoxVel: false.obs),
    Amenities(text: "Event Room(s)", checkBoxVel: false.obs),
    Amenities(text: "No Dining", checkBoxVel: false.obs),
    Amenities(text: "Bar Only", checkBoxVel: false.obs),
  ];
}
