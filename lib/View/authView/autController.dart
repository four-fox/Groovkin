import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';
import 'package:groovkin/View/bottomNavigation/settingView/allUnfollowerModel.dart';
import 'package:groovkin/View/bottomNavigation/settingView/groovkinInvitesScreen.dart';
import 'package:groovkin/firebase/notification_services.dart';
import 'package:groovkin/main.dart';
import 'package:groovkin/model/get_specific_artist_model.dart' as get_specific;
import 'package:groovkin/model/my_groovkin_model.dart' as groovkin;
import 'package:groovkin/model/notification_model.dart';
import 'package:groovkin/model/spotify_artist_genre_model.dart';
import 'package:groovkin/model/spotify_music_genre_model.dart';
import 'package:groovkin/utils/constant.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart' as form;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/CustomMultipart.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/alertmessage.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinUser/survey/surveyModel.dart';
import 'package:groovkin/View/bottomNavigation/bottomNavigation.dart';
import 'package:groovkin/View/profile/profileModel.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../model/single_ton_data.dart';
import '../../model/switch_model.dart';
import '../GroovkinManager/venueDetailsModel.dart';
import '../GroovkinUser/UserBottomView/userBottomNav.dart';

enum ChangeRole { user, organizer, manager }

class AuthController extends GetxController {
  String? accessToken;

  ///intro functionality
  final _index = 0.obs;
  RxInt indexValue = 0.obs;
  List<intro> introduction = [
    intro(
      title: "Event Attendee",
      body:
          "Groovkin is an innovative event management app designed to enhance your event experience as an attendee. Discover a wide range of events happening around you, from concerts and workshops to conferences and parties.",
      image: "assets/intro1.png",
      btnText: "Next",
    ),
    intro(
      title: "Event Organizer",
      body:
          "Groovkin provides event organizers with a comprehensive platform to plan, organize, and execute successful events. As an event organizer, you can leverage the power of Groovkin to streamline your event management process.",
      image: "assets/intro3.png",
      btnText: "Next",
    ),
    intro(
      title: "Venue Manager",
      body:
          "Groovkin offers property owners a seamless way to monetize their venues by connecting them with event organizers in need of suitable spaces. Whether you own a conference hall, a  venue.",
      image: "assets/intro2.png",
      btnText: "Get Started",
    ),
  ];

  set index(value) => _index.value = value;
  get index => _index.value;

  RxInt radioValue = 6.obs;

  ///quick survey condition Value

  RxBool hipHop = false.obs;
  RxBool soul = false.obs;
  RxBool rock = false.obs;
  RxBool african = false.obs;
  RxBool latin = false.obs;
  RxBool jazz = false.obs;
  RxBool country = false.obs;
  RxBool dance = false.obs;
  RxBool international = false.obs;

  /// quick survey of groovkin
  RxBool foodies = false.obs;
  RxBool sportFan = false.obs;
  RxBool gaming = false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final aboutController = TextEditingController();
  RxBool showPassword = true.obs;
  RxBool showConfirmPassword = true.obs;

  /// user register
  sigUp(context, {String? signUpPlatform, String? platformId}) async {
    NotificationService notificationService = NotificationService();
    String token = await notificationService.getDeviceToken();
    List imageList = [];

    if (imageBytes != null) {
      var a = multiPartingImage(imageBytes);
      imageList.add(a);
    }

    // var theme = Theme.of(context);
    var formData = form.FormData.fromMap({
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "email": emailController.text,
      "display_name": displayNameController.text,
      /*if(API().sp.read("role") == "User")*/ "birth_year": dobController.text,
      "phone_number": phoneNumController.text,
      "password": passwordController.text,
      if (referralCodeController.text.isNotEmpty)
        "referral_code": referralCodeController.text,
      if ((API().sp.read("role") == "eventManager") &&
          (companyNameController.text.isNotEmpty))
        "company_name": companyNameController.text,
      "password_confirmation": confirmPasswordController.text,
      /*if(API().sp.read("role") == "eventOrganizer" && stateController.text.isNotEmpty)*/ "select_state":
          stateController.text,
      /*if(API().sp.read("role") == "eventOrganizer" && countryController.text.isNotEmpty)*/ "country":
          countryController.text,
      "role": API().sp.read("role") == "User"
          ? "user"
          : API().sp.read("role") == "eventManager"
              ? "venue_manager"
              : "event_owner",
      "signup_platform": signUpPlatform,
      "platform_id": platformId,
      if (imageList.isNotEmpty) "image[]": imageList,
      "device_token": token,
      "about": aboutController.text,
    });
    log(formData.toString());
    var response = await API().postApi(formData, "register",
        multiPart: imageList.isNotEmpty ? true : false);
    if (response.statusCode == 200) {
      API().sp.write("socialType", signUpPlatform);
      API().sp.write("token", response.data['data']['token']);
      API().sp.write("userId", response.data['data']['user_details']['id']);
      API().sp.write("isCompleteProfile",
          response.data['data']['user_details']['is_complete_profile']);
      API().sp.write("signupPlatform",
          response.data['data']['user_details']['signup_platform']);
      // configureSDK();
      if (response.data["data"]["user_details"]["current_role"] == "user") {
        API().sp.write("currentRole", "User");
      } else if (response.data["data"]["user_details"]["current_role"] ==
          "event_owner") {
        API().sp.write("currentRole", "eventOrganizer");
      } else {
        API().sp.write("currentRole", "eventManager");
      }
      clearTextFields();
      if (response.data["data"]["user_details"]["signup_platform"] == null) {
        if (API().sp.read("role") == "User") {
          API().sp.write("isUserCreated",
              response.data['data']['user_details']['is_user_created']);
          Get.offAllNamed(Routes.welComeScreen);
        } else if (API().sp.read("role") == "eventOrganizer") {
          API().sp.write("isEventCreated",
              response.data['data']['user_details']['is_event_created']);
          Get.offAllNamed(Routes.welComeScreen);
        } else {
          Get.offAllNamed(Routes.welComeScreen);
          // Get.offAllNamed(Routes.createCompanyProfileScreen,
          //   arguments: {
          //   "updationCondition": false,
          //     "skipBtnHide": false,
          //   }
          // );
        }
      } else {
        if (response.data["data"]["user_details"]["is_complete_profile"] == 1) {
          if (API().sp.read("role") == "User") {
            API().sp.write("isUserCreated",
                response.data['data']['user_details']['is_user_created']);
            if (response.data['data']['user_details']['is_user_created'] == 0) {
              Get.offAllNamed(Routes.surveyLifeStyleScreen, arguments: {
                "update": false,
              });
            } else {
              selectUserIndexxx.value = 0;
              Get.offAllNamed(Routes.userBottomNavigationNav);
            }
          } else if (API().sp.read("role") == "eventOrganizer") {
            API().sp.write("isEventCreated",
                response.data['data']['user_details']['is_event_created']);
            Get.offAllNamed(Routes.welComeScreen);
          } else {
            Get.offAllNamed(Routes.welComeScreen);
            // Get.offAllNamed(Routes.createCompanyProfileScreen,
            //   arguments: {
            //   "updationCondition": false,
            //     "skipBtnHide": false,
            //   }
            // );
          }
        } else {
          emailController.text = API().sp.read("emailSocial");
          update();
          Get.toNamed(Routes.createProfile, arguments: {
            "socialType": API().sp.read("socialType"),
            "accessToken": API().sp.read("accessToken"),
          });
        }
      }
    }
  }

