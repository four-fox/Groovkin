import 'dart:io';

import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UserHomeController extends GetxController {
  /// quick survey of groovkin
  RxBool foodies = false.obs;
  RxBool sportFan = false.obs;
  RxBool gaming = false.obs;

  RxBool iTunes = false.obs;
  RxBool spotifyVal = false.obs;

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

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> toDo Home functionality
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>get all events
  RxBool getAllEventsLoader = true.obs;
  getAllEvents() async {
    ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> here is the user get all events
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> here is the user get his own music and life style
  RxBool editUserGroovkinLoader = true.obs;
  editUserGroovkin() async {
    ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> here is the user get all events
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get event details by Id
  RxBool getEventDetailsLoader = true.obs;
  getEventDetails() async {
    ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>here we get event details
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> post about event status

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> toDo Home functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> toDo My Events
  RxBool getMyEventsHistoryLoader = true.obs;
  getMyEventsHistory() async {
    ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>. here we get event in our history
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>.get all upcoming events
  RxBool getAllUpcomingEventsLoader = true.obs;
  getAllUpcomingEvents() async {}

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> toDo My Events

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> toDo Group

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>get all groups
  RxBool getAllGroupsLoader = true.obs;
  getAllGroups() async {}

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> get all events of groups
  RxBool getAllEventsOfGroupsLoader = true.obs;
  getAllEventsOfGroups() async {
    /// >>>>>>>>>>>>>>>>>.here is we getting all events of group base
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> create new group
  RxBool getAllFollowerLoader = true.obs;
  getAllFollower() async {}

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> create new group
  // crateNewGroup() async {
  //   var formData = form.FormData.fromMap({
  //     "userLis": [],
  //     "groupName": "asdf",
  //   });
  // }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> toDo Group
}

class UserHomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserHomeController>(() => UserHomeController());
  }
}
