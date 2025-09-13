import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/mediaModel.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/organizerHomeModel/alleventsModel.dart';
import 'package:groovkin/utils/utils.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../../Components/Network/Url.dart';

class CommentsAndAttachment extends StatefulWidget {
  const CommentsAndAttachment({super.key});

  @override
  State<CommentsAndAttachment> createState() => _CommentsAndAttachmentState();
}

class _CommentsAndAttachmentState extends State<CommentsAndAttachment> {
  String address = "null";

  String autocompletePlace = "null";

  Prediction? initialValue;

  AuthController authController = Get.find();

  final EventController _controller = Get.find();

  // ManagerController managerController = Get.find();

  final commentsForm = GlobalKey<FormState>();

  late ManagerController managerController;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<ManagerController>()) {
      managerController = Get.find<ManagerController>();
    } else {
      managerController = Get.put(ManagerController());
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(
        theme: theme,
        text: "",
        imagee: true,
        actions: [
          ((_controller.eventDetail == null) &&
                  (_controller.draftCondition.value == true))
              ? GestureDetector(
                  onTap: () {
                    _controller.postEventFunction(context, theme, draft: true);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(Icons.drafts),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
      body: GetBuilder<EventController>(builder: (eventController) {
        return GetBuilder<ManagerController>(builder: (controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Form(
              key: commentsForm,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Comments to Venue Manager',
                          textAlign: TextAlign.center,
                          style: poppinsMediumStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            context: context,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: DynamicColor.darkGrayClr,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: CustomTextFieldsHintText(
                        maxLine: 5,
                        validation: "comments",
                        controller: eventController.commentsController,
                        hintText: "write her..",
                        borderClr: DynamicColor.grayClr.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: Get.width,
                      decoration: BoxDecoration(
                        color: DynamicColor.darkGrayClr,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: DynamicColor.avatarBgClr),
                      ),
                      child: Column(
                        children: [
                          // Description for attached files
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "Please upload any documents/files that will help with the negotiation.",
                              style: TextStyle(
                                fontSize: 14,
                                color: DynamicColor.grayClr,
                              ),
                            ),
                          ),

                          ((eventController.imageListtt.isNotEmpty) &&
                                      (eventController.duplicateValue.value ==
                                          false)) ||
                                  controller.mediaClass.isNotEmpty
                              ? SizedBox(
                                  height: 180,
                                  width: Get.width,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      itemCount: ((controller
                                              .mediaClass.isNotEmpty))
                                          ? controller.mediaClass.length
                                          : eventController.imageListtt.length,
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return assetImage(
                                          eventController: eventController,
                                          controller: controller,
                                          mediaItem:
                                              controller.mediaClass.isNotEmpty
                                                  ? controller.mediaClass[index]
                                                  : null,
                                          bannerImage: eventController
                                                  .imageListtt.isNotEmpty
                                              ? eventController
                                                  .imageListtt[index]
                                              : null,
                                        );
                                      }),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Icon(
                                    Icons.attach_file_outlined,
                                    color: DynamicColor.grayClr,
                                    size: 35,
                                  ),
                                ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: GestureDetector(
                              onTap: () {
                                if (FocusScope.of(context).hasFocus) {
                                  FocusScope.of(context).unfocus();
                                }
                                // if (Platform.isAndroid) {
                                //   managerController.pickFile();
                                // } else {
                                // }
                                managerController.pickFileee();
                              },
                              child: Container(
                                width: 120,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: DynamicColor.grayClr
                                      .withValues(alpha: 0.2),
                                ),
                                child: Center(
                                  child: Text(
                                    "Attached file",
                                    style: poppinsRegularStyle(
                                      fontSize: 15,
                                      context: context,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      }),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: CustomButton(
            borderClr: Colors.transparent,
            onTap: () {
              if (commentsForm.currentState!.validate()) {
                if (_controller.showEditPreviewScreen.value == true) {
                  Get.toNamed(Routes.eventPreview,
                      arguments: {"viewDetails": 1});
                } else {
                  // if (_controller.eventDetail != null &&
                  //     _controller.eventDetail!.data!.location != null &&
                  //     _controller.draftCondition.value != false) {
                  //   Get.toNamed(Routes.eventPreview,
                  //       arguments: {"viewDetails": 1});
                  // } else {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return MapLocationPicker(
                          onTappp: () {
                            print(managerController.lat);
                            print(managerController.lng);
                            Get.toNamed(Routes.listOfVenuesScreen);
                          },
                          // onTapShow: true,
                          // hideLocation: true,
                          // lat: double.parse(eventData.latitude.toString()),
                          // long: double.parse(eventData.longitude.toString()),
                          minMaxZoomPreference:
                              const MinMaxZoomPreference(0, 15),
                          apiKey: "AIzaSyC_-hLFYGAJC_IBMnFBKZLq2IS1qr7tJgQ",
                          canPopOnNextButtonTaped: true,
                          searchHintText: managerController.address != "null"
                              ? managerController.address
                              : "Start typing to search",
                          // canPopOnNextButtonTaped: true,
                          latLng: managerController.latLng,
                          initAddress: managerController.address,
                          nextPage: () {
                            Get.toNamed(Routes.listOfVenuesScreen);
                            managerController.update();
                          },
                          onNext: (GeocodingResult? result) {
                            if (result != null) {
                              managerController.lat =
                                  result.geometry.location.lat.toString();
                              managerController.lng =
                                  result.geometry.location.lng.toString();
                              managerController.address =
                                  result.formattedAddress ?? "";
                              managerController.latLng = LatLng(
                                  result.geometry.location.lat,
                                  result.geometry.location.lng);
                              managerController.addressController.text =
                                  result.formattedAddress!;
                              Get.toNamed(Routes.listOfVenuesScreen);
                              managerController.update();
                            }
                          },
                          onSuggestionSelected:
                              (PlacesDetailsResponse? result) {
                            if (result != null) {
                              managerController.lat = result
                                  .result.geometry!.location.lat
                                  .toString();
                              managerController.lng = result
                                  .result.geometry!.location.lng
                                  .toString();
                              managerController.autocompletePlace =
                                  result.result.formattedAddress ?? "";
                              managerController.address =
                                  result.result.formattedAddress ?? "";
                              managerController.latLng = LatLng(
                                  result.result.geometry!.location.lat,
                                  result.result.geometry!.location.lng);
                              managerController.addressController.text =
                                  result.result.formattedAddress!;

                              Get.toNamed(Routes.listOfVenuesScreen);
                              managerController.update();
                            }
                          },
                        );
                      },
                    ),
                  );
                }
              }
              // }
            },
            text: "Continue",
          ),
        ),
      ),
    );
  }
}

assetImage(
    {eventController,
    controller,
    MediaClass? mediaItem,
    BannerImage? bannerImage,
    bool closedIcon = true}) {
  {
    if (mediaItem != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: mediaItem.fileType == "pdf"
                ? null
                : DecorationImage(
                    fit: BoxFit.fill,
                    image: FileImage(
                      File(mediaItem.filename.toString()),
                    ),
                  ),
          ),
          child: GestureDetector(
              onTap: () async {
                if (mediaItem.id == null) {
                  controller.mediaClass.remove(mediaItem);
                  controller.update();
                }
              },
              child: Stack(
                children: [
                  if (mediaItem.fileType == "pdf")
                    GestureDetector(
                      onTap: () {
                        Get.to(() => Scaffold(
                              backgroundColor: Colors.transparent,
                              appBar: AppBar(title: const Text("PDF Viewer")),
                              body: SfPdfViewer.file(
                                File(mediaItem.filename.toString()),
                              ),
                            ));
                      },
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color:
                              DynamicColor.lightGrayClr.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.picture_as_pdf,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  closedIcon == false
                      ? const SizedBox.shrink()
                      : const Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                              radius: 15, child: Icon(Icons.clear)),
                        ),
                ],
              )),
        ),
      );
    }
    if (bannerImage != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: bannerImage.mediaPath.toString().split(".").last == "pdf"
                ? null
                : DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                      bannerImage.mediaPath.toString(),
                    ),
                  ),
          ),
          child: GestureDetector(
              onTap: () async {
                eventController.removeImageList.add(bannerImage.id);
                await eventController.deleteImage(
                    id: eventController.eventDetail!.data!.id, eventImg: true);
                eventController.imageListtt.remove(bannerImage);
                eventController.update();
                controller.update();
              },
              child: Stack(
                children: [
                  if (bannerImage.mediaPath.toString().split(".").last == "pdf")
                    GestureDetector(
                      onTap: () {
                        Get.to(() => Scaffold(
                              backgroundColor: Colors.transparent,
                              appBar: AppBar(title: const Text("PDF Viewer")),
                              body: SfPdfViewer.network(
                                bannerImage.mediaPath.toString(),
                              ),
                            ));
                      },
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color:
                              DynamicColor.lightGrayClr.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.picture_as_pdf,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  closedIcon == false
                      ? const SizedBox.shrink()
                      : const Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                              radius: 15, child: Icon(Icons.clear)),
                        ),
                ],
              )),
        ),
      );
    }
  }
}

