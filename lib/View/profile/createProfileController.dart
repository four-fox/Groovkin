
import 'package:get/get.dart';

class CreateProfileController extends GetxController{


  ///>>>>>>>>>>>>>>>>>>>>>>>>get profile
  RxBool getProfileLoader = true.obs;
  getProfile() async{

  }

  ///>>>>>>>>>>>>>>>>>>>>>> get all users
  RxBool getAllUserLoader = true.obs;
  getAllUser() async{

  }

  ///>>>>>>>>>>>>>>>>>>>>> get all event organizer
  RxBool getAllOrganizerLoader = true.obs;
  getAllOrganizer() async{

  }

  ///>>>>>>>>>>>>>>>>>>>get all event manager
  RxBool getAllEventManagerLoader = true.obs;
  getAllEventManager() async{

  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>toDo create profile functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>toDo life survey functionality
  getAllLifeSurvey() async{
    ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> life survey ba dalta get kege
  }

  getAllMusicGenre() async{
    ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Music Genre ba dalta get kege
  }
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>toDo life survey functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo organizer create profile
    RxBool getAllServicesLoader = true.obs;
    getAllServices() async{

    }
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>todo organizer create profile

}

class CreateProfileBinding implements Bindings{
  @override
  void dependencies() {
  Get.lazyPut<CreateProfileController>(() => CreateProfileController());
  }

}