  /// login function
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  RxBool loginShowPassword = true.obs;

  login() async {
    NotificationService notificationService = NotificationService();

    var formData = {
      "email": loginEmailController.text,
      "password": loginPasswordController.text,
      "device_token": await notificationService.getDeviceToken(),
    };
    var response = await API().postApi(formData, "login");

    if (response.statusCode == 200) {
      API().sp.write("token", response.data['data']['token']);
      API().sp.write("userId", response.data['data']['user_details']['id']);
      API().sp.remove("currentRole");
      API().sp.remove("role");
      // await configureSDK();
      Future.delayed(const Duration(microseconds: 1000), () {
        // restore();
        // logInWithRevenueCat();
        // checkUserSubscriptionIsActive();
        if (response.data["data"]["user_details"]["current_role"] == "user") {
          API().sp.write("currentRole", "User");
        } else if (response.data["data"]["user_details"]["current_role"] ==
            "event_owner") {
          API().sp.write("currentRole", "eventOrganizer");
        } else if (response.data["data"]["user_details"]["current_role"] ==
            "venue_manager") {
          API().sp.write("currentRole", "eventManager");
        }

        if (response.data['data']['user_details']['active_role'] ==
            'venue_manager') {
          API().sp.write("role", 'eventManager');
        } else if (response.data['data']['user_details']['active_role'] ==
            'user') {
          API().sp.write("role", 'User');
        } else if (response.data['data']['user_details']['active_role'] ==
            "event_owner") {
          API().sp.write('role', 'eventOrganizer');
        }
        if (sp.read("role") == "User") {
          API().sp.write("isUserCreated",
              response.data['data']['user_details']['is_user_created']);
          if (response.data['data']['user_details']['is_user_created'] == 0) {
            Get.offAllNamed(Routes.surveyLifeStyleScreen, arguments: {
              "update": false,
            });
          } else {
            selectUserIndexxx.value = 0;
            Get.offAllNamed(Routes.userBottomNavigationNav);
          }
        } else {
          selectIndexxx.value = 0;
          Get.offAllNamed(Routes.bottomNavigationView,
              arguments: {"indexValue": 0});
        }
      });
    }
  }

  /// todo forgot password functionality
  final forgotPassEmailController = TextEditingController();
  forgotPassword() async {
    var formData = form.FormData.fromMap({
      "email": forgotPassEmailController.text,
    });
    var response = await API().postApi(formData, "send-password-otp");
    if (response.statusCode == 200) {
      bottomToast(text: response.data["message"].toString());
      Get.toNamed(Routes.oTPScreen);
    }
  }

  /// New Password Screen
  final newPassController = TextEditingController();
  final newConfirmPassController = TextEditingController();
  final newPassOTPController = TextEditingController();
  newPassword() async {
    var formData = form.FormData.fromMap({
      "email": forgotPassEmailController.text,
      "otp": newPassOTPController.text,
      "password": newPassController.text,
      "password_confirmation": newConfirmPassController.text,
    });
    var response = await API().postApi(formData, "reset-password");
    if (response.statusCode == 200) {
      BotToast.showText(text: "Reset Password Successfully");
      Get.offAllNamed(Routes.loginScreen);
    }
  }

