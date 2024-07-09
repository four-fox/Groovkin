// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/alertmessage.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class InviteFriendsInGroups extends StatelessWidget {
  InviteFriendsInGroups({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight*3.1),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: kToolbarHeight*1.4,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/grayClor.png"),
                        fit: BoxFit.fill
                    )
                ),
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Center(
                        child: Text("Invite your friends",
                          style: poppinsMediumStyle(
                            fontSize: 17,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child:
                        ImageIcon(AssetImage("assets/backArrow.png"),
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 18),
                child: Text("Send an invitation to your Friends!",
                  style: poppinsRegularStyle(
                    fontSize: 14,
                    color: DynamicColor.lightRedClr,
                    context: context,
                  ),
                )
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: TextFormField(
                  style: poppinsRegularStyle(
                      fontSize: 12,
                      color: DynamicColor.grayClr
                  ),
                  decoration: InputDecoration(
                    border:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: DynamicColor.grayClr),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: DynamicColor.grayClr),//<-- SEE HERE
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: DynamicColor.grayClr),//<-- SEE HERE
                    ),
                    hintText:"title",
                    contentPadding: EdgeInsets.only(left: 12,top: 12),
                    hintStyle: poppinsRegularStyle(
                        fontSize: 12,
                        color: DynamicColor.grayClr
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ]),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: ListView.builder(
            itemCount: list.length,
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext context,index){
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0,horizontal: 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage("assets/profileImg.png"),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text("The Squad",
                            style: poppinsRegularStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                context: context,
                                color: theme.primaryColor,
                            ),
                          ),
                        ),
                        Spacer(),
                        CircleAvatar(
                          radius: 17,
                          backgroundColor: DynamicColor.grayClr.withOpacity(0.6),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor: Colors.white,
                            ),
                            child: Obx(
                                  ()=> Checkbox(
                                  activeColor: DynamicColor.lightRedClr,
                                  value: list[index].value, onChanged: (v){
                                list[index].value = v;
                              }),
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(
                      thickness: 1.2,
                      color: DynamicColor.grayClr,
                    )
                  ],
                ),
              );
            }),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
        child: CustomButton(
          borderClr: Colors.transparent,
          onTap: (){
Future.delayed(Duration(seconds: 2),(){
  Get.offAllNamed(Routes.userBottomNavigationNav);
});
            showDialog(
                barrierColor: Colors.transparent,
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return AlertWidget(
                      height: Get.height/2.5,
                    container: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image(image: AssetImage("assets/sendNotify.png")),
                        Text("Send Notify",
                          style: poppinsMediumStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: theme.primaryColor,
                              context: context
                          ),
                        )
                      ],
                    ),
                  );
                });
          },
          text: "Notify",
        ),
      ),
    );
  }
  List list = [false.obs,false.obs,false.obs,false.obs,false.obs,false.obs,false.obs,false.obs,false.obs,false.obs,false.obs,false.obs,false.obs,false.obs,false.obs,];

}
