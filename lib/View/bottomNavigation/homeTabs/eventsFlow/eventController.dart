
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get_storage/get_storage.dart';
import 'package:groovkin/Components/CustomMultipart.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/Network/Url.dart';
import 'package:groovkin/Components/alertmessage.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/userEventDetailsModel.dart';
import 'package:groovkin/View/GroovkinUser/survey/surveyModel.dart' as survey;
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/musicChoiceView/musicChoiceModel.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/pastEventModel.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/showVenueByLatLngModel.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/upcomingEvents/upcomingEventsModel.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/organizerHomeModel/alleventsModel.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as form;

import 'ongoingEvents/ongoingEventsModel.dart';

class EventController extends GetxController{

  late AuthController _authController;
  late ManagerController managerController;

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<ManagerController>()) {
      managerController = Get.find<ManagerController>();
    } else {
      managerController = Get.put(ManagerController());
    }
    if (Get.isRegistered<AuthController>()) {
      _authController = Get.find<AuthController>();
    } else {
      _authController = Get.put(AuthController());
    }
  }

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
    List addForEvent = [];

    List<ListClass> hipList = [
      ListClass(text: "hip 1",condition: false.obs),
      ListClass(text: "hip 2",condition: false.obs),
      ListClass(text: "hip 3",condition: false.obs),
      ListClass(text: "hip 4",condition: false.obs),
    ];
    List<ListClass> africanList = [
      ListClass(text: "african 1",condition: false.obs),
      ListClass(text: "african 2",condition: false.obs),
      ListClass(text: "african 3",condition: false.obs),
      ListClass(text: "african 4",condition: false.obs),];
    List<ListClass> latinList = [ListClass(text: "latin 1",condition: false.obs),
      ListClass(text: "latin 2",condition: false.obs),
      ListClass(text: "latin 3",condition: false.obs),
      ListClass(text: "latin 4",condition: false.obs),
    ];
    List<ListClass> jazzList = [
      ListClass(text: "jazz 1",condition: false.obs),
      ListClass(text: "jazz 2",condition: false.obs),
      ListClass(text: "jazz 3",condition: false.obs),
      ListClass(text: "jazz 4",condition: false.obs),
    ];
    List<ListClass> countryList = [
      ListClass(text: "country 1",condition: false.obs),
      ListClass(text: "country 2",condition: false.obs),
      ListClass(text: "country 3",condition: false.obs),
      ListClass(text: "country 4",condition: false.obs),
    ];
    List<ListClass> danceList = [
      ListClass(text: "dance 1",condition: false.obs),
      ListClass(text: "dance 2",condition: false.obs),
      ListClass(text: "dance 3",condition: false.obs),
      ListClass(text: "dance 4",condition: false.obs),
    ];
    List<ListClass> internationalList = [
      ListClass(text: "international 1",condition: false.obs),
      ListClass(text: "international 2",condition: false.obs),
      ListClass(text: "international 3",condition: false.obs),
      ListClass(text: "international 4",condition: false.obs),
    ];
    List<ListClass> soulList = [
      ListClass(text: "soul 1",condition: false.obs),
      ListClass(text: "soul 2",condition: false.obs),
      ListClass(text: "soul 3",condition: false.obs),
      ListClass(text: "soul 4",condition: false.obs),
      ListClass(text: "soul 5",condition: false.obs),
    ];
    List<ListClass> rockList = [
      ListClass(text: "rock 1",condition: false.obs,),
      ListClass(text: "rock 2",condition: false.obs,),
      ListClass(text: "rock 3",condition: false.obs,),
      ListClass(text: "rock 4",condition: false.obs,),
      ListClass(text: "rock 5",condition: false.obs,),
    ];


  /// todo create event functionality
  final eventTitleController = TextEditingController();
  final featuringController = TextEditingController();
  final aboutController = TextEditingController();
  final themeOfEventController = TextEditingController();
  final eventDateController = TextEditingController();
  final eventEndDateController = TextEditingController();
  final proposedTimeWindowsController = TextEditingController();
  final endTimeController = TextEditingController();
  final hourlyRateController = TextEditingController();
  final otherRateController = TextEditingController();
  final eventHoursController = TextEditingController();
  final maxCapacityController = TextEditingController();
  final commentsController = TextEditingController();
  RxInt eventRateHourly = 0.obs;
  RxInt paymentScheduleValue = 0.obs;
  RxString? rateType = "hourly".obs;
  RxString? paymentSchedule = "0".obs;
  final format = DateFormat('dd-MM-yyyy');


  ///>>>>>>>>>>>>>>>>>  get music tag
  RxBool getMusicTagLoader = true.obs;
  MusicTagModel? addMusicTag;
  List<TagObject> tagList = [];
  List<TagObject> activityList = [];
  getMusicTag({type}) async{
    getMusicTagLoader(false);
    var response = await API().getApi(url: "event-tags?type=$type");
    if(response.statusCode == 200){
      addMusicTag = MusicTagModel.fromJson(response.data);
      if(type == "music_choice"){
        tagListPost.clear();
        tagList.clear();
        tagList.addAll(MusicTagModel.fromJson(response.data).data!);
      }else{
        activityListPost.clear();
        activityList.clear();
        activityList.addAll(MusicTagModel.fromJson(response.data).data!);
      }
      getMusicTagLoader(true);
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>> tag list fill check box function
  List<CategoryItem> tagListPost = [];
  tagAddFtn({CategoryItem? items,value,}) async{
    items!.selected!.value = value;
    if(value == true){
      tagListPost.add(items);
    }else{
      tagListPost.remove(items);
    }
    update();
  }

  ///>>>>>>>>>>>>>>>>>>>> activity list fill check box function
  List<CategoryItem> activityListPost = [];
  activityAddFtn({CategoryItem? items,value,}) async{
    items!.selected!.value = value;
    if(value == true){
      activityListPost.add(items);
    }else{
      activityListPost.remove(items);
    }
    update();
  }

  ///get list of venues as lat lng
  RxBool getVenuesLatLngLoader = true.obs;
  VenueListModel? allVenueList;
  VenueByLatLng? venuesDetails;
  getVenuesLatLng() async{
    getVenuesLatLngLoader(false);
    var response = await API().getApi(url: "show-venues-by-distance?miles=500&latitude=${managerController.lat}&longitude=${managerController.lng}");
    if(response.statusCode == 200){
      allVenueList = VenueListModel.fromJson(response.data);
      getVenuesLatLngLoader(true);
      update();
    }
  }


  String? datePost;
  String? endDatePost;
  String? postTime;
  String? postEndTime;
  postEventFunction(context,theme,{location,bool draft = false}) async {
    AuthController _authController = Get.find();
    List<form.MultipartFile> mediaList = [];
    for (var element in managerController.mediaClass) {
      if(element.thumbnail != null){
        mediaList.add( form.MultipartFile.fromFileSync(
          element.filename!,
          filename: "Video.${element.filename!.split('.').last}",
          contentType:
          MediaType("video", element.filename!.split('.').last),
        ));
      }else{
        mediaList.add(form.MultipartFile.fromFileSync(
          element.filename!,
          filename: "Image.${element.filename!.split('.').last}",
          contentType:
          MediaType("image", element.filename!.split('.').last),
        ));
      }
    }

    ///bannerImage
    List imageList = [];
    if(_authController.imageBytes != null){
      var a = multiPartingImage(_authController.imageBytes);
      imageList.add(a);
    }
    print(location);
    form.FormData formData = form.FormData.fromMap({
      "event_title": eventTitleController.text,
      "featuring": featuringController.text,
      "about": aboutController.text,
      "theme_of_event": themeOfEventController.text,
      "start_date_time":"$datePost $postTime" /*datePost*/,
      // "check_in": postTime,
      "end_date_time": "$endDatePost $postEndTime",
      // "max_capacity": maxCapacityController.text,
      "rate": hourlyRateController.text,
      "rate_type": rateType!.value,
      "payment_schedule": int.parse(paymentSchedule!.value.toString()),
     if(commentsController.text.isNotEmpty) "comment": commentsController.text,
      if(venuesDetails != null || location != null) "location": location == null? venuesDetails!.location:location.data.location,
      if(venuesDetails != null || location != null) "latitude": double.parse(location == null? managerController.lat:location.data.latitude),
      if(venuesDetails != null || location != null) "longitude": double.parse(location == null? managerController.lng:location.data.longitude),
      if(venuesDetails != null || location != null)"venue_id": location == null? venuesDetails!.id:location.data.venueId,
      if(mediaList.isNotEmpty)"image[]": mediaList,
      "banner_image[]": imageList,
      if(venuesDetails != null || location != null)"venue_user_id":location == null? managerController.venueDetails!.data!.userId:location.data.userId,
      "save_draft": draft
    });

    /// todo service params
    for(var i = 0; i <= _authController.serviceList.length; i++){
      if(i != _authController.serviceList.length){
        formData.fields.add(MapEntry('service_id[$i]', _authController.serviceList[i].id.toString()));
      }
    }
    /// todo service params

    /// todo hardware params
    int? indexVal = -1;
    int? iiid = -1;
    print(_authController.eventItemsList.length);
    for(var a = 0; a <= _authController.eventItemsList.length; a++){
      if(a != _authController.eventItemsList.length){
        if(iiid != _authController.eventItemsList[a].eventId){
          indexVal = indexVal! + 1;
          formData.fields.add(MapEntry('hardware_provides[$indexVal][hardware_provide_id]', _authController.eventItemsList[a].eventId.toString()));
        }
        if(_authController.eventItemsList[a].selectedItem!.value == true){
          iiid = _authController.eventItemsList[a].eventId;
          formData.fields.add(MapEntry('hardware_provides[$indexVal][hardware_item_ids][]', _authController.eventItemsList[a].id.toString()));
        }
      }
    }
    /// todo hardware params

    /// todo life Style params
    int? indexVaal = -1;
    int? iiad = -1;
    print(_authController.itemsList.length);
    for(var a = 0; a <= _authController.itemsList.length; a++){
      if(a != _authController.itemsList.length){
        if(iiad != _authController.itemsList[a].categoryId){
          indexVaal = indexVaal! + 1;
          formData.fields.add(MapEntry('music_genre[$indexVaal][music_genre_id]', _authController.itemsList[a].categoryId.toString()));
        }
        if(_authController.itemsList[a].selectedItem!.value == true){
          iiad = _authController.itemsList[a].categoryId;
          formData.fields.add(MapEntry('music_genre[$indexVaal][music_genre_item_ids][]', _authController.itemsList[a].id.toString()));
        }
      }
    }
    /// todo life Style params
    int? indexVall = -1;
    int? iiidd = -1;
    for(var a = 0; a <= tagListPost.length; a++){
      if(a != tagListPost.length){
        if(iiidd != tagListPost[a].eventTagId){
          indexVall = indexVall! + 1;
          formData.fields.add(MapEntry('music_choice_tag[$indexVall][music_choice_tag_id]', tagListPost[a].eventTagId.toString()));
        }
        if(tagListPost[a].selected!.value == true){
          iiidd = tagListPost[a].eventTagId;
          formData.fields.add(MapEntry('music_choice_tag[$indexVall][music_choice_tag_item_ids][]', tagListPost[a].id.toString()));
        }
      }
    }
    /// todo life Style params

    /// todo activity choice
    int? indexValll = -1;
    int? iiiddd = -1;
    for(var a = 0; a <= activityListPost.length; a++){
      if(a != activityListPost.length){
        if(iiiddd != activityListPost[a].eventTagId){
          indexValll = indexValll! + 1;
          formData.fields.add(MapEntry('activity_choice_tag[$indexValll][activity_choice_tag_id]', activityListPost[a].eventTagId.toString()));
        }
        if(activityListPost[a].selected!.value == true){
          iiiddd = activityListPost[a].eventTagId;
          formData.fields.add(MapEntry('activity_choice_tag[$indexValll][activity_choice_tag_item_ids][]', activityListPost[a].id.toString()));
        }
      }
    }
    /// todo activity choice

    print(formData);
    var response = await API().postApi(formData, 'create-event');
    if(response.statusCode == 200){
      if(draft == false){
        Get.back();
        Future.delayed(Duration(seconds: 2), () {
          Get.offAllNamed(Routes.bottomNavigationView,
              arguments: {"indexValue": 0});
        });
        showDialog(
            barrierColor: Colors.transparent,
            context: context,
            barrierDismissible: true,
            builder: (BuildContext context) {
              return AlertWidget(
                height: kToolbarHeight * 4.4,
                container: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Congratulation!',
                        style: poppinsRegularStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          context: context,
                          color: theme.primaryColor,
                        ),
                      ),
                      Text(
                        'The proposal has been sent to\nthe Venue Manager',
                        style: poppinsRegularStyle(
                          fontSize: 16,
                          context: context,
                          color: theme.primaryColor,
                        ),
                      ),
                      SizedBox(
                        height: 90,
                        child: Image(
                          image: AssetImage("assets/handshake.png"),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            });
      }else{
        Get.offAllNamed(Routes.bottomNavigationView,
            arguments: {
              "indexValue": 0
            }
        );
      }
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>edit Event Function
  editEventFunction() async{
    AuthController _authController = Get.find();
    List<form.MultipartFile> mediaList = [];
    for (var element in managerController.mediaClass) {
      if(element.thumbnail != null){
        mediaList.add( form.MultipartFile.fromFileSync(
          element.filename!,
          filename: "Video.${element.filename!.split('.').last}",
          contentType:
          MediaType("video", element.filename!.split('.').last),
        ));
      }else{
        mediaList.add(form.MultipartFile.fromFileSync(
          element.filename!,
          filename: "Image.${element.filename!.split('.').last}",
          contentType:
          MediaType("image", element.filename!.split('.').last),
        ));
      }
    }

    ///bannerImage
    List imageList = [];
    if(_authController.imageBytes != null){
      var a = multiPartingImage(_authController.imageBytes);
      imageList.add(a);
    }
    List service = [];
    for (var actions in _authController.serviceList) {
      service.add(actions.id);
    }
    var formData = form.FormData.fromMap({
      "event_title": eventTitleController.text,
      "featuring": featuringController.text,
      "about": aboutController.text,
      "theme_of_event": themeOfEventController.text,
      "start_date_time":"$datePost $postTime" /*datePost*/,
      // "check_in": postTime,
      "end_date_time": "$endDatePost $postEndTime",
      // "max_capacity": maxCapacityController.text,
      "rate": hourlyRateController.text,
      "rate_type": rateType!.value,
      "payment_schedule": int.parse(paymentSchedule!.value.toString()),
      "comment": commentsController.text,
      "event_id": eventDetail!.data!.id,
      if(mediaList.isNotEmpty)"image[]": mediaList,
      if(imageList.isNotEmpty)"banner_image[]": imageList,
      "service_id[]": service,
      "venue_id": eventDetail!.data!.venue == null?managerController.venueDetails!.data!.id: eventDetail!.data!.venueId
    });

    /// todo hardware params
    int? indexVal = -1;
    int? iiid = -1;
    int indexValue = -1;
    for(var a = 0; a <= _authController.eventItemsList.length; a++){
      if(a != _authController.eventItemsList.length){
        if(iiid != _authController.eventItemsList[a].eventId){
          indexVal = indexVal! + 1;
          indexValue = -1;
          formData.fields.add(MapEntry('hardware_provides[$indexVal]', _authController.eventItemsList[a].eventId.toString()));
        }
        if(_authController.eventItemsList[a].selectedItem!.value == true){
          indexValue = indexValue+1;
          iiid = _authController.eventItemsList[a].eventId;
          formData.fields.add(MapEntry('hardware_item_ids[$indexVal][$indexValue]', _authController.eventItemsList[a].id.toString()));
        }
      }
    }
    /// todo hardware params

    /// todo life Style params
    int? indexVaal = -1;
    int? iiad = -1;
    int genreIndex = -1;
    print(_authController.itemsList.length);
    for(var a = 0; a <= _authController.itemsList.length; a++){
      if(a != _authController.itemsList.length){
        if(iiad != _authController.itemsList[a].categoryId){
          indexVaal = indexVaal! + 1;
          genreIndex = -1;
          formData.fields.add(MapEntry('music_genre[$indexVaal]', _authController.itemsList[a].categoryId.toString()));
        }
        if(_authController.itemsList[a].selectedItem!.value == true){
          iiad = _authController.itemsList[a].categoryId;
          genreIndex = genreIndex+1;
          formData.fields.add(MapEntry('music_genre_item_ids[$indexVaal][$genreIndex]', _authController.itemsList[a].id.toString()));
        }
      }
    }
    /// todo life Style params

    /// todo music choice params
    int? indexVall = -1;
    int? iiidd = -1;
    int musicChoiceIndex = -1;
    for(var a = 0; a <= tagListPost.length; a++){
      if(a != tagListPost.length){
        if(iiidd != tagListPost[a].eventTagId){
          indexVall = indexVall! + 1;
          musicChoiceIndex = -1;
          formData.fields.add(MapEntry('music_choice_tag[$indexVall]', tagListPost[a].eventTagId.toString()));
        }
        if(tagListPost[a].selected!.value == true){
          iiidd = tagListPost[a].eventTagId;
          musicChoiceIndex = musicChoiceIndex+1;
          formData.fields.add(MapEntry('music_choice_tag_item_ids[$indexVall][$musicChoiceIndex]', tagListPost[a].id.toString()));
        }
      }
    }
    /// todo life Style params

    /// todo activity choice
    int? indexValll = -1;
    int? iiiddd = -1;
    int activityChoiceIndex = -1;
    for(var a = 0; a <= activityListPost.length; a++){
      if(a != activityListPost.length){
        if(iiiddd != activityListPost[a].eventTagId){
          indexValll = indexValll! + 1;
          activityChoiceIndex = -1;
          formData.fields.add(MapEntry('activity_choice_tag[$indexValll]', activityListPost[a].eventTagId.toString()));
        }
        if(activityListPost[a].selected!.value == true){
          iiiddd = activityListPost[a].eventTagId;
          activityChoiceIndex = activityChoiceIndex+1;
          formData.fields.add(MapEntry('activity_choice_tag_item_ids[$indexValll][$activityChoiceIndex]', activityListPost[a].id.toString()));
        }
      }
    }
    /// todo activity choice
    print(formData);
    var response = await API().postApi(formData, "update-event");
    if(response.statusCode == 200){
      BotToast.showText(text: response.data['message']);
      clearFields();
      Get.offAllNamed(Routes.bottomNavigationView,
          arguments: {
            "indexValue": 0
          }
      );
    }
  }

  ///delete image
  List removeImageList = [];
  deleteImage({id, bool eventImg = false}) async{
    var formData = form.FormData.fromMap({
     if(eventImg == false) "venue_image_id[]": removeImageList,
      if(eventImg == true) "event_image_id[]": removeImageList,
      "source_id": id,
    });
    var response = await API().postApi(formData, "remove-media");
    if(response.statusCode == 200){

    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>> event start and end time are checking
  checkingTime({sta}) async{
    var formData = form.FormData.fromMap({
      "start_date_time": "$datePost $postTime",
      "end_date_time": "$endDatePost $postEndTime",
    });
    var response = await API().postApi(formData, "check-date-time");
    if(response.statusCode == 200){
      Get.toNamed(Routes.serviceScreen,
          arguments: {
            "addMoreService": 3
          }
      );
    }
  }

  /// clear fields
  RxBool draftCondition = false.obs;
  clearFields() async{
    draftCondition(true);
    duplicateValue(true);
    draftValue(true);
    _authController.imageBytes = null;
    eventTitleController.clear();
    featuringController.clear();
    aboutController.clear();
    themeOfEventController.clear();
    maxCapacityController.clear();
    hourlyRateController.clear();
    commentsController.clear();
    datePost = null;
    postTime = null;
    endDatePost = null;
    postEndTime = null;
    rateType!.value = "hourly";
    paymentSchedule!.value = "0";
    _authController.serviceList.clear();
    _authController.eventItemsList.clear();
    _authController.lifeStyleItemsList.clear();
    activityListPost.clear();
    eventDateController.clear();
    eventEndDateController.clear();
    proposedTimeWindowsController.clear();
    endTimeController.clear();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get my all events for organizer
  EventsListModel? allEvents;
  RxBool getAllEventsLoader = true.obs;
  bool getAllEventWaiting = false;
  getAllEvents({nextUrl}) async{
    getAllEventsLoader(false);
    var response = await API().getApi(url: "show-events",fullUrl: nextUrl);
    if(response.statusCode == 200){
      if(nextUrl == null){
        getAllEventWaiting = false;
        allEvents = EventsListModel.fromJson(response.data);
      }else{
        allEvents!.data!.data!
            .addAll(EventsListModel.fromJson(response.data).data!.data!);
        allEvents!.data!.nextPageUrl =
            EventsListModel.fromJson(response.data).data!.nextPageUrl;
        getAllEventWaiting = false;
      }
      getAllEventsLoader(true);
      update();
    }
  }

  ///searching events
  final searchingController = TextEditingController();
  searchingEvent({nextUrl}) async{
     getAllEventsLoader(false);
    var response = await API().getApi(url: "search-events?search=${searchingController.text}",fullUrl: nextUrl);
    if(response.statusCode == 200){
      if(nextUrl == null){
        getAllEventWaiting = false;
        allEvents = EventsListModel.fromJson(response.data);
      }else{
        allEvents!.data!.data!
            .addAll(EventsListModel.fromJson(response.data).data!.data!);
        allEvents!.data!.nextPageUrl =
            EventsListModel.fromJson(response.data).data!.nextPageUrl;
        getAllEventWaiting = false;
      }
       getAllEventsLoader(true);
      update();
    }
  }

  ///>>>>>>>>>>>> get all event sending requests
  RxBool getAllSendingRequestLoader = true.obs;
  bool requestEventWaiting = false;
  getAllSendingRequest({nextUrl}) async{
    getAllSendingRequestLoader(false);
    var response = await API().getApi(url: "show-requested-events",fullUrl: nextUrl);
    if(response.statusCode == 200){
      if(nextUrl == null){
        requestEventWaiting = false;
        allEvents = EventsListModel.fromJson(response.data);
      }else{
        allEvents!.data!.data!
            .addAll(EventsListModel.fromJson(response.data).data!.data!);
        allEvents!.data!.nextPageUrl =
            EventsListModel.fromJson(response.data).data!.nextPageUrl;
        requestEventWaiting = false;
      }
      getAllSendingRequestLoader(true);
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get details of event details
  UserEventDetailsModel? eventDetail;
  RxBool eventDetailsLoader = true.obs;
  List<String> venueImageList = [];
  RxBool duplicateValue = false.obs;
  RxBool draftValue = false.obs;
  eventDetails({eventId}) async{
    eventDetailsLoader(false);
    duplicateValue(false);
    draftValue(false);
    var response = await API().getApi(url: "event-details/$eventId");
    if(response.statusCode == 200){
      eventDetail = UserEventDetailsModel.fromJson(response.data);
      venueImageList.clear();
      for (var element in eventDetail!.data!.profilePicture!) {
       venueImageList.add(element.mediaPath!);
      }
      eventDetailsLoader(true);
      update();
    }
  }

  List imageListtt = [];
  assignValueForUpdate() async{
    eventTitleController.text = eventDetail!.data!.eventTitle.toString();
    featuringController.text = eventDetail!.data!.featuring.toString();
    aboutController.text = eventDetail!.data!.about.toString();
    themeOfEventController.text = eventDetail!.data!.themeOfEvent.toString();
    maxCapacityController.text = eventDetail!.data!.maxCapacity.toString();
    eventDateController.text = DateFormat('dd-MM-yyyy')
        .format(eventDetail!.data!.startDateTime!);
    eventEndDateController.text = DateFormat('dd-MM-yyyy')
        .format(eventDetail!.data!.endDateTime!);
    proposedTimeWindowsController.text = DateFormat("HH:mm").format(eventDetail!.data!.startDateTime!);
    endTimeController.text = DateFormat("HH:mm").format(eventDetail!.data!.endDateTime!);
    postEndTime = endTimeController.text;
    postTime = proposedTimeWindowsController.text;
    endDatePost = DateFormat('yyyy-MM-dd')
        .format(eventDetail!.data!.endDateTime!);
    datePost = DateFormat('yyyy-MM-dd')
        .format(eventDetail!.data!.startDateTime!);
    if(eventDetail!.data!.rateType == "hourly"){
      eventRateHourly.value = 0;
    }else{
      eventRateHourly.value = 1;
    }
    hourlyRateController.text = eventDetail!.data!.rate.toString();
    if(eventDetail!.data!.paymentSchedule == "25"){
      paymentSchedule!.value = "25";
      paymentScheduleValue.value = 0;
    }else if (eventDetail!.data!.paymentSchedule == "50"){
      paymentSchedule!.value = "50";
      paymentScheduleValue.value = 1;
    }else{
      paymentSchedule!.value = "70";
      paymentScheduleValue.value = 2;
    }
    if(eventDetail!.data!.comment != null){
      commentsController.text = eventDetail!.data!.comment.toString();
    }
    Get.toNamed(Routes.upGradeEvents);
  }


  ///service data are binding
  checkServices({survey.SurveyObject? surveyObj}) async{
    // _authController.serviceList.clear();
  List serviceList = [];
    for (var action in eventDetail!.data!.services!) {
      serviceList.add(action.eventItemId);
    }
    for (var service in _authController.serviceListing) {
      if(serviceList.contains(service.id)){
        service.showItems!.value = true;
        _authController.serviceList.add(service);
        // _authController.serviceAddFtn(items: service);
      }
    }
  }

  ///hardware data are binding
  checkHardware({survey.SurveyObject? items, value, CategoryItem? serviceObj}) async{
   List<String> temp = [];
   eventDetail!.data!.hardwareProvide?.forEach((element){
     temp.add(element.hardwareItems!.id.toString());
   });
    for (var action in _authController.hardwareListing) {
      if(temp.contains(action.name)){
        action.showItems!.value = true;
      }else{
        action.showItems!.value = false;
      }
      for (var items in action.categoryItems!) {
        if(temp.contains(items.id.toString())){
          items.selectedItem!.value =true;
          _authController.eventItemsList.add(items);
        }else{
          items.selectedItem!.value =false;
        }
      }
    }
  }

  ///bind survey data
  surveyDataBind() async {
    List musicGenreId = [];
    for (var action in eventDetail!.data!.musicGenre!) {
      musicGenreId.add(action.itemId);
    }
    for (var element in _authController.surveyData!.data!) {
      for (var ele in element.categoryItems!) {
        if(musicGenreId.contains(ele.id)){
          element.showItems!.value = true;
          ele.selectedItem!.value = true;
          _authController.itemsList.add(ele);
        }else{
          ele.selectedItem!.value = false;
        }
      }
    }
  }

  musicChoiceBinding() async{
    List musicChoice = [];
    for (var action in eventDetail!.data!.eventMusicChoiceTags!) {
      musicChoice.add(action.eventTagItemId);
    }
    for (var ele in tagList) {
      for (var element in ele.categoryItems!) {
        if(musicChoice.contains(element.id)){
          ele.showSubCat!.value = true;
          element.selected!.value = true;
          tagListPost.add(element);
        }else{
          element.selected!.value = false;
        }
      }
    }
  }

  ///create Event
  activityChoice() async {
    List activityChoiceList = [];
    for (var action in eventDetail!.data!.eventActivityChoiceTags!) {
      activityChoiceList.add(action.eventTagItemId);
    }
    for (var elementss in activityList) {
      for (var ele in elementss.categoryItems!) {
        if(activityChoiceList.contains(ele.id)){
          elementss.showSubCat!.value = true;
          ele.selected!.value = true;
          activityListPost.add(ele);
        }else{
          ele.selected!.value = false;
        }
      }
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>> manager Acknowledged complete event
  acknowledgedEvent({eventId}) async {
    var formData = form.FormData.fromMap({
      "event_id": eventId,
    });
    var response = await API().postApi(formData, "acknowledged-event");
    if(response.statusCode == 200){
      bottomToast(text: response.data['message']);
      int a = pastEventData!.data!.data!.indexWhere((element) => element.id == eventId);
      pastEventData!.data!.data!.remove(pastEventData!.data!.data![a]);
      update();
      Get.back();
    }
  }

  ///user side interested or going etc
  userInterested({statusValue,eventId}) async{
    var formData = form.FormData.fromMap({
      "source_id": eventId,
      "status": statusValue,
    });
    var response = await API().postApi(formData, "user-event-status");
    if(response.statusCode == 200){
      eventDetail!.data!.eventGoingOrInterested!.value = 1;
      update();
    }
  }

  ///user cancel events
  userCancelEvents({eventId}) async{
    var formData = form.FormData.fromMap({
      "source_id": eventId,
    });
    var response = await API().postApi(formData, "cancel-event-by-user");
    if(response.statusCode == 200){
      eventDetail!.data!.eventGoingOrInterested!.value = 0;
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> cancel events
  final cancellationController = TextEditingController();
  cancelEvents({eventId,back = false}) async{
    var formData = form.FormData.fromMap({
      "source_id": eventId,
      "reason_message": cancellationController.text,
    });
    var response = await API().postApi(formData, "cancelled-event");
    if(response.statusCode == 200){
      bottomToast(text: response.data["message"].toString());
      if(back == true){
        if(allEvents != null){
          int events = allEvents!.data!.data!.indexWhere((element) => element.id == eventId);
          allEvents!.data!.data!.remove(allEvents!.data!.data![events]);
          Get.back();
        }
      }else{
        if(managerController.managerPendingEvents != null){
          int index = managerController.managerPendingEvents!.data!.data!.indexWhere((test)=> test.id == eventId);
          managerController.managerPendingEvents!.data!.data!.remove(managerController.managerPendingEvents!.data!.data![index]);
        }
      }
      cancellationController.clear();
      update();
      Get.back();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get upcoming events
  UpcomingEventsModel? upcomingEventData;
  RxBool getUpcomingEventsLoader = true.obs;
  getUpcomingEvents() async{
    getUpcomingEventsLoader(false);
    var response = await API().getApi(url: "upcoming-events");
    if(response.statusCode == 200){
      upcomingEventData = UpcomingEventsModel.fromJson(response.data);
      getUpcomingEventsLoader(true);
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> postponed data assign
  postponedAssign() async{
    proposedTimeWindowsController.text = DateFormat().add_jm().format(eventDetail!.data!.startDateTime!);
    endTimeController.text = DateFormat().add_jm().format(eventDetail!.data!.endDateTime!);
    datePost = DateFormat('yyyy-MM-dd')
        .format(eventDetail!.data!.startDateTime!);
    endDatePost = DateFormat('yyyy-MM-dd')
        .format(eventDetail!.data!.endDateTime!);
    postTime = DateFormat("HH:mm").parse(proposedTimeWindowsController.text).toString().replaceRange(0, 11, "").split(".")[0];
    postEndTime = DateFormat("HH:mm").parse(endTimeController.text).toString().replaceRange(0, 11, "").split(".")[0];
    Get.toNamed(Routes.editEventScreen,
      arguments: {
        "eventId": eventDetail!.data!.id
      }
    );
    update();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> postponed event

  final rescheduleDescriptionController = TextEditingController();
  eventPostponed({eventId}) async{
    var formData = form.FormData.fromMap({
      "event_id": eventId,
      "start_date_time": "$datePost $postTime",
      "end_date_time": "$endDatePost $postEndTime",
      "about": rescheduleDescriptionController.text,
    });
    var response = await API().postApi(formData, "reschedule-event");
    if(response.statusCode == 200){
      bottomToast(text: response.data["message"].toString());
      Get.back();
      Get.back();
      // print(object);
    }
  }

  ///get all ongoing events
  RxBool getAllOngoingEventsLoader = true.obs;
  OngoingEventModel? ongoingEvents;
  getAllOngoingEvents() async{
    getAllOngoingEventsLoader(false);
    var response = await API().getApi(url: "on-going-events");
    if(response.statusCode == 200){
      ongoingEvents = OngoingEventModel.fromJson(response.data);
      getAllOngoingEventsLoader(true);
      update();
    }
  }

  ///complete event and submit rating
  final ratingDescriptionController = TextEditingController();
  String ratingValue = "1.0";
  completeEvent({EventDetails? eventDetails}) async {
    var formData = form.FormData.fromMap({
      "event_id": eventDetails!.id,
      "rate_num": ratingValue,
     if(ratingDescriptionController.text.isNotEmpty) "rating_text": ratingDescriptionController.text,
      "venue_id": eventDetails.venue!.id,
    });
    var response = await API().postApi(formData, "complete-event");
    if(response.statusCode == 200){
      bottomToast(text: response.data["message"].toString());
      Get.back();
      Get.back();
    }
  }

  /// get past events
  PastEventModel? pastEventData;
  getPastEvent() async{
    var response = await API().getApi(url: "past-events-by-organizer");
    if(response.statusCode == 200){
      pastEventData = PastEventModel.fromJson(response.data);
      update();
    }
  }

  /// todo create event functionality

}

class ListClass{
  String? text;
  RxBool? condition = false.obs;
  ListClass({this.text,this.condition});
}


class EventBinding implements Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<EventController>(() => EventController());
  }

}