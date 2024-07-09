


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class ChatRoom extends StatelessWidget {
  ChatRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme,text: "Message Center"),
      body: ListView.builder(
          itemCount: list.length,
          shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context,index){
        return GestureDetector(
          onTap: (){
            Get.toNamed(Routes.chatCenterScreen,
              arguments: {
                "onGoing": 'onoing'
              }
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6.0),
            child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(list[index].img.toString()),
                ),
                title: Text(list[index].name.toString(),
                style: poppinsMediumStyle(
                  fontSize: 14,
                  context: context,
                  color: theme.primaryColor,
                ),),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(list[index].location.toString(),
                      style: poppinsMediumStyle(
                        fontSize: 10,
                        context: context,
                        color: DynamicColor.grayClr.withOpacity(0.9),
                      ),),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(text: 'Status -',
                          style: poppinsRegularStyle(
                            fontSize: 10,
                            context: context,
                            color: DynamicColor.lightRedClr
                          ),
                          ),
                          TextSpan(text: ' Pending',
                              style: poppinsRegularStyle(
                                  fontSize: 10,
                                  context: context,
                                  color: DynamicColor.lightYellowClr
                              ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: DynamicColor.yellowClr,
                      child: Text("12",
                      style: poppinsRegularStyle(
                        fontSize: 10,
                        color: theme.primaryColor,
                        context: context
                      ),
                      ),
                    ),
                    CustomButton(
                      widths: 60,
                      color2: Colors.transparent,
                      color1: Colors.transparent,
                      backgroundClr: false,
                      borderClr: Colors.transparent,
                      heights: 20,
                      fontSized: 10,
                      text:"10:31am" ,
                    )
                  ],
                ),
              ),
                Divider(
                  thickness: 1,
                  color: DynamicColor.grayClr,
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  List<ChatRoomClass> list = [
    ChatRoomClass(time: "10:23am",name: "Michael Logan",location: "Herkimer County Fairgrounds",img: "assets/venueImg.png",),
    ChatRoomClass(time: "10:23am",name: "Michael Logan",location: "Herkimer County Fairgrounds",img: "assets/venueImg.png",),
    ChatRoomClass(time: "10:23am",name: "Michael Logan",location: "Herkimer County Fairgrounds",img: "assets/venueImg.png",),
    ChatRoomClass(time: "10:23am",name: "Michael Logan",location: "Herkimer County Fairgrounds",img: "assets/venueImg.png",),
    ChatRoomClass(time: "10:23am",name: "Michael Logan",location: "Herkimer County Fairgrounds",img: "assets/venueImg.png",),
    ChatRoomClass(time: "10:23am",name: "Michael Logan",location: "Herkimer County Fairgrounds",img: "assets/venueImg.png",),
    ChatRoomClass(time: "10:23am",name: "Michael Logan",location: "Herkimer County Fairgrounds",img: "assets/venueImg.png",),
    ChatRoomClass(time: "10:23am",name: "Michael Logan",location: "Herkimer County Fairgrounds",img: "assets/venueImg.png",),
  ];
}


class ChatRoomClass{
  String? img,name,location,unreadMessage,time;
  ChatRoomClass({this.img,this.location,this.time,this.name,this.unreadMessage});
}