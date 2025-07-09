// ignore_for_file: iterable_contains_unrelated_type

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/alertmessage.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/mediaModel.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinManager/addVenueItems/addVenueMedel.dart';
import 'package:groovkin/View/GroovkinManager/managerPendingEventModel.dart';
import 'package:groovkin/View/GroovkinManager/venueDetailsModel.dart'
    as venueDtail;
import 'package:groovkin/View/GroovkinManager/venueListManagerModel.dart';
import 'package:groovkin/View/bottomNavigation/bottomNavigation.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';
import 'package:groovkin/View/counters/messagesModel.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as form;
import 'package:intl/intl.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../bottomNavigation/homeTabs/organizerHomeModel/alleventsModel.dart';
import 'package:geocoding/geocoding.dart';

class ManagerController extends GetxController {
  late HomeController homeController;

  @override
  void onInit() {
    super.onInit();

    if (Get.isRegistered<HomeController>()) {
      homeController = Get.find<HomeController>();
    } else {
      homeController = Get.put(HomeController());
    }
  }

  Future<Map<String, dynamic>> getCityAndState(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String? city = placemark.locality; // City
        String? state = placemark.administrativeArea; // State
        String? zipCode = placemark.postalCode; // Zip Code
        return {
          "city": city,
          "state": state,
          "zipCode": zipCode,
        };
      }
    } catch (e) {
      print('Error: $e');
    }
    return {};
  }

  ///Upload Profile Pic
  String? imageBytes;
  XFile? files;
  final ImagePicker _picker = ImagePicker();
  File? profileImage;
  cameraImage(context, source) async {
    try {
      files = await _picker.pickImage(
          source: source, imageQuality: 50, maxHeight: 1920, maxWidth: 1080);
      CroppedFile? file =
          await ImageCropper().cropImage(sourcePath: files!.path);
      if (files != null) {
        if (file != null) {
          imageBytes = file.path;
        } else {
          imageBytes = files!.path;
        }
      }
      update();
    } catch (e) {
      // BotToast.showText(text: e.toString());
    }
  }

  ///get image or video
  List<MediaClass> mediaClass = [];
  List<form.MultipartFile> multiPartImg = [];

  Future<void> pickFileee() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: [
          "mp4",
          "mov",
          "png",
          "jpg",
          "jpeg",
        ]);

    if (result == null) {
      // User canceled the picker
      return;
    }

    for (int i = 0; i < result.files.length; i++) {
      PlatformFile file = result.files[i];
      String extension = file.extension?.toLowerCase() ?? '';
      if (extension == 'mov' || extension == 'mp4') {
        // Replace "MOV" with "mp4" in the file path
        String modifiedPath = file.path!.replaceAll('.mov', '.mp4');
        // Create a new PlatformFile with the modified path
        PlatformFile modifiedFile = PlatformFile(
          name: file.name.replaceAll('.mov', '.mp4'),
          size: file.size,
          bytes: file.bytes,
          path: modifiedPath,
        );

        // Replace the original file with the modified one
        result.files[i] = modifiedFile;
        String? thumbnail = await generateThumbnail(file.path!);
        if (updateAmenities.value == true) {
          profilePictures.add(venueDtail.ProfilePicture(
            mediaPath: file.path,
            thumbnail: thumbnail,
          ));
        }
        mediaClass.add(MediaClass(
          filename: file.path,
          fileType: extension,
          thumbnail: thumbnail,
        ));

        multiPartImg.add(form.MultipartFile.fromFileSync(
          file.path!,
          filename: 'Video.${file.path!.split('.').last}',
          contentType: MediaType('video', file.path!.split('.').last),
        ));
      } else if (extension == 'jpg' ||
          extension == 'png' ||
          extension == 'jpeg') {
        if (updateAmenities.value == true) {
          profilePictures.add(venueDtail.ProfilePicture(
            mediaPath: file.path,
          ));
        }

        mediaClass.add(MediaClass(
          filename: file.path,
          fileType: extension,
        ));

        multiPartImg.add(form.MultipartFile.fromFileSync(
          file.path!,
          filename: 'Image.${file.path!.split('.').last}',
          contentType: MediaType('image', file.path!.split('.').last),
        ));
      }
    }

    update();
  }

  Future<String?> generateThumbnail(String videoPath) async {
    return await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      maxHeight: 64,
      quality: 75,
    );
  }

  ///Upload Venue Photos

  Future<void> pickMultipleFromCamera(
      BuildContext context, bool? isVideo) async {
    try {
      List<XFile> tempFiles = [];
      // Ask user whether to capture an image or a video

      if (isVideo == null) return; // Exit loop if user cancels

      // Pick image or video based on user choice
      XFile? pickedFile = isVideo
          ? await _picker.pickVideo(
              source: ImageSource.camera,
              maxDuration: const Duration(seconds: 60),
            )
          : await _picker.pickImage(
              source: ImageSource.camera,
              imageQuality: 50,
              maxHeight: 1920,
              maxWidth: 1080,
            );

      if (pickedFile == null) return; // Exit loop if user cancels

      tempFiles.add(pickedFile);

      if (tempFiles.isNotEmpty) {
        for (XFile file in tempFiles) {
          String extension = file.path.split('.').last.toLowerCase();

          if (extension == 'mp4') {
            // Generate video thumbnail
            final fileName = await VideoThumbnail.thumbnailFile(
              video: file.path,
              thumbnailPath: (await getTemporaryDirectory()).path,
              imageFormat: ImageFormat.PNG,
              maxHeight: 64,
              quality: 75,
            );

            if (updateAmenities.value == true) {
              profilePictures.add(venueDtail.ProfilePicture(
                  mediaPath: file.path, thumbnail: fileName));
            }

            mediaClass.add(MediaClass(
                filename: file.path, fileType: extension, thumbnail: fileName));

            multiPartImg.add(form.MultipartFile.fromFileSync(
              file.path,
              filename: "Video.$extension",
              contentType: MediaType("video", extension),
            ));
          } else {
            // Handle images
            if (updateAmenities.value == true) {
              profilePictures
                  .add(venueDtail.ProfilePicture(mediaPath: file.path));
            }

            mediaClass
                .add(MediaClass(filename: file.path, fileType: extension));

            multiPartImg.add(form.MultipartFile.fromFileSync(
              file.path,
              filename: "Image.$extension",
              contentType: MediaType("image", extension),
            ));
          }
        }
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    update();
  }

  Future<void> pickFile() async {
    final List<XFile> result = await _picker.pickMultipleMedia();
    if (result.isNotEmpty) {
      // mediaClass.clear();
      // multiPartImg.clear();
      for (int i = 0; i < result.length; i++) {
        if (result[i].path.split(".").last == 'mp4') {
          final fileName = await VideoThumbnail.thumbnailFile(
            video: result[i].path,
            thumbnailPath: (await getTemporaryDirectory()).path,
            imageFormat: ImageFormat.PNG,
            maxHeight:
                64, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
            quality: 75,
          );
          if (updateAmenities.value == true) {
            profilePictures.add(venueDtail.ProfilePicture(
                mediaPath: result[i].path, thumbnail: fileName));
          }
          mediaClass.add(MediaClass(
              filename: result[i].path,
              fileType: result[i].path.split('.').last,
              thumbnail: fileName));
          multiPartImg.add(form.MultipartFile.fromFileSync(
            result[i].path,
            filename: "Video.${result[i].path.split('.').last}",
            contentType: MediaType("video", result[i].path.split('.').last),
          ));
        } else {
          if (updateAmenities.value == true) {
            profilePictures
                .add(venueDtail.ProfilePicture(mediaPath: result[i].path));
          }
          mediaClass.add(MediaClass(
            filename: result[i].path,
            fileType: result[i].path.split('.').last,
          ));
          multiPartImg.add(form.MultipartFile.fromFileSync(
            result[i].path,
            filename: "Image.${result[i].path.split('.').last}",
            contentType: MediaType("image", result[i].path.split('.').last),
          ));
        }
      }
    } else {
      // User canceled the picker
    }

    ///add Id's of uploaded image >>>>>>>>>>>>>>>>>>>
    // if((memories !=null)&&(memories!.media!.isNotEmpty)){
    //   mediaDeleteList.add(memories!.media![0].fileId);
    // }
    update();
  }

  final venueNameController = TextEditingController();
  final streetAddressController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final zipController = TextEditingController();
  final addressController = TextEditingController();
  final phoneNumController = TextEditingController();
  String? numberAssign = "+1";
  String address = "null";
  String autocompletePlace = "null";
  String lat = "null";
  String lng = "null";
  LatLng? latLng;
  List<LatLng> latLang = [];
  RxBool termsConditionAgree = false.obs;
  final maxOccupancyController = TextEditingController();
  final maxSeatingController = TextEditingController();
  final maxHourController = TextEditingController();
  final openingHoursController = TextEditingController();
  final closedHoursController = TextEditingController();
  final format = DateFormat("HH:mm");

  AddVenueModel? amenities;
  RxBool getAmenitiesLoader = true.obs;
  List<AmenitiesItem> amenitiesList = [];
  List<AmenitiesItem> licensesPermitList = [];
  List<AmenitiesItem> houseEventPermitList = [];
  getAmenities({type}) async {
    getAmenitiesLoader(false);
    var response = await API().getApi(url: 'show-venue-items?type=$type');
    if (response.statusCode == 200) {
      amenities = AddVenueModel.fromJson(response.data);
      if (type == "amenities") {
        amenitiesList.clear();
        if (updateAmenities.value == false) {
          amenitiesList.addAll(amenities!.data!);
        } else {
          for (var element in amenities!.data!) {
            for (var elementt in venueDetails!.data!.amenities!) {
              if (element.id == elementt.venueItemId) {
                element.selected!.value = true;
                selectedAmenities.add(element);
              }
            }
          }
          amenitiesList.addAll(amenities!.data!);
        }
      } else if (type == "licenses_and_permit") {
        licensesPermitList.clear();
        if (updateAmenities.value == false) {
          licensesPermitList.addAll(amenities!.data!);
        } else {
          for (var element in amenities!.data!) {
            for (var elementt in venueDetails!.data!.licensesAndPermit!) {
              print(element.id);
              print(elementt.venueItem!.id);
              if (element.id == elementt.venueItem!.id) {
                element.selected!.value = true;
                selectedLicensesPermit.add(element);
              }
            }
          }
          licensesPermitList.addAll(amenities!.data!);
        }
      } else {
        houseEventPermitList.clear();
        if (updateAmenities.value == false) {
          houseEventPermitList.addAll(amenities!.data!);
        } else {
          for (var element in amenities!.data!) {
            for (var elementt in venueDetails!.data!.houseEventCapabilities!) {
              if (element.id == elementt.venueItemId) {
                element.selected!.value = true;
                selectedHouseEventPermit.add(element);
              }
            }
          }
          houseEventPermitList.addAll(amenities!.data!);
        }
      }
      getAmenitiesLoader(true);
      update();
    }
  }

  ///create venue function
  List<AmenitiesItem> selectedAmenities = [];
  List<AmenitiesItem> selectedLicensesPermit = [];
  List<AmenitiesItem> selectedHouseEventPermit = [];
  createVenue(context, theme) async {
    List amenities = [];
    List permitList = [];
    List houseEvent = [];
    for (var element in selectedAmenities) {
      amenities.add(element.id);
    }
    for (var element in selectedLicensesPermit) {
      permitList.add(element.id);
    }
    for (var element in selectedHouseEventPermit) {
      houseEvent.add(element.id);
    }
    var formData = form.FormData.fromMap({
      "venue_name": venueNameController.text,
      "street_address": streetAddressController.text,
      "state": stateController.text,
      "zip_code": zipController.text,
      "location": addressController.text,
      "phone_number": phoneNumController.text,
      "latitude": double.parse(lat),
      "longitude": double.parse(lng),
      "max_occupancy": int.parse(maxOccupancyController.text),
      "max_seating": int.parse(maxSeatingController.text),
      if (maxHourController.text.isNotEmpty)
        "max_hour": int.parse(maxHourController.text),
      "opening_hours": openingHoursController.text,
      "closing_hours": closedHoursController.text,
      "amenities[]": amenities,
      "licenses_and_permit_items[]": permitList,
      "house_event_items[]": houseEvent,
      "image[]": multiPartImg,
      "city": cityController.text,
    });
    print(formData);
    var response = await API().postApi(formData, "add-venue", multiPart: true);
    if (response.statusCode == 200) {
      showDialog(
          barrierColor: Colors.transparent,
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertWidget(
              height: kToolbarHeight * 5,
              container: SizedBox(
                width: Get.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Congratulation!',
                        textAlign: TextAlign.center,
                        style: poppinsRegularStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          context: context,
                          color: theme.primaryColor,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "Your profile has been created",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                          style: poppinsRegularStyle(
                            fontSize: 13,
                            context: context,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                          height: 120,
                          child:
                              Image(image: AssetImage("assets/handshake.png"))),
                    ],
                  ),
                ),
              ),
            );
          });
      Future.delayed(const Duration(seconds: 2), () {
        Get.back();
        selectIndexxx.value = 0;
        Get.offAllNamed(Routes.bottomNavigationView,
            arguments: {"indexValue": 1});
      });
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  edit venue

  editVenue() async {
    if (removeImgList.isNotEmpty) {
      await removeImg();
    }
    List amenities = [];
    List permitList = [];
    List houseEvent = [];
    for (var element in selectedAmenities) {
      amenities.add(element.id);
    }
    for (var element in selectedLicensesPermit) {
      permitList.add(element.id);
    }
    for (var element in selectedHouseEventPermit) {
      houseEvent.add(element.id);
    }
    var formData = form.FormData.fromMap({
      "venue_name": venueNameController.text,
      "street_address": streetAddressController.text,
      "state": stateController.text,
      "zip_code": zipController.text,
      "phone_number": phoneNumController.text,
      "location": addressController.text,
      "latitude": double.parse(lat),
      "longitude": double.parse(lng),
      "max_occupancy": int.parse(maxOccupancyController.text),
      "max_seating": int.parse(maxSeatingController.text),
      if (maxHourController.text.isNotEmpty)
        "max_hour": int.parse(maxHourController.text),
      "opening_hours": openingHoursController.text,
      "closing_hours": closedHoursController.text,
      "amenities[]": amenities,
      "licenses_and_permit_items[]": permitList,
      "house_event_items[]": houseEvent,
      if (multiPartImg.isNotEmpty) "image[]": multiPartImg,
      "city": cityController.text
    });
    print(formData);
    var response =
        await API().postApi(formData, "edit-venue/${venueDetails!.data!.id}");
    if (response.statusCode == 200) {
      bottomToast(text: response.data['message']);
      Get.offAllNamed(Routes.bottomNavigationView,
          arguments: {"indexValue": 1});
      clearFields();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  remove image
  List removeImgList = [];
  removeImg() async {
    var formData = form.FormData.fromMap({
      "venue_id": venueDetails!.data!.id,
      "media_id[]": removeImgList,
    });
    var response = await API().postApi(formData, "remove-venue-images");
    if (response.statusCode == 200) {}
  }

  ///get all venues
  RxBool getAllVenuesLoader = true.obs;
  AllVenueModel? allVenueData;
  bool venueWaiting = false;

  getAllVenues({nextUrl}) async {
    getAllVenuesLoader(false);
    var response = await API().getApi(url: "show-venues");
    if (response.statusCode == 200) {
      if (nextUrl == null) {
        venueWaiting = false;
        allVenueData = AllVenueModel.fromJson(response.data);
      } else {
        allVenueData!.data!.data!
            .addAll(AllVenueModel.fromJson(response.data).data!.data!);
        allVenueData!.data!.nextPageUrl =
            AllVenueModel.fromJson(response.data).data!.nextPageUrl;
        venueWaiting = false;
      }
      getAllVenuesLoader(true);
      update();
    }
  }

  ///get details of venue
  RxBool getVenueDetailsLoader = true.obs;
  venueDtail.VenueDetailsModel? venueDetails;
  List<String> imageList = [];
  getVenueDetails({id}) async {
    getVenueDetailsLoader(false);
    imageList.clear();
    var response = await API().getApi(url: "venue-details/$id");
    if (response.statusCode == 200) {
      venueDetails = venueDtail.VenueDetailsModel.fromJson(response.data);
      for (var element in venueDetails!.data!.profilePicture!) {
        imageList.add(element.mediaPath!);
      }
      getVenueDetailsLoader(true);
      update();
    }
  }

  RxBool updateAmenities = false.obs;
  List<venueDtail.ProfilePicture> profilePictures = [];
  editVenueDataBind() async {
    updateAmenities(true);
    profilePictures.clear();
    venueNameController.text = venueDetails!.data!.venueName!;
    streetAddressController.text = venueDetails!.data!.streetAddress!;
    cityController.text = venueDetails!.data!.city.toString();
    stateController.text = venueDetails!.data!.state!;
    zipController.text = venueDetails!.data!.zipCode!;
    lat = venueDetails!.data!.latitude!;
    lng = venueDetails!.data!.longitude!;
    address = venueDetails!.data!.location!;
    autocompletePlace = venueDetails!.data!.location!;
    addressController.text = venueDetails!.data!.location!;
    termsConditionAgree.value = true;
    phoneNumController.text = venueDetails!.data!.phoneNumber!;
    maxOccupancyController.text =
        venueDetails!.data!.venueProperty!.maxOccupancy!;
    maxSeatingController.text = venueDetails!.data!.venueProperty!.maxSeating!;
    if (venueDetails!.data!.venueProperty!.maxHour != null) {
      maxHourController.text = venueDetails!.data!.venueProperty!.maxHour!;
    }
    openingHoursController.text =
        venueDetails!.data!.venueProperty!.openingHours!;
    closedHoursController.text =
        venueDetails!.data!.venueProperty!.closingHours!;
    removeImgList.clear();
    profilePictures.addAll(venueDetails!.data!.profilePicture!);
    Get.toNamed(Routes.createCompanyProfileScreen,
        arguments: {"updationCondition": true, "skipBtnHide": true});
  }

  ///clear text fields
  clearFields() async {
    updateAmenities.value = false;
    venueNameController.clear();
    streetAddressController.clear();
    stateController.clear();
    zipController.clear();
    lat = "null";
    lng = "null";
    address = "null";
    autocompletePlace = "null";
    addressController.clear();
    termsConditionAgree.value = false;
    phoneNumController.clear();
    maxOccupancyController.clear();
    maxSeatingController.clear();
    maxHourController.clear();
    openingHoursController.clear();
    closedHoursController.clear();
    venueDetails = null;
    update();
  }

  ///>>>>>>>>>>>>>>>>>>> event manager get all pending events
  RxBool getAllPendingEventsLoader = true.obs;
  ManagerPendingEventsModel? managerPendingEvents;
  getAllPendingEvents() async {
    getAllPendingEventsLoader(false);
    var response = await API()
        .getApi(url: "show-venue-requested-events", queryParameters: {
      "filter": (homeController.showIndexValue == 2 &&
              (homeController.selectedFilter == 0))
          ? "recent"
          : (homeController.showIndexValue == 2 &&
                  (homeController.selectedFilter == 1))
              ? "past_week"
              : "older_than_1_month",
    });
    final token = await API().sp.read("token");
    final userId = await API().sp.read("userId");
    print(token);
    if (response.statusCode == 200) {
      managerPendingEvents = ManagerPendingEventsModel.fromJson(response.data);
      print(userId);

      getAllPendingEventsLoader(true);
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>> venue manager decline or accept event function
  RxBool checkBoxValue = false.obs;
  eventAcceptDeclineFtn({status, EventData? event}) async {
    var formData = form.FormData.fromMap({
      "event_id": event!.id,
      "status": status,
    });
    var response = await API().postApi(formData, "accept-event-request");
    if (response.statusCode == 200) {
      managerPendingEvents!.data!.data!.remove(event);
      checkBoxValue.value = false;
      bottomToast(text: response.data['message']);
      update();
      Get.back();
    }
  }

  ///>>>>>>>>>>>>>>>>>>> event manager get all pending events

  ///todo >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> counter working

  RxBool getAllMessagesLoader = true.obs;
  ChatModel? chatData;
  bool chatWaiting = false;
  getAllMessages({userId, sourceId, fullUrl}) async {
    var formData = form.FormData.fromMap({
      "user_id": userId,
      "source_id": sourceId,
    });

    var response = await API().postApi(formData, 'chats', fullUrl: fullUrl);
    if (response.statusCode == 200) {
      if (fullUrl == null) {
        chatData = ChatModel.fromJson(response.data);
      } else {
        chatData!.data!.data!
            .addAll(ChatModel.fromJson(response.data).data!.data!);
        chatData!.data!.nextPageUrl =
            ChatModel.fromJson(response.data).data!.nextPageUrl;
      }
      update();
    }
  }

// Todo >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> counter report

  reportCounter(int chatId, int index) async {
    var formData = form.FormData.fromMap({
      "chat_id": chatId,
    });
    print(chatId);

    var response = await API().postApi(formData, "flag-message");
    if (response.statusCode == 200) {
      chatData!.data!.data!.removeAt(index);
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> send message text
  final messageController = TextEditingController();
  sendMessage({receiverId, eventId}) async {
    var formData = form.FormData.fromMap({
      "receiver_id": receiverId,
      if (messageController.text.isNotEmpty) "msg": messageController.text,
      "source_id": eventId,
      if (multiPartImg.isNotEmpty) "media[]": multiPartImg
    });
    var response = await API().postApi(formData, "send-message");
    if (response.statusCode == 200) {
      MessageItem d = MessageItem.fromJson(response.data['data']);
      chatData!.data!.data!.insert(0, d);
      messageController.clear();
      multiPartImg.clear();
      mediaClass.clear();
      profilePictures.clear();

      update();
    }
  }

  List<String> weekDays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  List<bool> selectedWeekDays = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  ///todo >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> counter working
  ///
  ///
  ///
  clearController() {
    stateController.clear();
    cityController.clear();
    zipController.clear();
    venueNameController.clear();
    streetAddressController.clear();
  }

  ///
}

class ManagerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManagerController>(() => ManagerController());
  }
}