  /// Roles password
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final newConfirmPasswordController = TextEditingController();
  changePassword(context, theme) async {
    var formData = form.FormData.fromMap({
      "old_password": oldPasswordController.text,
      "password": newPasswordController.text,
      "password_confirmation": newConfirmPasswordController.text,
    });
    var response = await API().postApi(formData, "change-password");
    if (response.statusCode == 200) {
      showDialog(
          barrierColor: Colors.transparent,
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertWidget(
                height: kToolbarHeight * 5,
                bgColor: true,
                container: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Image(image: AssetImage("assets/sucses.png")),
                    Text(
                      "Successfully change\nPassword",
                      textAlign: TextAlign.center,
                      style: poppinsMediumStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: theme.scaffoldBackgroundColor,
                          context: context),
                    ),
                    CustomButton(
                      borderClr: Colors.transparent,
                      color1: DynamicColor.blackClr,
                      color2: DynamicColor.blackClr,
                      widths: 120,
                      heights: 35,
                      onTap: () {
                        Get.back();
                        Get.back();
                        Get.back();
                      },
                      text: "Done",
                    ),
                  ],
                ));
          });
    }
  }

  /// todo forgot password functionality

  /// clear signUp and create profile fields
  clearTextFields() async {
    imageBytes = null;
    firstNameController.clear();
    lastNameController.clear();
    emailController.clear();
    displayNameController.clear();
    dobController.clear();
    phoneNumController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    stateController.clear();
    countryController.clear();
    referralCodeController.clear();
  }

  /// todo create profile functionality
  String initialCountry = 'NG';
  final dobController = TextEditingController();

  ///Upload Profile Pic
  String? imageBytes;
  XFile? files;
  final ImagePicker _picker = ImagePicker();
  File? profileImage;
  RxBool imageLoaders = true.obs;
  cameraImage(context, source) async {
    try {
      imageLoaders(false);
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
      imageLoaders(true);
      update();
    } catch (e) {
      imageLoaders(true);
      // BotToast.showText(text: e.toString());
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get profile
  ProfileModel? userData;
  RxBool getProfileLoader = true.obs;
  getProfile({userId}) async {
    getProfileLoader(false);
    var response = await API().getApi(url: "user-profile/$userId");
    if (response.statusCode == 200) {
      userData = ProfileModel.fromJson(response.data);
      getProfileLoader(true);
      update();
    }
  }

  profileDataBind() async {
    firstNameController.text = userData!.data!.profile!.firstName.toString();
    lastNameController.text = userData!.data!.profile!.lastName.toString();
    displayNameController.text = userData!.data!.name.toString();
    companyNameController.text =
        userData!.data!.profile!.companyName.toString();
    emailController.text = userData!.data!.email.toString();
    aboutController.text = userData!.data!.profile!.about.toString();
    dobController.text = userData!.data!.profile!.birthYear.toString();
    phoneNumController.text = userData!.data!.profile!.phoneNumber.toString();
    if (userData!.data!.profile!.selectState != null) {
      stateController.text = userData!.data!.profile!.selectState.toString();
    }
    if (userData!.data!.profile!.country != null) {
      countryController.text = userData!.data!.profile!.country.toString();
    }
    Get.toNamed(Routes.profileScreen);
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>toDo create profile functionality

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final displayNameController = TextEditingController();
  final companyNameController = TextEditingController();
  final referralCodeController = TextEditingController();
  final phoneNumController = TextEditingController();
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  String? numberAssign = "+1";

  createProfile({userId}) async {
    List imageList = [];
    if (imageBytes != null) {
      var a = multiPartingImage(imageBytes);
      imageList.add(a);
    }
    var formData = form.FormData.fromMap({
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "display_name": displayNameController.text,
      "phone_number": phoneNumController.text,
      "birth_year": dobController.text,
      "about": aboutController.text,
      if ((API().sp.read("role") == "eventManager") &&
          (companyNameController.text.isNotEmpty))
        "company_name": companyNameController.text,
      /*if(API().sp.read("role") == "User")*/ "birth_year": dobController.text,
      if (API().sp.read("role") == "eventOrganizer" &&
          stateController.text.isNotEmpty)
        "select_state": stateController.text,
      if (API().sp.read("role") == "eventOrganizer" &&
          countryController.text.isNotEmpty)
        "country": countryController.text,
      // if(API().sp.read("role") == "eventOrganizer") "company_name": "asdf",
      if (imageList.isNotEmpty) "image[]": imageList

      ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> che kala profile create kege nu da da haghai ftn d
    });
    var response = await API().postApi(formData, "update-profile/$userId");
    if (response.statusCode == 200) {
      getProfile(userId: userId);
      Get.back();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>> edit profile

  editProfile() async {
    var formData = form.FormData.fromMap({
      "firstName": firstNameController.text,
      "lastName": lastNameController.text,
      "UserName": displayNameController.text,
    });
  }

  // Todo Logout
  Future<void> logout() async {
    final repsposne = await API().postApi({}, "logout");
    if (repsposne.statusCode == 200) {
      API().sp.erase();
      API().sp.write("intro", true);
      // Get.offAllNamed(Routes.loginScreen);
      Get.offAllNamed(Routes.loginSelection);
    }
  }

  /// toDo create profile functionality

  /// todo survey functionality
  RxBool getLifeStyleLoader = true.obs;

  List<CategoryItem> musicGenre = [];
  SurveyModel? surveyData;
  getLifeStyle({surveyType, bool mygrookinHit = false}) async {
    getLifeStyleLoader(false);
    var response =
        await API().getApi(url: "show-category-with-items?type=$surveyType");
    if (response.statusCode == 200) {
      clearLists();
      surveyData = SurveyModel.fromJson(response.data);

      final EventController eventController = Get.find();
      if (eventController.eventDetail != null) {
        List musicGenreId = [];
        for (var action in eventController.eventDetail!.data!.musicGenre!) {
          musicGenreId.add(action.itemId);
        }
        for (var element in surveyData!.data!) {
          for (var ele in element.categoryItems!) {
            if (musicGenreId.contains(ele.id)) {
              element.showItems!.value = true;
              ele.selectedItem!.value = true;
              itemsList.add(ele);
            } else {
              ele.selectedItem!.value = false;
            }
          }
        }
      }
      if (mygrookinHit != true) {
        getLifeStyleLoader(true);
        update();
      }
      myGroovkinLifeStyle(myGroockingMusicListing);
    }
  }

  var musicGenereIds = [];
  var musicGenereCategoryIds = [];

  myGroovkinLifeStyle(List<groovkin.MusicGenre> data) {
    musicGenereIds.clear();
    musicCategory.clear();
    musicGenereCategoryIds.clear();

    for (var action in data) {
      musicGenereIds.add(action.id);
      for (var actions in action.categoryItems!) {
        musicGenereCategoryIds.add(actions.id);
        musicCategory.add(actions);
      }
    }

    for (var action in surveyData!.data!) {
      musicGenereIds.contains(action.id)
          ? action.showItems!.value = true
          : action.showItems!.value = false;

      for (var actions in action.categoryItems!) {
        for (var data in musicCategory) {
          musicCategory.contains(data)
              ? data.selectedItem!.value = true
              : data.selectedItem!.value = false;
        }
        musicGenereCategoryIds.contains(actions.id)
            ? actions.selectedItem!.value = true
            : actions.selectedItem!.value = false;
      }
    }

    getLifeStyleLoader(true);
    update();
  }

  List<CategoryItem> itemsList = [];

  List catTemList = [];
  surveyAddFtn({CategoryItem? items, value, SurveyObject? surveyObj}) async {
    items!.selectedItem!.value = value;
    if (value == true) {
      itemsList.add(items);
    } else {
      itemsList.remove(items);
    }

    update();
  }

  clearLists() async {
    itemsList.clear();
    catTemList.clear();
  }

  makeMethodHit({navigation}) async {
    for (var element in itemsList) {
      if (catTemList.contains(element.categoryId)) {
      } else {
        catTemList.add(element.categoryId);
      }
    }
    surveyPost(navigation: navigation);
  }

  surveyPost({navigation}) async {
    form.FormData data = form.FormData();
    int? indexVal = -1;
    for (var i = 0; i <= catTemList.length; i++) {
      if (i != catTemList.length) {
        data.fields.add(
            MapEntry('categories[$i][category_id]', catTemList[i].toString()));
      }
    }
    for (var element in surveyData!.data!) {
      if (catTemList.contains(element.id)) {
        indexVal = indexVal! + 1;
      }
      for (var a = 0; a <= element.categoryItems!.length; a++) {
        if (a != element.categoryItems!.length) {
          if (element.categoryItems![a].selectedItem!.value == true) {
            data.fields.add(MapEntry('categories[$indexVal][item_ids][]',
                element.categoryItems![a].id.toString()));
          }
        }
      }
    }

    var response = await API().postApi(data, "create-quick-survey");
    if (response.statusCode == 200) {
      clearLists();
      if (navigation == "survey") {
        Get.offAllNamed(Routes.linkYourAccountSurveyScreen);
      } else {
        API().sp.write('isUserCreated', 1);
        Get.offAllNamed(Routes.userBottomNavigationNav);
      }
    }
  }

  /// todo survey functionality

  /// todo organizer flow have services

  RxBool getAllServiceLoader = true.obs;
  List<SurveyObject> serviceListing = [];
  List myGroovkinServiceListing = [];
  List<groovkin.HardwareProvided> myGroovkingHardwareListing = [];
  List<groovkin.MusicGenre> myGroockingMusicListing = [];
  List<SurveyObject> hardwareListing = [];
  List<SurveyObject> lifeStyleListing = [];

  getAllService({type, bool mygrookinHit = false}) async {
    getAllServiceLoader(false);
    var response =
        await API().getApi(url: "show-event-with-sub-items?type=$type");
    if (response.statusCode == 200) {
      surveyData = SurveyModel.fromJson(response.data);
      if (type == "services") {
        serviceListing.clear();
        serviceList.clear();
        for (var element in surveyData!.data!) {
          serviceListing.add(element);
        }
        if (mygrookinHit == true) {
          myGroovkinListFtn(myGroovkinServiceListing);
        }
        final EventController eventController = Get.find();
        if (eventController.eventDetail != null) {
          List serviceLista = [];
          for (var action in eventController.eventDetail!.data!.services!) {
            serviceLista.add(action.eventItemId);
          }
          for (var service in serviceListing) {
            if (serviceLista.contains(service.id)) {
              service.showItems!.value = true;
              serviceList.add(service);
              // _authController.serviceAddFtn(items: service);
            }
          }
          // _eventController.checkServices();
        }
      } else if (type == "hardware_provided") {
        hardwareListing.clear();
        eventItemsList.clear();
        for (var element in surveyData!.data!) {
          hardwareListing.add(element);
        }
        if (mygrookinHit == true) {
          myGroovkinHardwareListFtn(myGroovkingHardwareListing);
        }

        final EventController eventController = Get.find();
        if (eventController.eventDetail != null) {
          List<String> temp = [];
          eventController.eventDetail!.data!.hardwareProvide
              ?.forEach((element) {
            temp.add(element.hardwareItems!.id.toString());
          });
          for (var action in hardwareListing) {
            if (temp.contains(action.name)) {
              action.showItems!.value = true;
            } else {
              action.showItems!.value = false;
            }
            for (var items in action.categoryItems!) {
              if (temp.contains(items.id.toString())) {
                items.selectedItem!.value = true;
                eventItemsList.add(items);
              } else {
                items.selectedItem!.value = false;
              }
            }
          }
        }
      } else {
        lifeStyleItemsList.clear();
        lifeStyleListing.clear();
        for (var element in surveyData!.data!) {
          lifeStyleListing.add(element);
        }
        final EventController eventController = Get.find();
        if (eventController.eventDetail != null) {
          List musicGenreId = [];
          for (var action in eventController.eventDetail!.data!.musicGenre!) {
            musicGenreId.add(action.itemId);
          }
          for (var element in surveyData!.data!) {
            for (var ele in element.categoryItems!) {
              if (musicGenreId.contains(ele.id)) {
                element.showItems!.value = true;
                ele.selectedItem!.value = true;
                itemsList.add(ele);
              } else {
                ele.selectedItem!.value = false;
              }
            }
          }
        }
      }

      if (mygrookinHit != true) {
        getAllServiceLoader(true);
        update();
      }
    }
  }

  // Todo MyGroovking List Hardware Data
  List hardwareListId = [];
  List hardwareCategoryId = [];
  List<groovkin.CategoryItem> hardwareCategory = [];
  List<groovkin.CategoryItem> musicCategory = [];
  void myGroovkinHardwareListFtn(List<groovkin.HardwareProvided> data) {
    // Clear previous lists
    hardwareListId.clear();
    hardwareCategoryId.clear();
    hardwareCategory.clear();

    for (var action in data) {
      hardwareListId.add(action.id);
      for (var actions in action.categoryItems) {
        hardwareCategoryId.add(actions.id);
        hardwareCategory.add(actions);
      }
    }

    for (var action in hardwareListing) {
      hardwareListId.contains(action.id)
          ? action.showItems!.value = true
          : action.showItems!.value = false;

      for (var actions in action.categoryItems!) {
        for (var data in hardwareCategory) {
          hardwareCategory.contains(data)
              ? data.selectedItem!.value = true
              : data.selectedItem!.value = false;
        }
        hardwareCategoryId.contains(actions.id)
            ? actions.selectedItem!.value = true
            : actions.selectedItem!.value = false;
      }
    }

    getAllServiceLoader(true);
    update();
  }

  // Todo MyGroovKin List Service Data
  List serviceLista = [];

  myGroovkinListFtn(List data) {
    serviceLista.clear();

    for (var action in data) {
      serviceLista.add(action.eventItemId);
    }

    for (var action in serviceListing) {
      serviceLista.contains(action.id)
          ? action.showItems!.value = true
          : action.showItems!.value = false;
    }
    getAllServiceLoader(true);
    update();
  }

  updateGroovkinService() async {
    form.FormData formData = form.FormData();

    for (var data in serviceLista) {
      formData.fields.add(MapEntry('service_id[]', data.toString()));
    }
    print(formData);

    var response = await API().postApi(formData, "edit-services");
    if (response.statusCode == 200) {}
  }

  Future<void> updateInsurance() async {
    form.FormData formData = form.FormData();

    formData.fields
        .add(MapEntry("is_insurance", insuranceVal.value.toString()));
    var response = await API().postApi(formData, "edit-insurance");
    if (response.statusCode == 200) {}
  }

  myGroovkingServiceToggleFuc(items) {
    items!.showItems!.value = !items.showItems!.value;
    if (items.showItems!.value == true) {
      serviceLista.add(items.id);
    } else {
      serviceLista.remove(items.id);
    }
    update();
  }

  List<SurveyObject> serviceList = [];
  serviceAddFtn({SurveyObject? items, value, SurveyObject? surveyObj}) async {
    items!.showItems!.value = !items.showItems!.value;
    if (items.showItems!.value == true) {
      serviceList.add(items);
    } else {
      serviceList.remove(items);
    }
    update();
  }

  ///organizer add hardware provided by you
  List<CategoryItem> eventItemsList = [];
  hardwareFunction(
      {SurveyObject? items, value, CategoryItem? serviceObj}) async {
    serviceObj!.selectedItem!.value = value;
    if (serviceObj.selectedItem!.value == true) {
      eventItemsList.add(serviceObj);
    } else {
      eventItemsList.remove(serviceObj);
    }
    update();
  }

  myGroovkingMusicGenerFunction(
      {CategoryItem? items, value, SurveyObject? surveyObj}) async {
    items!.selectedItem!.value = value;
    if (items.selectedItem!.value == true) {
      musicGenereCategoryIds.add(items.id);
      musicCategory.add(groovkin.CategoryItem(
        id: items.id!,
        name: items.name ?? "",
        type: items.type ?? "",
        createdAt: items.createdAt ?? "",
        updatedAt: items.updatedAt ?? "",
        categoryId: items.categoryId,
        eventId: items.eventId,
        selectedItem: RxBool(value),
      ));
    } else {
      musicGenereIds.remove(items.id);
      for (var data in musicCategory) {
        if (data.id == items.id) {
          data.selectedItem!.value = false;
        }
      }
      musicCategory.removeWhere((data) => data.id == items.id);
    }
    update();
  }

  Future myGroovkinMusicGenreUpdate() async {
    form.FormData data = form.FormData();
    int? id = -1;
    int index = -1;

    for (var i = 0; i < musicCategory.length; i++) {
      if (i != musicCategory.length) {
        if (id != musicCategory[i].categoryId) {
          index += 1;
          data.fields.add(MapEntry('music_genre[$index][music_genre_id]',
              musicCategory[i].categoryId.toString()));
        }
      }
      if (musicCategory[i].selectedItem!.value == true) {
        id = musicCategory[i].categoryId;
        data.fields.add(MapEntry('music_genre[$index][music_genre_item_ids][]',
            musicCategory[i].id.toString()));
      }
    }
    final response = await API().postApi(data, "edit-music-genre");

    if (response.statusCode == 200) {}
  }

  myGroovkinhardwareFunction(
      {SurveyObject? items, value, CategoryItem? serviceObj}) async {
    serviceObj!.selectedItem!.value = value;
    if (serviceObj.selectedItem!.value == true) {
      hardwareCategoryId.add(serviceObj.id);
      hardwareCategory.add(
        groovkin.CategoryItem(
          categoryId: serviceObj.categoryId,
          eventId: serviceObj.eventId,
          selectedItem: RxBool(value),
          id: serviceObj.id!,
          name: serviceObj.name ?? "",
          type: serviceObj.type ?? "",
          createdAt: serviceObj.createdAt ?? "",
          updatedAt: serviceObj.updatedAt ?? "",
        ),
      );
    } else {
      hardwareCategoryId.remove(
          serviceObj.id); // Update `selectedItem` to `false` before removal

      for (var data in hardwareCategory) {
        if (data.id == serviceObj.id) {
          data.selectedItem!.value = false; // Set `selectedItem` to false
        }
      }
      hardwareCategory.removeWhere((data) => data.id == serviceObj.id);
    }
    update();
  }

  Future updateGroovkinghardware() async {
    form.FormData data = form.FormData();
    int? id = -1;
    int index = -1;

    for (var i = 0; i < hardwareCategory.length; i++) {
      if (i != hardwareCategory.length) {
        if (id != hardwareCategory[i].eventId) {
          index += 1;
          data.fields.add(MapEntry('events[$index][event_id]',
              hardwareCategory[i].eventId.toString()));
        }
      }

      if (hardwareCategory[i].selectedItem!.value == true) {
        id = hardwareCategory[i].eventId;
        data.fields.add(MapEntry(
            'events[$index][item_ids][]', hardwareCategory[i].id.toString()));
      }
    }

    print(data);

    final response = await API().postApi(data, "edit-hardware-provides");

    if (response.statusCode == 200) {}
  }

  ///organizer add life style provided by you
  List<CategoryItem> lifeStyleItemsList = [];
  lifeStyleFunction(
      {SurveyObject? items, value, CategoryItem? serviceObj}) async {
    serviceObj!.selectedItem!.value = value;
    if (serviceObj.selectedItem!.value == true) {
      lifeStyleItemsList.add(serviceObj);
    } else {
      lifeStyleItemsList.remove(serviceObj);
    }
    update();
  }

  RxInt insuranceVal = 0.obs;

  createEvent() async {
    form.FormData data = form.FormData();
    List<CategoryItem> serviceListPosted = [];
    List<CategoryItem> serviceListPostedd = [];
    serviceListPosted.addAll(eventItemsList);
    serviceListPostedd.addAll(itemsList);
    int? indexVal = -1;
    for (var i = 0; i <= serviceList.length; i++) {
      if (i != serviceList.length) {
        data.fields
            .add(MapEntry('service_id[$i]', serviceList[i].id.toString()));
      }
    }

    // int? indexVals = -1;
    // print(eventItemsList.length);
    // for (var i = 0; i <= eventItemsList.length; i++) {
    //   if (i != eventItemsList.length) {
    //     indexVals = indexVals! + 1;
    //     if (eventItemsList[i].selectedItem!.value == true) {
    //       data.fields.add(MapEntry(
    //           'events[$indexVals][item_ids]', eventItemsList[i].id.toString()));
    //     }
    //   }
    // }
    //
    // int? itemIndex = -1;
    // for (var i = 0; i < itemsList.length; i++) {
    //   if (i != itemsList.length) {
    //     itemIndex = itemIndex! + 1;
    //     if (itemsList[i].selectedItem!.value == true) {
    //       data.fields.add(MapEntry(
    //           "music_genre[$itemIndex][${itemsList[i].id}]",
    //           itemsList[i].id.toString()));
    //     }
    //   }
    // }

    data.fields.add(MapEntry('is_insurance', insuranceVal.value.toString()));

    int? iiid = -1;
    for (var a = 0; a <= serviceListPosted.length; a++) {
      if (a != serviceListPosted.length) {
        if (iiid != serviceListPosted[a].eventId) {
          indexVal = indexVal! + 1;
          data.fields.add(MapEntry('events[$indexVal][event_id]',
              serviceListPosted[a].eventId.toString()));
        }
        if (serviceListPosted[a].selectedItem!.value == true) {
          iiid = serviceListPosted[a].eventId;
          data.fields.add(MapEntry('events[$indexVal][item_ids][]',
              serviceListPosted[a].id.toString()));
        }
      }
    }

    int? indexVal2 = -1;
    int? iiidd = -1;
    for (var a = 0; a <= serviceListPostedd.length; a++) {
      if (a != serviceListPostedd.length) {
        if (iiidd != serviceListPostedd[a].categoryId) {
          indexVal2 = indexVal2! + 1;
          data.fields.add(MapEntry('music_genre[$indexVal2][music_genre_id]',
              serviceListPostedd[a].categoryId.toString()));
        }
        if (serviceListPostedd[a].selectedItem!.value == true) {
          iiidd = serviceListPostedd[a].categoryId;
          data.fields.add(MapEntry(
              'music_genre[$indexVal2][music_genre_item_ids][]',
              serviceListPostedd[a].id.toString()));
        }
      }
    }

    // print(data);

    var response = await API().postApi(data, "add-event");
    if (response.statusCode == 200) {
      bottomToast(text: response.data['message']);
      API().sp.write("isEventCreated", 1);
      selectIndexxx.value = 0;
      Get.offAllNamed(
        Routes.bottomNavigationView,
        arguments: {"indexValue": 0},
      );
    }
  }

  // todo organizer flow have services

  // todo Change Role
  ChangeRole? changeRole;
  RxBool switchProfileLoader = false.obs;

  changeRoles(ChangeRole changeRole) async {
    this.changeRole = changeRole;
    switchProfile();
    update();
  }

  String checkUserRole(ChangeRole changeRole) {
    switch (changeRole) {
      case ChangeRole.user:
        return "user";
      case ChangeRole.manager:
        return "venue_manager";
      case ChangeRole.organizer:
        return "event_owner";
    }
  }

  switchProfile() async {
    String userType = checkUserRole(changeRole!);
    print(userType);
    var formData = form.FormData.fromMap({"role": userType});
    final response = await API().postApi(formData, "switch-profile");
    if (response.statusCode == 200) {
      final data = SwitchProfile.fromJson(response.data);
      print("Token:${data.data!.token}");
      API().sp.write("token", data.data!.token);
      API().sp.write("userId", data.data!.profile!.userId);
      String userTypeInital = await API().sp.read("role");
      print(userTypeInital);
      if (userType == "event_owner") {
        if (data.data!.isEventCreated == 0) {
          API().sp.write('role', 'eventOrganizer');
          Get.offAllNamed(Routes.welComeScreen, arguments: {
            "userType": userTypeInital,
          });
        } else {
          API().sp.write('role', 'eventOrganizer');
          selectIndexxx.value = 0;
          Get.offAllNamed(Routes.bottomNavigationView);
        }
      } else if (userType == "venue_manager") {
        // if (data.data!.isManagerCreated == 0) {
        //   API().sp.write("role", 'eventManager');
        //   Get.offAllNamed(Routes.welComeScreen, arguments: {
        //     "userType": userTypeInital,
        //   });
        // } else {
        //   API().sp.write("role", 'eventManager');
        //   selectIndexxx.value = 0;
        //   Get.offAllNamed(Routes.bottomNavigationView);
        // }
        API().sp.write("role", 'eventManager');
        selectIndexxx.value = 0;
        Get.offAllNamed(Routes.bottomNavigationView);
      } else {
        if (data.data!.isUserCreated == 0) {
          API().sp.write("role", 'User');
          Get.offAllNamed(Routes.welComeScreen, arguments: {
            "userType": userTypeInital,
          });
        } else {
          API().sp.write("role", 'User');
          selectUserIndexxx.value = 0;
          Get.offAllNamed(Routes.userBottomNavigationNav);
        }
      }
    }
  }

  // Todo Delete Account

  deleteAccount() async {
    int userId = await API().sp.read("userId");
    final response = await API().postApi({}, "delete-account/$userId");
    if (response.statusCode == 200) {
      await API().sp.erase();
      await API().sp.write("intro", true);
      Get.offAllNamed(Routes.loginScreen);
    }
  }

  // Todo Report

  Future reportAccount(
      {required String type, required int sourceId, String? message}) async {
    try {
      var formData = form.FormData.fromMap({
        "type": type,
        "source_id": sourceId,
        if (message != null) "reason": message,
      });
      final response = await API().postApi(formData, "report");
      if (response.statusCode == 200) {
        BotToast.showText(
          text: "Report has been Send",
          contentColor: Colors.black,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  RxBool sendingEmailLoader = true.obs;
  List<UserClass> invitationList = [];

  sendEmail(BuildContext context) async {
    sendingEmailLoader.value = false;
    update();

    if (sendingEmailLoader.value == false) {
      showLoading();
    }

    List eventInvitation = [];
    for (var action in invitationList) {
      eventInvitation.add(action.emailController.text);
    }
    String username = 'william@gologonow.com'; // Your Email

    String password =
        'ppqcxmrssiezdyrh'; // 16 Digits App Password Generated From Google Account

    final smtpServer = gmail(username, password);

    // Create our message.
    final message = Message()
      ..from = const Address(
        'william@gologonow',
        'Groovkin',
      )
      ..recipients = eventInvitation
      ..subject = 'Event Invitation  | Groovkin'
      ..text = 'Event Invitation users';

    try {
      sendingEmailLoader.value = false;
      // final sendReport =
      await send(message, smtpServer);
      invitationList.clear();
      Get.offNamed(Routes.sendInvitationScreen);
      sendingEmailLoader.value = true;
      update();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Mail Send Successfully")));
      }
    } on MailerException catch (e) {
      sendingEmailLoader.value = true;
      print('Message not sent.');
      print(e.message);
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  /// following and unfollow
  RxBool getAllUnfollowingLoader = true.obs;
  AllUnFollowUserModel? allUnFollower;
  bool getAllUnfollowingWait = false;
  TextEditingController allFollowUserController = TextEditingController();

  getAllUnfollowing({nextUrl}) async {
    getAllUnfollowingLoader(false);
    var response = await API()
        .getApi(url: "nonfollowed", fullUrl: nextUrl, queryParameters: {
      "search": allFollowUserController.text,
    });

    if (response.statusCode == 200) {
      if (nextUrl == null) {
        allUnFollower = AllUnFollowUserModel.fromJson(response.data);
        getAllUnfollowingWait = false;
      } else {
        allUnFollower!.data!.data!
            .addAll(AllUnFollowUserModel.fromJson(response.data).data!.data!);
        allUnFollower!.data!.nextPageUrl =
            AllUnFollowUserModel.fromJson(response.data).data!.nextPageUrl;
        getAllUnfollowingWait = false;
      }
      getAllUnfollowingLoader(true);
      update();
    }
  }

  ///follow user
  RxBool followingLoader = true.obs;
  followUser({User? userData, bool fromAllUser = true}) async {
    followingLoader(false);
    var formData = form.FormData.fromMap({
      "follower_id": userData!.id,
      "type": userData.role.toString(),
    });
    var response = await API().postApi(formData, "follow");
    if (response.statusCode == 200) {
      if (fromAllUser == true) {
        allUnFollower!.data!.data!.remove(userData);
      } else {
        userData.following = Following(
          id: -12,
          userId: -2,
          followerId: -12,
          type: "",
          status: "",
          createdAt: "",
          updatedAt: "",
        );
      }
      followingLoader(true);
      update();
    }
  }

  /// >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> unfollow
  unfollow({User? userData, bool fromAllUser = true}) async {
    followingLoader(false);
    var formData = form.FormData.fromMap({"follower_id": userData!.id});
    var response = await API().postApi(formData, "unfollow");
    if (response.statusCode == 200) {
      if (fromAllUser == true) {
        allUnFollower!.data!.data!.remove(userData);
      } else {
        userData.following = null;
      }
      followingLoader(true);
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get all follower
  RxBool getAllFollowersLoader = true.obs;
  getAllFollowers({type}) async {
    getAllFollowersLoader(false);
    var response = await API().getApi(url: "followers?type=$type");
    if (response.statusCode == 200) {
      getAllFollowersLoader(true);
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get all followings
  bool getAllFollowersWait = false;
  getAllFollowings({nextUrl, userType, apiHit = "Followings"}) async {
    if (nextUrl == null) {
      getAllUnfollowingLoader(false);
    } else {
      nextUrl = "$nextUrl&type=$userType";
    }
    var response = apiHit == "Followings"
        ? await API().getApi(
            url: "followings?type=$userType",
            fullUrl: nextUrl,
            isLoader: nextUrl != null ? false : true)
        : await API().getApi(
            url: "followers?type=$userType",
            fullUrl: nextUrl,
            isLoader: nextUrl != null ? false : true);
    if (response.statusCode == 200) {
      if (nextUrl == null) {
        allUnFollower = AllUnFollowUserModel.fromJson(response.data);
        getAllFollowersWait = false;
      } else {
        allUnFollower!.data!.data!
            .addAll(AllUnFollowUserModel.fromJson(response.data).data!.data!);
        allUnFollower!.data!.nextPageUrl =
            AllUnFollowUserModel.fromJson(response.data).data!.nextPageUrl;
        getAllFollowersWait = false;
      }
      getAllUnfollowingLoader(true);
      update();
    }
  }

  // Todo Get Notificaion
  RxInt page = 1.obs;
  RxBool isNotificationLoading = false.obs;
  bool notificationWait = false;

  changePage(int pageNumber) {
    page.value = pageNumber;
  }

  NotificationModel? notificationModel;

  Future<dynamic> getAllNotification(
      {fullUrl, String url = 'notifications'}) async {
    isNotificationLoading.value = true; // Start loading
    final response = await API().getApi(url: "notifications", fullUrl: fullUrl);
    if (response.statusCode == 200) {
      if (fullUrl == null) {
        notificationModel = NotificationModel.fromJson(response.data);
      } else {
        notificationModel!.data!.datas!
            .addAll(NotificationModel.fromJson(response.data).data!.datas!);
        notificationModel!.data!.nextPageUrl =
            NotificationModel.fromJson(response.data).data!.nextPageUrl;
        notificationWait = false;
      }
    }
    isNotificationLoading.value = false; // Stop loading
    update();
  }

  // Todo Social Sign IN

  Future<dynamic> googleSignIn() async {
    try {
      EasyLoading.show();
      GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();

      if (googleSignInAccount == null) {
        EasyLoading.dismiss();
        return null;
      }

      GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final firebase_auth.UserCredential userCredential = await firebase_auth
          .FirebaseAuth.instance
          .signInWithCredential(credential);
      if (userCredential.user != null) {
        emailController.text = userCredential.user!.email ?? "";
        displayNameController.text = userCredential.user!.displayName ?? "";
        API().sp.write("emailSocial", userCredential.user!.email ?? "");
        API().sp.write("nameSocial", userCredential.user!.displayName ?? "");
        API().sp.write("accessToken", userCredential.credential!.accessToken);
        sigUp(
          Get.context,
          signUpPlatform: "google",
          platformId: userCredential.credential!.accessToken,
        );
      }
      log(userCredential.toString());
    } catch (e) {
      print(e.toString());
      EasyLoading.dismiss();
    } finally {
      EasyLoading.dismiss();
    }
  }

  // Todo Apple Sign In
  Future<dynamic> appleSignIn() async {
    try {
      EasyLoading.show();

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final firebase_auth.OAuthCredential authCredential =
          firebase_auth.OAuthProvider("apple.com").credential(
        accessToken: credential.authorizationCode,
        idToken: credential.identityToken,
      );

      final firebase_auth.UserCredential userCredential = await firebase_auth
          .FirebaseAuth.instance
          .signInWithCredential(authCredential);
      if (kDebugMode) {
        print(userCredential);
      }
      if (userCredential.user != null) {
        emailController.text = userCredential.user!.email!;
        API().sp.write("emailSocial", userCredential.user!.email!);
        // API().sp.write("nameSocial", userCredential.user!.displayName!);
        API().sp.write("accessToken", userCredential.credential!.accessToken);
        sigUp(
          Get.context,
          signUpPlatform: "apple",
          platformId: userCredential.credential!.accessToken,
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
    } finally {
      EasyLoading.dismiss();
    }
    // userCredential.credential
  }

  /// Spotify & ITUNES Genre API
  SpotifyMusicGenre? spotifyMusicGenre;
  RxBool isSpotify = false.obs;
  Future<dynamic> getSpotifyMusicGenreAPI() async {
    isSpotify(true);
    final response = await API().getApi(
        fullUrl:
            "https://itunes.apple.com/search?term=music&entity=album&limit=1000");
    if (response.statusCode == 200) {
      spotifyMusicGenre = SpotifyMusicGenre.fromJson(jsonDecode(response.data));
      isSpotify(false);
      update();
    }
    isSpotify(false);
    update();
  }

// Get Spotify Artist Genre
  SpotifyArtistGenreModel? spotifyArtistGenreModel;
  RxBool isArtistLoading = false.obs;
  set setIsArtistLoading(bool loading) {
    isArtistLoading.value = loading;
    update();
  }

  List<dynamic> filteredGenres = [];
  Future<dynamic> getSpotifyArtistGenre() async {
    setIsArtistLoading = true;
    try {
      final response = await API().getApi(
        fullUrl: "https://api.spotify.com/v1/me/top/artists",
        isFromSpotify: true,
      );
      if (response.statusCode == 200) {
        spotifyArtistGenreModel =
            SpotifyArtistGenreModel.fromJson(response.data);
        if (spotifyArtistGenreModel!.items!.isNotEmpty) {
          filteredGenres.clear();
          final Set<String> seenGenres = {};
          for (var item in spotifyArtistGenreModel!.items!) {
            for (var genre in item.genres!) {
              if (!seenGenres.contains(genre)) {
                seenGenres.add(genre);
                filteredGenres.add({
                  'name': genre,
                  'selected': false.obs, // make it observable
                });
              }
            }
          }
          update();
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      setIsArtistLoading = false;
    }
  }

  RxBool addArtistLoading = false.obs;
  set setAddArtistLoading(bool loading) {
    addArtistLoading.value = loading;
    update();
  }

  Future<dynamic> addSpotifyArtistGenre() async {
    try {
      setAddArtistLoading = true;
      final formData = form.FormData();
      for (var genre in filteredGenres) {
        if (genre['selected'].value == true) {
          formData.fields.add(MapEntry('music_genre[]', genre['name']));
        }
      }
      formData.fields.add(const MapEntry("type", "spotify"));

      final response = await API().postApi(formData, "add-music-genre");
      if (response.statusCode == 200) {
        Get.offAllNamed(
          Routes.userBottomNavigationNav,
          // arguments: {
          //   "indexValue": 0
          // }
        );
        BotToast.showText(
          text: "Genre Add Succesfully!",
          contentColor: Colors.black,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  get_specific.GetSpecificArtistGenre? getSpecificArtistGenreModel;
  RxBool isSpecificArtistLoading = false.obs;
  set setSpecificArtistLoading(bool loading) {
    isSpecificArtistLoading.value = loading;
    update();
  }

  Future<dynamic> getSpecificArtistGenre({fullUrl}) async {
    setSpecificArtistLoading = true;
    try {
      final resposne = await API()
          .getApi(url: "get-music-genre", fullUrl: fullUrl, queryParameters: {
        "type": "spotify",
      });

      if (resposne.statusCode == 200) {
        if (fullUrl == null) {
          getSpecificArtistGenreModel =
              get_specific.GetSpecificArtistGenre.fromJson(resposne.data);
        } else {
          getSpecificArtistGenreModel!.data!.data!.addAll(
              get_specific.GetSpecificArtistGenre.fromJson(resposne.data)
                  .data!
                  .data!);
          getSpecificArtistGenreModel!.data!.nextPageUrl =
              get_specific.GetSpecificArtistGenre.fromJson(resposne.data)
                  .data!
                  .nextPageUrl;
        }
        update();
      }
    } catch (e) {
      rethrow;
    } finally {
      setSpecificArtistLoading = false;
    }
  }

  /// Subsction Work  By Revenue Cat

  RxInt selected = 0.obs;

  logInWithRevenueCat() async {
    try {
      final loginResult =
          await Purchases.logIn(API().sp.read("userId").toString());
      // Optionally check if anonymous user was merged
      if (loginResult.created) {
        print("New user created in RevenueCat");
      } else {
        print("Existing user logged in");
      }
    } on PlatformException catch (e) {
      BotToast.showText(
        text: e.message ?? "Unknown error",
      );
    }
  }

  completePurchase(CustomerInfo purchaseDetails) async {
    print(purchaseDetails);
    print(purchaseDetails.entitlements.active["premium"]?.productIdentifier);
    await sp.write("identifier",
        purchaseDetails.entitlements.active["premium"]?.productIdentifier);
    final productId = purchaseDetails.entitlements.active["productIdentifier"];
    // final productId = entitlement?.productIdentifier;
    // Determine plan type
    int planType = 0;
    if (productId?.productIdentifier.toLowerCase().contains("monthly") ==
        true) {
      planType = 1;
    } else if (productId?.productIdentifier.toLowerCase().contains("yearly") ==
        true) {
      planType = 2;
    }

    Purchases.logIn(purchaseDetails.originalAppUserId);
    final data = form.FormData();
    data.fields.add(MapEntry("id", planType.toString()));
    final response = await API().postApi(data, "subscription");
    if (response.statusCode == 200) {
      BotToast.showText(text: "Subscription Purchased");
    }
  }

  restore() async {
    try {
      BotToast.showLoading();
      if (API().sp.read("userId") != null) {
        try {
          Purchases.logIn(API().sp.read("userId").toString()).then(
            (value) async {
              if (value.customerInfo.entitlements.all[entitlementID] != null) {
                if (value.customerInfo.entitlements.all[entitlementID]!
                        .isActive ==
                    true) {
                  await Purchases.restorePurchases();
                  if (kDebugMode) {
                    log("Restore Purchased!");
                  }
                  final time = DateTime.parse(value.customerInfo.entitlements
                          .all[entitlementID]!.expirationDate!)
                      .toLocal()
                      .difference(DateTime.now().toLocal())
                      .inMinutes;

                  if (time >= 0) {
                    BotToast.closeAllLoading();
                    // checkSub("Subscription Is Not Expired!");
                  } else {
                    checkSub("Subscription expired");
                  }
                } else {
                  checkSub("No Active Subscription");
                }
              } else {
                checkSub("No Active Subscription");
              }
            },
          ).onError(
            (error, stackTrace) {
              BotToast.closeAllLoading();
            },
          );
        } catch (e) {
          BotToast.closeAllLoading();
        }
        // checkUserSubscriptionIsActive();
      }
      BotToast.closeAllLoading();
    } on PlatformException catch (e) {
      BotToast.closeAllLoading();
    }
  }

  checkSub(String text) {
    BotToast.closeAllLoading();
    BotToast.showText(
      text: text,
    );
  }

  logOutRevenuecat() async {
    try {
      await Purchases.logOut();
      appData.appUserID = await Purchases.appUserID;
    } on PlatformException catch (e) {
      print(e);
      // BotToast.showText(
      //   text: e.message ?? "Unknown error",
      // );
    }
  }
}

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}

class intro {
  final image, title, body, btnText;

  intro({this.image, this.title, this.body, this.btnText});
}
