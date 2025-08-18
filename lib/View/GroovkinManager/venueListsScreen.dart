// ignore_for_file: unused_field


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';
import '../../Components/Network/Url.dart';

class VenueListScreen extends StatelessWidget {
  VenueListScreen({super.key});

  final ManagerController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar:
            customAppBar(theme: theme, text: "My Groovkin", backArrow: false),
        body: GetBuilder<ManagerController>(initState: (v) {
          _controller.getAllVenues();
        }, builder: (controller) {
          return controller.getAllVenuesLoader.value == false
              ? const SizedBox.shrink()
              : controller.allVenueData!.data!.data!.isEmpty
                  ? Center(
                      child: Text(
                        "No Venue",
                        style: poppinsMediumStyle(
                          fontSize: 16,
                          color: theme.primaryColor,
                          context: context,
                        ),
                      ),
                    )
                  : NotificationListener<ScrollNotification>(
                      onNotification: (scroll) {
                        if (scroll.metrics.pixels ==
                            scroll.metrics.maxScrollExtent) {
                          if (controller.venueWaiting == false) {
                            controller.venueWaiting = true;
                            if (controller.allVenueData!.data!.nextPageUrl !=
                                null) {
                              controller.getAllVenues(
                                  nextUrl: controller
                                      .allVenueData!.data!.nextPageUrl);
                              return true;
                            } else {
                              print("next Url Null");
                            }
                          }
                          return false;
                        }
                        return false;
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                "Venue",
                                style: poppinsMediumStyle(
                                  fontSize: 16,
                                  color: theme.primaryColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Text(
                                  "These are the venues you manage.  You can update existing entries or add a new venue to your list.",
                                  textAlign: TextAlign.center,
                                  style: poppinsMediumStyle(
                                    fontSize: 12,
                                    color: DynamicColor.lightRedClr,
                                  ),
                                ),
                              ),
                              ListView.builder(
                                  itemCount: controller
                                      .allVenueData!.data!.data!.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.toNamed(
                                            Routes.viewOtherEventsDetails,
                                            arguments: {
                                              "venueId": controller
                                                  .allVenueData!
                                                  .data!
                                                  .data![index]
                                                  .id,
                                              "buttonShow": false,
                                              "editBtn": true,
                                            });
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.symmetric(vertical: 6.0),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 8),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              image: const DecorationImage(
                                                image: AssetImage(
                                                "assets/grayClor.png",
                                                ),
                                                fit: BoxFit.fill,
                                              )),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: DynamicColor
                                                            .yellowClr),
                                                    image: DecorationImage(
                                                        fit: BoxFit.fill,
                                                        image: controller
                                                                    .allVenueData!
                                                                    .data!
                                                                    .data![
                                                                        index]
                                                                    .profilePicture![
                                                                        0]
                                                                    .thumbnail ==
                                                                null
                                                            ? NetworkImage(Url().imageUrl +
                                                                controller
                                                                    .allVenueData!
                                                                    .data!
                                                                    .data![index]
                                                                    .profilePicture![0]
                                                                    .mediaPath
                                                                    .toString())
                                                            : NetworkImage(Url().imageUrl + controller.allVenueData!.data!.data![index].profilePicture![0].thumbnail.toString()))),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(left: 8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      controller
                                                          .allVenueData!
                                                          .data!
                                                          .data![index]
                                                          .venueName
                                                          .toString(),
                                                      style:
                                                          poppinsRegularStyle(
                                                              fontSize: 15,
                                                              color: theme
                                                                  .primaryColor,
                                                              context: context),
                                                    ),
                                                    Text(
                                                      "Tap to view detail about property",
                                                      style:
                                                          poppinsRegularStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  DynamicColor
                                                                      .grayClr,
                                                              context: context),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                    );
        }),
        bottomNavigationBar: Obx(
          () => _controller.getAllVenuesLoader.value == false
              ? const SizedBox.shrink()
              : SafeArea(
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 2, left: 12, right: 12),
                    child: CustomButton(
                      backgroundClr: false,
                      onTap: () {
                        _controller.clearFields();
                        Get.toNamed(Routes.createCompanyProfileScreen,
                            arguments: {
                              "updationCondition": false,
                              "skipBtnHide": true
                            });
                      },
                      text: "Add new venue",
                      borderClr: Colors.transparent,
                    ),
                  ),
              ),
        ),
      ),
    );
  }
}
