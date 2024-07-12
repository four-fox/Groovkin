import 'dart:io';
import 'package:groovkin/View/bottomNavigation/settingView/groovkinInvitesScreen.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart' as form;
import 'package:flutter/cupertino.dart';
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

class AuthController extends GetxController{
  ///intro functionality
  final _index = 0.obs;
  RxInt indexValue = 0.obs;
  List<intro> introduction = [
    intro(
      title: "Event Attendee",
      body: "Groovkin is an innovative event management app designed to enhance your event experience as an attendee. Discover a wide range of events happening around you, from concerts and workshops to conferences and parties.",
      image: "assets/intro1.png",
      btnText: "Next",
    ),
    intro(
      title: "Event Organizer",
      body: "Groovkin provides event organizers with a comprehensive platform to plan, organize, and execute successful events. As an event organizer, you can leverage the power of Groovkin to streamline your event management process.",
      image: "assets/intro3.png",
      btnText: "Next",

    ),
    intro(
      title: "Venue Manager",
      body: "Groovkin offers property owners a seamless way to monetize their venues by connecting them with event organizers in need of suitable spaces. Whether you own a conference hall, a  venue.",
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
  RxBool foodies= false.obs;
  RxBool sportFan= false.obs;
  RxBool gaming= false.obs;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final aboutController = TextEditingController();
  RxBool showPassword = true.obs;
  RxBool showConfirmPassword = true.obs;

  /// user register
  sigUp(context) async{
    List imageList = [];
    if(imageBytes != null){
      var a = multiPartingImage(imageBytes);
      imageList.add(a);
    }
    // var theme = Theme.of(context);
    var formData = form.FormData.fromMap({
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "email": emailController.text,
      "display_name": displayNameController.text,
     if(API().sp.read("role") == "User") "birth_year": dobController.text,
      "phone_number": phoneNumController.text,
      "password": passwordController.text,
      "password_confirmation": confirmPasswordController.text,
     if(API().sp.read("role") == "eventOrganizer" && stateController.text.isNotEmpty) "select_state": stateController.text,
      if(API().sp.read("role") == "eventOrganizer" && countryController.text.isNotEmpty) "country": countryController.text,
      "role": API().sp.read("role")=="User"?"user":API().sp.read("role") == "eventManager"?"venue_manager":"event_owner",
     if(imageList.isNotEmpty) "image[]": imageList,
      "device_token": "jkhkjhkjhkjhasd",
      "about": aboutController.text,
    });
    var response = await API().postApi(formData, "register",multiPart:imageList.isNotEmpty?true: false);
    if(response.statusCode == 200){
      API().sp.write("token", response.data['data']['token']);
      API().sp.write("userId", response.data['data']['user_details']['id']);
      clearTextFields();
      if(API().sp.read("role")=="User"){
      API().sp.write("isUserCreated", response.data['data']['user_details']['is_user_created']);
      Get.offAllNamed(Routes.welComeScreen);
      }else if(API().sp.read("role")=="eventOrganizer"){
        API().sp.write("isEventCreated", response.data['data']['user_details']['is_event_created']);
        Get.offAllNamed(Routes.welComeScreen);
      }else{
        Get.offAllNamed(Routes.welComeScreen);
        // Get.offAllNamed(Routes.createCompanyProfileScreen,
        //   arguments: {
        //   "updationCondition": false,
        //     "skipBtnHide": false,
        //   }
        // );
      }
    }
  }

  /// login function
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  RxBool loginShowPassword = true.obs;
  login() async{
    var formData = {
      "email": loginEmailController.text,
      "password": loginPasswordController.text,
    };
    var response = await API().postApi(formData, "login");
    if(response.statusCode == 200){
      API().sp.write("token", response.data['data']['token']);
      API().sp.write("userId", response.data['data']['user_details']['id']);
      if(response.data['data']['user_details']['roles'][0]['name'] == 'venue_manager'){
        API().sp.write("role", 'eventManager');
      }else if (response.data['data']['user_details']['roles'][0]['name'] == 'user'){
        API().sp.write("role", 'User');
      }else{
        API().sp.write('role', 'eventOrganizer');
      }
      if(sp.read("role") == "User"){
        API().sp.write("isUserCreated", response.data['data']['user_details']['is_user_created']);
        if(response.data['data']['user_details']['is_user_created'] == 0){
          Get.offAllNamed(Routes.surveyLifeStyleScreen,
              arguments: {
                "update": false,
              }
          );
        }else{
          selectIndexxx.value = 0;
          Get.offAllNamed(Routes.userBottomNavigationNav);
        }
      }else{
        selectIndexxx.value = 0;
        Get.offAllNamed(Routes.bottomNavigationView, arguments: {"indexValue": 0});
      }
    }
  }

  /// todo forgot password functionality
  final forgotPassEmailController = TextEditingController();
  forgotPassword() async{
    var formData = form.FormData.fromMap({
      "email": forgotPassEmailController.text,
    });
    var response = await API().postApi(formData, "send-password-otp");
    if(response.statusCode == 200){
      bottomToast(text: response.data["message"].toString());
      Get.toNamed(Routes.oTPScreen);
    }
  }

  /// New Password Screen
  final newPassController = TextEditingController();
  final newConfirmPassController = TextEditingController();
  final newPassOTPController = TextEditingController();
  newPassword() async{
    var formData = form.FormData.fromMap({
      "email": forgotPassEmailController.text,
      "otp": newPassOTPController.text,
      "password": newPassController.text,
      "password_confirmation": newConfirmPassController.text,
    });
    var response = await API().postApi(formData, "reset-password");
    if(response.statusCode == 200){
      BotToast.showText(text: "Reset Password Successfully");
      Get.offAllNamed(Routes.loginScreen);
    }
  }

  /// change password
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final newConfirmPasswordController = TextEditingController();
  changePassword(context,theme) async{
    var formData = form.FormData.fromMap({
      "old_password": oldPasswordController.text,
      "password": newPasswordController.text,
      "password_confirmation": newConfirmPasswordController.text,
    });
    var response = await API().postApi(formData, "change-password");
    if(response.statusCode == 200){
      showDialog(
          barrierColor: Colors.transparent,
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertWidget(
                height: kToolbarHeight*5,
                bgColor: true,
                container: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image(image: AssetImage("assets/sucses.png")),
                    Text("Successfully change\nPassword",
                      textAlign: TextAlign.center,
                      style: poppinsMediumStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: theme.scaffoldBackgroundColor,
                          context: context
                      ),
                    ),
                    CustomButton(
                      borderClr: Colors.transparent,
                      color1: DynamicColor.blackClr,
                      color2: DynamicColor.blackClr,
                      widths: 120,
                      heights: 35,
                      onTap: (){
                        Get.back();
                        Get.back();
                        Get.back();
                      },
                      text: "Done",
                    ),
                  ],
                )
            );
          });
    }
  }

  /// todo forgot password functionality

  /// clear signUp and create profile fields
  clearTextFields() async{
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
  cameraImage(context,source) async{
    try {
      imageLoaders(false);
      files = await _picker.pickImage(
          source: source,
          imageQuality: 50,
          maxHeight: 1920,
          maxWidth: 1080);
      CroppedFile? file = await ImageCropper().cropImage(
          sourcePath: files!.path);
      if (files != null) {
        if(file != null){
          imageBytes = file.path;
        }else{
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
  getProfile({userId}) async{
    getProfileLoader(false);
    var response = await API().getApi(url: "user-profile/$userId");
    if(response.statusCode == 200){
       userData = ProfileModel.fromJson(response.data);
      getProfileLoader(true);
      update();
    }
  }

  profileDataBind() async{
    firstNameController.text = userData!.data!.profile!.firstName.toString();
    lastNameController.text = userData!.data!.profile!.lastName.toString();
    lastNameController.text = userData!.data!.profile!.lastName.toString();
    displayNameController.text = userData!.data!.name.toString();
    emailController.text = userData!.data!.email.toString();
    aboutController.text = userData!.data!.profile!.about.toString();
    dobController.text = userData!.data!.profile!.birthYear.toString();
    phoneNumController.text = userData!.data!.profile!.phoneNumber.toString();
    if(userData!.data!.profile!.selectState != null){
      stateController.text = userData!.data!.profile!.selectState.toString();
    }
    if(userData!.data!.profile!.country != null){
      countryController.text = userData!.data!.profile!.country.toString();
    }
    Get.toNamed(Routes.profileScreen);
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>toDo create profile functionality
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final displayNameController = TextEditingController();
  final phoneNumController = TextEditingController();
  final countryController = TextEditingController();
  final stateController = TextEditingController();
  String? numberAssign = "+1";
  createProfile({userId}) async{
    List imageList = [];
    if(imageBytes != null){
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
      if(API().sp.read("role") == "User") "birth_year": dobController.text,
      if(API().sp.read("role") == "eventOrganizer" && stateController.text.isNotEmpty) "select_state": stateController.text,
      if(API().sp.read("role") == "eventOrganizer" && countryController.text.isNotEmpty) "country": countryController.text,
      // if(API().sp.read("role") == "eventOrganizer") "company_name": "asdf",
      if(imageList.isNotEmpty)"image[]": imageList
      ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> che kala profile create kege nu da da haghai ftn d
    });
    var response = await API().postApi(formData, "update-profile/$userId");
    if(response.statusCode == 200){
      getProfile(userId: userId);
      Get.back();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>> edit profile
  editProfile() async{
    var formData = form.FormData.fromMap({
      "firstName": firstNameController.text,
      "lastName": lastNameController.text,
      "UserName": displayNameController.text,
    });
  }
  /// toDo create profile functionality

  /// todo survey functionality
  RxBool getLifeStyleLoader = true.obs;
  SurveyModel? surveyData;
  getLifeStyle({surveyType}) async {
    getLifeStyleLoader(false);
    var response = await API().getApi(url: "show-category-with-items?type=$surveyType");
    if(response.statusCode == 200){
      clearLists();
      surveyData = SurveyModel.fromJson(response.data);
      getLifeStyleLoader(true);
      update();
    }
  }

  List<CategoryItem> itemsList = [];

  List catTemList = [];
  surveyAddFtn({CategoryItem? items,value,SurveyObject? surveyObj}) async{
    items!.selectedItem!.value = value;
    if(value == true){
      itemsList.add(items);
    }else{
      itemsList.remove(items);
    }
    update();
  }

  clearLists() async{
    itemsList.clear();
    catTemList.clear();
  }
  
  makeMethodHit({navigation}) async {
    for (var element in itemsList) {
      if(catTemList.contains(element.categoryId)){
      }else{
        catTemList.add(element.categoryId);
      }
    }
    surveyPost(navigation: navigation);
    print(catTemList);
    print("catTemList");
  }



  surveyPost({navigation}) async{
    form.FormData data = form.FormData();
    int? indexVal = -1;
    for(var i = 0; i <= catTemList.length; i++){
      if(i != catTemList.length){
        data.fields.add(MapEntry('categories[$i][category_id]', catTemList[i].toString()));
      }
    }
    for (var element in surveyData!.data!) {
      if(catTemList.contains(element.id)){
        indexVal = indexVal! + 1;
      }
      for(var a = 0; a <= element.categoryItems!.length; a++){
        if(a != element.categoryItems!.length){
          if(element.categoryItems![a].selectedItem!.value == true){
            data.fields.add(MapEntry('categories[$indexVal][item_ids][]', element.categoryItems![a].id.toString()));
          }
        }
      }
    }
    print(data.fields);
    var response = await API().postApi(data, "create-quick-survey");
    if(response.statusCode == 200){
      clearLists();
      if(navigation == "survey"){
        Get.offAllNamed(Routes.linkYourAccountSurveyScreen);
      }else{
        API().sp.write('isUserCreated', 1);
        Get.offAllNamed(Routes.userBottomNavigationNav);
      }
    }
  }

  /// todo survey functionality


  /// todo organizer flow have services

  RxBool getAllServiceLoader = true.obs;
  List<SurveyObject> serviceListing = [];
  List<SurveyObject> hardwareListing = [];
  List<SurveyObject> lifeStyleListing = [];
  getAllService({type}) async{
    getAllServiceLoader(false);
    var response = await API().getApi(url: "show-event-with-sub-items?type=$type");
    if(response.statusCode ==200){
      surveyData = SurveyModel.fromJson(response.data);
      if(type == "services"){
        serviceListing.clear();
        serviceList.clear();
        for (var element in surveyData!.data!) {
          serviceListing.add(element);
        }
      }else if(type == "hardware_provided"){
        hardwareListing.clear();
        eventItemsList.clear();
        for (var element in surveyData!.data!) {
          hardwareListing.add(element);
        }
      }else{
        lifeStyleItemsList.clear();
        lifeStyleListing.clear();
        for (var element in surveyData!.data!) {
          lifeStyleListing.add(element);
        }
      }
      getAllServiceLoader(true);
      update();
    }
  }

  List<SurveyObject> serviceList = [];
  serviceAddFtn({SurveyObject? items, value, SurveyObject? surveyObj}) async{
    items!.showItems!.value = !items.showItems!.value;
    if(items.showItems!.value == true){
      serviceList.add(items);
    }else{
      serviceList.remove(items);
    }
    update();
  }

  ///organizer add hardware provided by you
  List<CategoryItem> eventItemsList = [];
  hardwareFunction({SurveyObject? items, value, CategoryItem? serviceObj}) async{
    serviceObj!.selectedItem!.value = value;
    if(serviceObj.selectedItem!.value == true){
      eventItemsList.add(serviceObj);
    }else{
      eventItemsList.remove(serviceObj);
    }
    update();
  }

  ///organizer add life style provided by you
  List<CategoryItem> lifeStyleItemsList = [];
  lifeStyleFunction({SurveyObject? items, value, CategoryItem? serviceObj}) async{
    serviceObj!.selectedItem!.value = value;
    if(serviceObj.selectedItem!.value == true){
      lifeStyleItemsList.add(serviceObj);
    }else{
      lifeStyleItemsList.remove(serviceObj);
    }
    update();
  }



  RxInt insuranceVal = 0.obs;

  createEvent() async{
    form.FormData data = form.FormData();
    List<CategoryItem> serviceListPosted = [];
    serviceListPosted.addAll(eventItemsList);
    serviceListPosted.addAll(itemsList);
    int? indexVal = -1;
    for(var i = 0; i <= serviceList.length; i++){
      if(i != serviceList.length){
        data.fields.add(MapEntry('service_id[$i]', serviceList[i].id.toString()));
      }
    }
    data.fields.add(MapEntry('is_insurance', insuranceVal.value.toString()));
    int? iiid = -1;
    for(var a = 0; a <= serviceListPosted.length; a++){
      if(a != serviceListPosted.length){
        if(iiid != serviceListPosted[a].eventId){
          indexVal = indexVal! + 1;
          data.fields.add(MapEntry('events[$indexVal][event_id]', serviceListPosted[a].eventId.toString()));
        }
        if(serviceListPosted[a].selectedItem!.value == true){
          iiid = serviceListPosted[a].eventId;
          data.fields.add(MapEntry('events[$indexVal][event_id][]', serviceListPosted[a].id.toString()));
        }
      }
    }
    var response = await API().postApi(data, "add-event");
    if(response.statusCode == 200){
      bottomToast(text: response.data['message']);
      API().sp.write("isEventCreated", 1);
      selectIndexxx.value = 0;
      Get.offAllNamed(Routes.bottomNavigationView,
          arguments: {"indexValue": 0});
    }
  }

  /// todo organizer flow have services


  RxBool sendingEmailLoader = true.obs;
  List<UserClass> invitationList = [];
  sendEmail(BuildContext context) async {
    sendingEmailLoader(false);
    List eventInvitation = [];
    for (var action in invitationList) {
      eventInvitation.add(action.emailController.text);
    }
    String username = 'william@gologonow.com'; //Your Email
    String password = 'ppqcxmrssiezdyrh'; // 16 Digits App Password Generated From Google Account
    final smtpServer = gmail(username, password);
    // Create our message.
    final message = Message()
      ..from = Address('william@gologonow','Groovkin',)
      ..recipients = eventInvitation
      ..subject = 'Event Invitation'
      ..text = 'Event Invitation users';
    try {
      sendingEmailLoader(false);
      // final sendReport =
      await send(message, smtpServer);
      invitationList.clear();
      Get.offNamed(Routes.sendInvitationScreen);
      sendingEmailLoader(true);
      update();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mail Send Successfully")));
    } on MailerException catch (e) {
      sendingEmailLoader(true);
      print('Message not sent.');
      print(e.message);
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

}

class AuthBinding implements Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<AuthController>(() => AuthController());
  }
}

class intro {
  final image, title, body,btnText;

  intro({this.image, this.title, this.body,this.btnText});
}