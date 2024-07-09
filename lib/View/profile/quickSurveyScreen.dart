


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/authView/autController.dart';

class QuickSurveyScreen extends StatefulWidget {
  QuickSurveyScreen({Key? key}) : super(key: key);

  @override
  State<QuickSurveyScreen> createState() => _QuickSurveyScreenState();
}

class _QuickSurveyScreenState extends State<QuickSurveyScreen> {
  int addMoreSurvey = Get.arguments['addMoreService'];

  String appBarTitle = Get.arguments['title']??"Lifestyle Survey";

  bool createEvent = false;

  AuthController _controller = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(Get.arguments['addMoreService']);
    if(Get.arguments['addMoreService'] == 1){
      createEvent = Get.arguments['createEvent'];
    }
  }



  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    print(addMoreSurvey);
    return Scaffold(
      appBar: customAppBar(onTap: () {
        Get.back();
      },theme: theme,text: appBarTitle,style: poppinsMediumStyle(
        fontSize: 17,
        context: context,
        color: theme.primaryColor,
        // color: DynamicColor.lightYellowClr,
      )),
      body: GetBuilder<AuthController>(
        initState: (v){
          // if((addMoreSurvey == 1) && sp.read("role")=="eventOrganizer"){
          //   _controller.getAllService(type: "lifestyle_preference");
          // }else{
            _controller.getLifeStyle(surveyType: "music_genre");
          // }
        },
        builder: (controller) {
          return ((controller.getLifeStyleLoader.value == false) || (controller.getAllServiceLoader.value == false))?SizedBox.shrink():
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(((addMoreSurvey == 1)&&(sp.read("role")=="eventOrganizer"))?"Let us know more about\nyour lifestyle preference":'Music Genre',
                  textAlign: TextAlign.center,
                  style: poppinsRegularStyle(
                    fontSize: 16,
                    context: context,
                    color: theme.primaryColor,
                  ),
                  ),
                ),
                Text('Please select from given option.',
                style: poppinsRegularStyle(
                  fontSize: 12,
                  context: context,
                  color: DynamicColor.lightRedClr,
                ),
                ),
                SizedBox(
                  height: 15,
                ),
                   Expanded(
                     child: SizedBox(
                      height: Get.height/1.41,
                       child: ListView.builder(
                        itemCount: controller.surveyData!.data!.length,
                        itemBuilder: (BuildContext context,index){
                         return Column(
                           children: [
                             musicGenreWidget(
                               text: controller.surveyData!.data![index].name.toString(),
                               onTap: (){
                                 controller.surveyData!.data![index].showItems!.value = !controller.surveyData!.data![index].showItems!.value;
                                 controller.update();
                               },
                               theme: theme,context: context,icon: controller.surveyData!.data![index].showItems!.value?Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,),
                             Padding(
                               padding: EdgeInsets.symmetric(vertical: 4.0),
                               child: Visibility(
                                 visible: controller.surveyData!.data![index].showItems!.value,
                                 child: Container(
                                   padding: EdgeInsets.symmetric(horizontal: 15),
                                   decoration: BoxDecoration(
                                     color: DynamicColor.dropDownClr,
                                     borderRadius: BorderRadius.circular(8),
                                   ),
                                   child: ListView.builder(
                                       itemCount: controller.surveyData!.data![index].categoryItems!.length,
                                       shrinkWrap: true,
                                       physics: NeverScrollableScrollPhysics(),
                                       itemBuilder: (BuildContext context,indexxx){
                                         return Column(
                                           children: [
                                             Row(
                                               children: [
                                                 Text(controller.surveyData!.data![index].categoryItems![indexxx].name.toString(),
                                                   style: poppinsRegularStyle(
                                                       fontSize: 12,color:
                                                   theme.primaryColor,
                                                       context: context
                                                   ),
                                                 ),
                                                 Spacer(),
                                                 Theme(
                                                   data: Theme.of(context).copyWith(
                                                     unselectedWidgetColor: Colors.white,
                                                   ),
                                                   child: Checkbox(
                                                       activeColor: DynamicColor.yellowClr,
                                                       value: controller.surveyData!.data![index].categoryItems![indexxx].selectedItem!.value,
                                                       onChanged: (v){
                                                         // if((addMoreSurvey == 1) && sp.read("role")=="eventOrganizer"){
                                                         //   controller.lifeStyleFunction(serviceObj: controller.surveyData!.data![index].categoryItems![indexxx],value: v);
                                                         // }else{
                                                           controller.surveyAddFtn(surveyObj: controller.surveyData!.data![index],value: v,items: controller.surveyData!.data![index].categoryItems![indexxx]);
                                                         // }
                                                      }
                                                   ),
                                                 )
                                               ],
                                             ),
                                             Divider(height: 1,)
                                           ],
                                         );
                                       }),
                                 ),
                               ),
                             ),
                           ],
                         );
                       }),
                     ),
                   ),
              ],
            ),
          );
        }
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
        child: CustomButton(
          borderClr: Colors.transparent,
          onTap: (){
            if(sp.read("role")=="User"){
              if(addMoreSurvey == 2){
              Get.back();
              }else{
                if(_controller.itemsList.isNotEmpty){
                  _controller.makeMethodHit(navigation: "music");
                }else{
                  bottomToast(text: "Please add life style for survey");
                }
              }
            }else{
              if(addMoreSurvey==2){
                Get.back();
                Get.back();
              }else{
                if(createEvent == true){
                  if(/*_controller.lifeStyleItemsList.isNotEmpty ||*/ _controller.itemsList.isNotEmpty){
                    Get.toNamed(Routes.musicChoiceScreen);
                  }else{
                    bottomToast(text: "Please add life style for survey");
                  }
                }else{
                  if(_controller.itemsList.isNotEmpty){
                    _controller.createEvent();
                  }else{
                    bottomToast(text: "Please add life style for survey");
                  }
                }
              }
            }
          },
          text:((sp.read("role")=="User")&&(appBarTitle == 'Edit Music Genre'))?"Save":((addMoreSurvey==2 && (sp.read("role")!="User")))? "Update":"Next",
        ),
      ),
    );
  }

  Widget musicGenreWidget({context,theme,text,GestureTapCallback? onTap,IconData? icon}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
      decoration: BoxDecoration(
          // image: DecorationImage(
          //     image: AssetImage("assets/buttonBg.png"),
          //     fit: BoxFit.fill
          // ),
        color: DynamicColor.secondaryClr,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Row(
        children: [
          Text(text??'Hip Hop',
            style: poppinsMediumStyle(
              fontSize: 16,
              context: context,
              color: theme.primaryColor,
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: onTap,
            child: Icon(icon,
              size: 30,
              color: theme.primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
