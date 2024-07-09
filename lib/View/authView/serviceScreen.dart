


// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_final_fields

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';

class ServiceScreen extends StatelessWidget {
  ServiceScreen({Key? key}) : super(key: key);

  AuthController _controller = Get.find();

  int moreServiceAdd = Get.arguments['addMoreService']??1;

  EventController _eventController = Get.find();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    print(moreServiceAdd);
    return Scaffold(
      appBar: customAppBar(theme: theme,text: "Service", /*imagee:moreServiceAdd==2?false:true*/),
      // appBar: AppBar(
      //   backgroundColor: theme.scaffoldBackgroundColor,
      //   centerTitle: true,
      //   title: Text("Service",
      //   style: poppinsMediumStyle(
      //     fontSize: 17,
      //     context: context,
      //     color: theme.primaryColor,
      //   ),
      //   ),
      // ),
      body: GetBuilder<AuthController>(
        initState: (v){
          if(_eventController.eventDetail == null){
            _controller.getAllService(type: "services");
          }else{
            _eventController.checkServices();
          }
        },
        builder: (controller) {
          return controller.getAllServiceLoader.value==false?
          SizedBox.shrink():
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('The services you can provide!',
                  style: poppinsMediumStyle(
                    fontSize: 16,
                    context: context,
                    color: theme.primaryColor,
                  ),
                  ),
                  Text('Please select from given option.',
                  style: poppinsMediumStyle(
                    fontSize: 12  ,
                    context: context,
                    color: DynamicColor.lightRedClr,
                  ),
                  ),
                  SizedBox(
  height: 15,
),
                  SizedBox(
                    height: Get.height/1.5,
                    child: ListView.builder(
                        itemCount: controller.serviceListing.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context,index){
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child:
                        GestureDetector(
                          onTap: (){
                            controller.serviceAddFtn(items: controller.serviceListing[index]);
                            // controller.surveyData!.data![index].showItems!.value = !controller.surveyData!.data![index].showItems!.value;
                            // controller.update();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 6,horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: controller.serviceListing[index].showItems!.value==false? DecorationImage(
                                    image: AssetImage("assets/buttonBg.png"),fit: BoxFit.fill
                                ):null,
                              color: controller.serviceListing[index].showItems!.value==false? Colors.transparent:DynamicColor.lightBlackClr
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 17,
                                  backgroundColor: controller.serviceListing[index].showItems!.value==false? theme.primaryColor:DynamicColor.grayClr,
                                  child: Image(
                                    image: AssetImage(list[index].img.toString()),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(controller.serviceListing[index].name.toString(),
                                  style: poppinsMediumStyle(
                                    fontSize: 16,
                                    context: context,
                                    color: theme.primaryColor,
                                  ),
                                ),
                                Spacer(),
                                controller.serviceListing[index].showItems!.value==true? Icon(Icons.check,
                                  color: theme.primaryColor,
                                ):SizedBox.shrink(),
                                // Spacer(),
                                // Checkbox(
                                //     activeColor: DynamicColor.lightRedClr,
                                //     value:djValue , onChanged:onChanged)
                              ],
                            ),
                          ),
                        )
                      );
                    }),
                  ),
//                   serviceWidget(context: context,theme: theme,
//                       onChanged: (v){
//                       controller.djing.value = v!;
//                       controller.update();
//                   },
//                     djValue: controller.djing.value
//                   ),
// SizedBox(
//   height: 15,
// ),
//                   serviceWidget(context: context,theme: theme,onChanged: (v){
//                       controller.lighting.value = v!;
//                       controller.update();
//                   },text: "Lighting",
//                       image: "assets/lighting.png",
//                     djValue: controller.lighting.value
//                     ),
//   SizedBox(
//     height: 15,
//   ),
//                     serviceWidget(context: context,theme: theme,onChanged: (v){
//                       controller.photoBooth.value = v!;
//                         controller.update();
//                     },text: "Photobooth",
//
//                         image: "assets/lighting.png",
//                       djValue: controller.photoBooth.value
//                     ),
//   SizedBox(
//     height: 15,
//   ),
//                     serviceWidget(context: context,theme: theme,onChanged: (v){
//                       controller.masterOf.value = v!;
//                         controller.update();
//                     },text: "Master of Ceremony",
//
//                         image: "assets/master.png",
//                       djValue: controller.masterOf.value
//                     ),
//   SizedBox(
//     height: 15,
//   ),
//                     serviceWidget(context: context,theme: theme,onChanged: (v){
//                       controller.avEquipment.value = v!;
//                         controller.update();
//                     },text: "AV Equipment",
//
//                         image: "assets/avEquipment.png",
//                       djValue: controller.avEquipment.value
//                     ),
                ],
              ),
            ),
          );
        }
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
        child: CustomButton(
          borderClr: Colors.transparent,
          onTap: (){
                if(moreServiceAdd == 2){
                  Get.toNamed(Routes.quickSurveyScreen,
                  arguments: {
                    "addMoreService": moreServiceAdd
                  }
                  );
                }else if(moreServiceAdd == 3){
                  if(_controller.serviceList.isNotEmpty){
                    if(_eventController.eventDetail != null) {
                      _controller.getAllService(type: "hardware_provided");
                    }
                    Get.toNamed(Routes.hardwareScreen, arguments: {"createEvent": true});
                  }else{
                    bottomToast(text: "Please add service");
                  }
                  // Get.toNamed(Routes.hardwareProvidedScreen);
                }else{
                  if(_controller.serviceList.isNotEmpty){
                    Get.toNamed(Routes.insuranceScreen,
                        arguments: {
                          "insuranceNavigation": 1,
                        }
                    );
                  }else{
                    bottomToast(text: "Please add service");
                  }
                }
          },
          text: "Next",
        ),
      ),
    );
  }


  Widget serviceWidget({theme,image,context,onChanged,djValue,text,GestureTapCallback? onTap}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6,horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
                image: AssetImage("assets/buttonBg.png"),fit: BoxFit.fill
            )
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 17,
              backgroundColor: theme.primaryColor,
              child: Image(
                image: AssetImage(image??"assets/djing.png"),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Text(text??"DJing",
              style: poppinsMediumStyle(
                fontSize: 16,
                context: context,
                color: theme.primaryColor,
              ),
            ),
            Spacer(),
            Icon(Icons.check,
              color: theme.primaryColor,
            ),
            // Spacer(),
            // Checkbox(
            //     activeColor: DynamicColor.lightRedClr,
            //     value:djValue , onChanged:onChanged)
          ],
        ),
      ),
    );
  }
  List<ServiceList> list = [
    ServiceList(text: 'DJing',img: "assets/djing.png",clickCondition: false.obs),
    ServiceList(text: 'Lighting',img: "assets/lighting.png",clickCondition: false.obs),
    ServiceList(text: 'Photobooth',img: "assets/lighting.png",clickCondition: false.obs),
    ServiceList(text: 'Master of Ceremony',img: "assets/master.png",clickCondition: false.obs),
    ServiceList(text: 'AV Equipment',img: "assets/avEquipment.png",clickCondition: false.obs),
  ];
}

class ServiceList{
  String? img,text;
  RxBool? clickCondition = false.obs;
  ServiceList({this.text,this.img,this.clickCondition});
}