///>>>>>>>>>>>>>>>>>>>>>>>>>> get list of venues
class ListOfVenuesScreen extends StatelessWidget {
  ListOfVenuesScreen({super.key});

  final EventController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight * 3.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: kToolbarHeight * 1.8,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              width: Get.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/map.png"), fit: BoxFit.fill)),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Search the venue you want to\nnegotiate with",
                      textAlign: TextAlign.center,
                      style: poppinsMediumStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          context: context,
                          color: theme.scaffoldBackgroundColor),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const ImageIcon(
                        AssetImage("assets/backArrow.png"),
                        color: Colors.black,
                      )),
                ],
              ),
            ),
            GetBuilder<EventController>(builder: (controller) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                child: CustomTextFields(
                  borderClr: theme.primaryColor,
                  iconShow: true,
                  labelText: "Add here",
                  onChanged: (value) {
                    controller.searchingList(value);
                  },
                  suffixWidget: GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.addLocationScreen);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: theme.primaryColor,
                        ),
                        child: Icon(
                          Icons.filter_alt,
                          color: theme.scaffoldBackgroundColor,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    "Venue",
                    style: poppinsMediumStyle(
                      fontSize: 18,
                      context: context,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
                GetBuilder<EventController>(builder: (controller) {
                  return Visibility(
                    visible: controller.isFilterApiHit,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        controller.allVenueList = null;
                        controller.update();
                        controller.getVenuesLatLng();
                      },
                      child: Padding(
                          padding:
                              const EdgeInsets.only(left: 12.0, right: 12.0),
                          child: Container(
                            padding: EdgeInsets.only(left: 12, right: 12),
                            decoration: BoxDecoration(
                                color: DynamicColor.grayClr,
                                borderRadius: BorderRadius.circular(30)),
                            child: Row(
                              children: [
                                Text(
                                  "Clear Filter",
                                  style: poppinsRegularStyle(
                                    fontSize: 14,
                                    context: context,
                                    color: theme.primaryColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.clear,
                                    size: 18,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          )),
                    ),
                  );
                })
              ],
            ),
            SizedBox(
              height: 3,
            ),
            Center(
              child: Text(
                "Select the venue for the event",
                style: poppinsMediumStyle(
                  fontSize: 16,
                  context: context,
                  color: theme.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
      body: GetBuilder<EventController>(initState: (v) {
        _controller.getVenuesLatLng();
      }, builder: (controller) {
        if (controller.getVenuesLatLngLoader.value == false ||
            controller.getFilterVenueLoader == false) {
          return SizedBox.shrink();
        }

        final venues = (controller.allVenueSearchingList != null &&
                controller.allVenueSearchingList!.data != null &&
                controller.allVenueSearchingList!.data!.data!.isNotEmpty)
            ? controller.allVenueSearchingList!.data!.data!
            : [];

        if (venues.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Center(
              child: Text(
                "No Data",
                style: poppinsMediumStyle(
                  fontSize: 17,
                  context: context,
                  color: theme.primaryColor,
                ),
              ),
            ),
          );
        }

        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ListView.builder(
                itemCount: venues.length,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, index) {
                  final venue = venues[index];
                  return GestureDetector(
                    onTap: venue.user!.deleteAt == null
                        ? () {
                            controller.venuesDetails = venue;
                            Get.toNamed(Routes.viewOtherEventsDetails,
                                arguments: {
                                  "venueId": venue.id,
                                  "buttonShow": true,
                                  "editBtn": false,
                                });
                            // Get.toNamed(Routes.venueInfoScreen);
                          }
                        : () {
                            Utils.showToast();
                          },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: venue.user!.deleteAt == null
                              ? Colors.transparent
                              : DynamicColor.disabledColor,
                          image: venue.user!.deleteAt == null
                              ? const DecorationImage(
                                  image: AssetImage("assets/grayClor.png"),
                                  fit: BoxFit.fill)
                              : null,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: DynamicColor.darkYellowClr,
                              child: CircleAvatar(
                                radius: 24,
                                backgroundImage: NetworkImage(
                                    venue.profilePicture![0].thumbnail == null
                                        ? Url().imageUrl +
                                            venue.profilePicture![0].mediaPath
                                                .toString()
                                        : Url().imageUrl +
                                            venue.profilePicture![0].thumbnail
                                                .toString()),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 7.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    venue.venueName.toString(),
                                    style: poppinsRegularStyle(
                                      fontSize: 14,
                                      context: context,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                  Text(
                                    "Tap to view detail about property",
                                    style: poppinsRegularStyle(
                                        fontSize: 12,
                                        context: context,
                                        color: theme.primaryColor
                                            .withValues(alpha: 0.5)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }));
      }),
    );
  }
}

///>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Add Location   >>>>>>>>>>>>>>>>>>>>>>>>>>>>>

class AddLocationScreen extends StatefulWidget {
  const AddLocationScreen({super.key});

  @override
  State<AddLocationScreen> createState() => _AddLocationScreenState();
}

class _AddLocationScreenState extends State<AddLocationScreen> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GetBuilder<EventController>(builder: (controller) {
      return Scaffold(
        appBar: customAppBar(theme: theme, text: "Add location"),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: Get.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: DynamicColor.avatarBgClr),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Radius in mile",
                          style: poppinsMediumStyle(
                            fontSize: 18,
                            color: theme.primaryColor,
                            context: context,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "Select Radius",
                              style: poppinsRegularStyle(
                                fontSize: 15,
                                context: context,
                                color: theme.primaryColor,
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                "Type here",
                                style: poppinsRegularStyle(
                                    fontSize: 11,
                                    color: DynamicColor.grayClr
                                        .withValues(alpha: 0.9),
                                    context: context),
                              ),
                            ),
                            Container(
                              width: Get.width / 7,
                              // height: 30,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: DynamicColor.whiteClr)),
                              child: TextField(
                                controller: controller.radiusController,
                                textAlign: TextAlign.center,
                                style: poppinsRegularStyle(
                                    fontSize: 12,
                                    color: theme.primaryColor,
                                    context: context),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  TextInputFormatter.withFunction(
                                    (oldValue, newValue) {
                                      if (newValue.text.isEmpty) {
                                        return newValue;
                                      }
                                      final value = int.tryParse(newValue.text);
                                      if (value == null ||
                                          value < 1 ||
                                          value > 1000) {
                                        return oldValue; // reject change if not in range
                                      }
                                      return newValue;
                                    },
                                  )
                                ],
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "00",
                                  hintStyle: poppinsRegularStyle(
                                      fontSize: 12,
                                      color: theme.primaryColor,
                                      context: context),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // CustomTextFields(
                  //   borderClr: theme.primaryColor,
                  //   labelText: "Max Capacity",
                  // ),

                  RangeSlider(
                    values:
                        RangeValues(controller.startMile, controller.endMile),
                    onChanged: (value) {
                      setState(() {
                        controller.startMile = value.start;
                        controller.endMile = value.end;
                      });
                    },
                    min: 10.0,
                    max: 1000.0,
                    activeColor: DynamicColor.yellowClr,
                    inactiveColor: Colors.grey,
                  ),
                  Text(
                    "Start: " +
                        controller.startMile.ceil().toString() +
                        "\nEnd: " +
                        controller.endMile.ceil().toString(),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: CustomButton(
              borderClr: Colors.transparent,
              onTap: () async {
                // Get.back();
                // Get.toNamed(Routes.confirmationEventScreen);
                if (controller.radiusController.text.isEmpty ||
                    (controller.startMile == 0.0 ||
                        controller.endMile == 0.0)) {
                  bottomToast(text: "Field Required!");
                } else {
                  await controller.getFilterVenueLatLng(
                      controller.startMile.ceil(), controller.endMile.ceil());
                }
              },
              text: "Search Filter",
            ),
          ),
        ),
      );
    });
  }
}
