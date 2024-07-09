


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';

class ProposedMusicScreen extends StatelessWidget {
  ProposedMusicScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(onTap: () {
        Get.back();
      },theme: theme,text: "Create Event",style: poppinsMediumStyle(
        fontSize: 17,
        context: context,
        color: DynamicColor.lightYellowClr,
      )),
      body: GetBuilder<EventController>(
          builder: (controller) {
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Proposed Music Genres\nfor this event.',
                            textAlign: TextAlign.center,
                            style: poppinsRegularStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              context: context,
                              color: theme.primaryColor,
                            ),
                          ),
                        ) ,
                        SizedBox(
                          height: 15,
                        ),
                        musicGenreWidget(
                          onTap: (){
                            controller.hipHop.value = !controller.hipHop.value;
                            controller.update();
                          },
                          theme: theme,context: context,icon:controller.hipHop.value?Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,),
                        Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Visibility(
                            visible: controller.hipHop.value,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 12),
                              decoration: BoxDecoration(
                                color: DynamicColor.dropDownClr,
                                  // image: DecorationImage(
                                  //     image: AssetImage("assets/buttonBg.png"),
                                  //     fit: BoxFit.fill
                                  // ),
                                  borderRadius: BorderRadius.circular(8),
                                  // border: Border.all(color: theme.primaryColor,)
                              ),
                              child: ListView.builder(
                                  itemCount: controller.hipList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context,index){
                                    return Row(
                                      children: [
                                        Text(controller.hipList[index].text.toString(),
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
                                          child: Checkbox(activeColor: DynamicColor.lightRedClr,
                                              value: controller.hipList[index].condition!.value, onChanged: (v){
                                                controller.hipList[index].condition!.value = v!;
                                                controller.addForEvent.add(controller.hipList[index].text);
                                                controller.update();

                                          }),
                                        )
                                      ],
                                    );
                                  }),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        musicGenreWidget(
                          onTap: (){
                            controller.soul.value = !controller.soul.value;
                            controller.update();
                          },text: "R&B\$Soul",
                          theme: theme,context: context,icon:controller.soul.value?Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,),
                        Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Visibility(
                            visible: controller.soul.value,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 12),
                              decoration: BoxDecoration(
                                  // image: DecorationImage(
                                  //     image: AssetImage("assets/buttonBg.png"),
                                  //     fit: BoxFit.fill
                                  // ),
                                  color: DynamicColor.dropDownClr,
                                  borderRadius: BorderRadius.circular(8),
                                  // border: Border.all(color: theme.primaryColor,)
                              ),
                              child: ListView.builder(
                                  itemCount: controller.soulList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context,index){
                                    return Row(
                                      children: [
                                        Text(controller.soulList[index].text.toString(),
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
                                          child: Checkbox(activeColor: DynamicColor.lightRedClr,
                                              value: controller.soulList[index].condition!.value, onChanged: (v){
                                                controller.soulList[index].condition!.value = v!;
                                                controller.addForEvent.add(controller.soulList[index].text);
                                                controller.update();
                                          }),
                                        )
                                      ],
                                    );
                                  }),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        musicGenreWidget(
                          onTap: (){
                            controller.rock.value = !controller.rock.value;
                            controller.update();
                          },text: "Rock",
                          theme: theme,context: context,icon:controller.rock.value?Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,),
                        Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Visibility(
                            visible: controller.rock.value,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 12),
                              decoration: BoxDecoration(
                                  // image: DecorationImage(
                                  //     image: AssetImage("assets/buttonBg.png"),
                                  //     fit: BoxFit.fill
                                  // ),
                                  color: DynamicColor.dropDownClr,
                                  borderRadius: BorderRadius.circular(8),
                                  // border: Border.all(color: theme.primaryColor,)
                              ),
                              child: ListView.builder(
                                  itemCount: controller.rockList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context,index){
                                    return Row(
                                      children: [
                                        Text(controller.rockList[index].text.toString(),
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
                                          child:   Checkbox(activeColor: DynamicColor.lightRedClr,
                                              value: controller.rockList[index].condition!.value, onChanged: (v){
                                                controller.rockList[index].condition!.value = v!;
                                                controller.addForEvent.add(controller.rockList[index].text);
                                                controller.update();
                                          }),
                                        )
                                      ],
                                    );
                                  }),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        musicGenreWidget(
                          onTap: (){
                            controller.african.value = !controller.african.value;
                            controller.update();
                          },text: "Reggae\Caribbean\African",
                          theme: theme,context: context,icon:controller.african.value?Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,),
                        Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Visibility(
                            visible: controller.african.value,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 12),
                              decoration: BoxDecoration(
                                  // image: DecorationImage(
                                  //     image: AssetImage("assets/buttonBg.png"),
                                  //     fit: BoxFit.fill
                                  // ),
                                  color: DynamicColor.dropDownClr,
                                  borderRadius: BorderRadius.circular(8),
                                  // border: Border.all(color: theme.primaryColor,)
                              ),
                              child: ListView.builder(
                                  itemCount: controller.africanList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context,index){
                                    return Row(
                                      children: [
                                        Text(controller.africanList[index].text.toString(),
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
                                          child:   Checkbox(activeColor: DynamicColor.lightRedClr,
                                              value: controller.africanList[index].condition!.value, onChanged: (v){
                                                controller.africanList[index].condition!.value = v!;
                                                controller.addForEvent.add(controller.africanList[index].text);
                                                controller.update();
                                          }),
                                        )
                                      ],
                                    );
                                  }),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        musicGenreWidget(
                          onTap: (){
                            controller.latin.value = !controller.latin.value;
                            controller.update();
                          },text: "Latin",
                          theme: theme,context: context,icon:controller.latin.value?Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,),
                        Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Visibility(
                            visible: controller.latin.value,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 12),
                              decoration: BoxDecoration(
                                  // image: DecorationImage(
                                  //     image: AssetImage("assets/buttonBg.png"),
                                  //     fit: BoxFit.fill
                                  // ),
                                  color: DynamicColor.dropDownClr,
                                  borderRadius: BorderRadius.circular(8),
                                  // border: Border.all(color: theme.primaryColor,)
                              ),
                              child: ListView.builder(
                                  itemCount: controller.latinList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context,index){
                                    return Row(
                                      children: [
                                        Text(controller.latinList[index].text.toString(),
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
                                          child: Checkbox(activeColor: DynamicColor.lightRedClr,
                                            value: controller.latinList[index].condition!.value,
                                            onChanged: (v){
                                            controller.latinList[index].condition!.value = v!;
                                            controller.update();
                                          }),
                                        )
                                      ],
                                    );
                                  }),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        musicGenreWidget(
                          onTap: (){
                            controller.jazz.value = !controller.jazz.value;
                            controller.update();
                          },text: "Jazz",
                          theme: theme,context: context,icon:controller.jazz.value?Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,),
                        Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Visibility(
                            visible: controller.jazz.value,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 12),
                              decoration: BoxDecoration(
                                  // image: DecorationImage(
                                  //     image: AssetImage("assets/buttonBg.png"),
                                  //     fit: BoxFit.fill
                                  // ),
                                  color: DynamicColor.dropDownClr,
                                  borderRadius: BorderRadius.circular(8),
                                  // border: Border.all(color: theme.primaryColor,)
                              ),
                              child: ListView.builder(
                                  itemCount: controller.jazzList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context,index){
                                    return Row(
                                      children: [
                                        Text(controller.jazzList[index].text.toString(),
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
                                          child:   Checkbox(activeColor: DynamicColor.lightRedClr,
                                              value: controller.jazzList[index].condition!.value, onChanged: (v){
                                                controller.jazzList[index].condition!.value = v!;
                                                controller.update();
                                          }),
                                        )
                                      ],
                                    );
                                  }),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        musicGenreWidget(
                          onTap: (){
                            controller.country.value = !controller.country.value;
                            controller.update();
                          },text: "Country",
                          theme: theme,context: context,icon:controller.country.value?Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,),
                        Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Visibility(
                            visible: controller.country.value,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 12),
                              decoration: BoxDecoration(
                                  // image: DecorationImage(
                                  //     image: AssetImage("assets/buttonBg.png"),
                                  //     fit: BoxFit.fill
                                  // ),
                                  color: DynamicColor.dropDownClr,
                                  borderRadius: BorderRadius.circular(8),
                                  // border: Border.all(color: theme.primaryColor,)
                              ),
                              child: ListView.builder(
                                  itemCount: controller.countryList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context,index){
                                    return Row(
                                      children: [
                                        Text(controller.countryList[index].text.toString(),
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
                                          child:   Checkbox(activeColor: DynamicColor.lightRedClr,
                                              value: controller.countryList[index].condition!.value, onChanged: (v){
                                                controller.countryList[index].condition!.value = v!;
                                                controller.update();
                                          }),
                                        )
                                      ],
                                    );
                                  }),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        musicGenreWidget(
                          onTap: (){
                            controller.dance.value = !controller.dance.value;
                            controller.update();
                          },text: "Dance\$EDM",
                          theme: theme,context: context,icon:controller.dance.value?Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,),
                        Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Visibility(
                            visible: controller.dance.value,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 12),
                              decoration: BoxDecoration(
                                  // image: DecorationImage(
                                  //     image: AssetImage("assets/buttonBg.png"),
                                  //     fit: BoxFit.fill
                                  // ),
                                  color: DynamicColor.dropDownClr,
                                  borderRadius: BorderRadius.circular(8),
                                  // border: Border.all(color: theme.primaryColor,)
                              ),
                              child: ListView.builder(
                                  itemCount: controller.danceList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context,index){
                                    return Row(
                                      children: [
                                        Text(controller.danceList[index].text.toString(),
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
                                          child:   Checkbox(activeColor: DynamicColor.lightRedClr,
                                              value: controller.danceList[index].condition!.value,
                                              onChanged: (v){
                                                controller.danceList[index].condition!.value = v!;
                                                controller.update();
                                          }),
                                        )
                                      ],
                                    );
                                  }),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        musicGenreWidget(
                          onTap: (){
                            controller.international.value = !controller.international.value;
                            controller.update();
                          },text: "International",
                          theme: theme,context: context,icon:controller.international.value?Icons.keyboard_arrow_up: Icons.keyboard_arrow_down,),
                        Padding(
                          padding: EdgeInsets.only(top: 4.0),
                          child: Visibility(
                            visible: controller.international.value,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 12),
                              decoration: BoxDecoration(
                                  // image: DecorationImage(
                                  //     image: AssetImage("assets/buttonBg.png"),
                                  //     fit: BoxFit.fill
                                  // ),
                                  borderRadius: BorderRadius.circular(8),
                               color: DynamicColor.dropDownClr
                                  // border: Border.all(color: theme.primaryColor,)
                              ),
                              child: ListView.builder(
                                  itemCount: controller.internationalList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context,index){
                                    return Row(
                                      children: [
                                        Text(controller.internationalList[index].text.toString(),
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
                                          child:   Checkbox(activeColor: DynamicColor.lightRedClr,
                                              value: controller.internationalList[index].condition!.value,
                                              onChanged: (v){
                                                controller.internationalList[index].condition!.value = v!;
                                                controller.update();
                                          }),
                                        )
                                      ],
                                    );
                                  }),
                            ),
                          ),
                        ),
                        SizedBox(
                          height:controller.addForEvent.isEmpty?0: kToolbarHeight*1.3,
                        )
                      ],
                    ),
                  ),
                ),
                controller.addForEvent.isEmpty? SizedBox.shrink():Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    color: DynamicColor.darkGrayClr,
                    width: Get.width,
                    height: kToolbarHeight*1.3,
                    child: ListView.builder(
                        itemCount: controller.addForEvent.length,
                        shrinkWrap: true,
                        physics: AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context,index){
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.0),
                        child: Center(
                          child: Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
                            decoration: BoxDecoration(
                                color: DynamicColor.whiteClr,
                                borderRadius: BorderRadius.circular(8)
                            ),
                            child: Center(
                              child: Text(controller.addForEvent[index].toString()),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                )
              ],
            );
          }
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
        child: CustomButton(
          borderClr: Colors.transparent,
          onTap: (){
            Get.toNamed(Routes.musicChoiceScreen);
          },
          text: "Continue",
        ),
      ),
    );
  }

  Widget musicGenreWidget({context,theme,text,GestureTapCallback? onTap,IconData? icon}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/buttonBg.png"),
              fit: BoxFit.fill
          ),
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