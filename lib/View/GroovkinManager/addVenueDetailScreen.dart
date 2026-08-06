// ignore_for_file: prefer_final_fields
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';

class AddVenueDetailsScreen extends StatelessWidget {
  AddVenueDetailsScreen({super.key});

  ManagerController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight * 2),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/grayClor.png"),
                      fit: BoxFit.fill)),
              child: customAppBar(theme: theme, text: "Add Venue"),
            ),
            const SizedBox(
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
            ? const SizedBox.shrink()
            // Compact list rows (same pattern as Licenses & Permits) so
            // tablet landscape shows more items instead of oversized tiles.
            : ListView.builder(
                itemCount: controller.amenitiesList.length,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (BuildContext context, index) {
                  final item = controller.amenitiesList[index];
                  final selected = item.selected!.value == true;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        item.selected!.value = !item.selected!.value;
                        if (item.selected!.value == true) {
                          controller.selectedAmenities.add(item);
                        } else {
                          controller.selectedAmenities.remove(item);
                        }
                        controller.update();
                      },
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: selected
                              ? null
                              : const DecorationImage(
                                  image: AssetImage("assets/buttonBg.png"),
                                  fit: BoxFit.fill,
                                ),
                          color: selected
                              ? DynamicColor.grayClr
                              : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.name.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: poppinsRegularStyle(
                                  fontSize: 13,
                                  color: theme.primaryColor,
                                  context: context,
                                ),
                              ),
                            ),
                            if (selected)
                              Icon(
                                Icons.check,
                                size: 28,
                                color: DynamicColor.blackClr,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
        preferredSize: const Size.fromHeight(kToolbarHeight * 2),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/grayClor.png"),
                      fit: BoxFit.fill)),
              child: customAppBar(theme: theme, text: "Add Venue Detail"),
            ),
            const SizedBox(
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
            ? const SizedBox.shrink()
            : ListView.builder(
                itemCount: controller.licensesPermitList.length,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (BuildContext context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: controller.licensesPermitList[index]
                                          .selected!.value ==
                                      false
                                  ? const DecorationImage(
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
                              const Spacer(),
                              controller.licensesPermitList[index].selected!
                                          .value ==
                                      true
                                  ? Icon(
                                      Icons.check,
                                      size: 28,
                                      color: DynamicColor.blackClr,
                                    )
                                  : const SizedBox.shrink(),
                            ],
                          )),
                    ),
                  );
                });
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
  const HouseEventCapabilitiesScreen({super.key});

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
      duration: const Duration(seconds: 1),
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
        preferredSize: const Size.fromHeight(kToolbarHeight * 2),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/grayClor.png"),
                      fit: BoxFit.fill)),
              child: customAppBar(theme: theme, text: "Add Venue Detail"),
            ),
            const SizedBox(
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
            ? const SizedBox.shrink()
            : ListView.builder(
                itemCount: controller.houseEventPermitList.length,
                controller: listScrollController,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemBuilder: (BuildContext context, index) {
                  return Obx(
                    () => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: controller.houseEventPermitList[index]
                                            .selected!.value ==
                                        false
                                    ? const DecorationImage(
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
                                    : const SizedBox.shrink(),
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
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.primaryColor,
                    ),
                    image: const DecorationImage(
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
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
