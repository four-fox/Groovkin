

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/chatView/chatController.dart';

import '../Components/textStyle.dart';
import '../Routes/app_pages.dart';
import 'chatRoomModel.dart';

class ChatRoomScreen extends StatelessWidget {
  ChatRoomScreen({super.key});

  final ChatController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: GestureDetector(
        onTap: (){
          Get.toNamed(Routes.chatNewUserScreen);
        },
        child: Container(
          height: 35,
          width: 120,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            // color: Colors.amberAccent
              color: DynamicColor.darkGrayClr,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.primaryColor,
              )),
          child: Center(
            child: Text(
              "New Chat",
              style: poppinsMediumStyle(
                fontSize: 14,
                context: context,
                color: theme.primaryColor,
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        leading:Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 12.0),
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: ImageIcon(
                AssetImage("assets/backArrow.png"),
                color: theme.primaryColor,
              ),
            ),
          ),
        ),
        title: Text(
          "Inbox",
          style: poppinsMediumStyle(
            fontSize: 17,
            context: context,
            color: theme.primaryColor,
          ),
        ),
      ),
      body: GetBuilder<ChatController>(
        initState: (v){
          _controller.getAllChatRoom();
        },
        builder: (controller) {
          return controller.getAllChatRoomLoader.value==false?SizedBox.shrink(): ListView.builder(
              itemCount: controller.chatRoomData!.data!.data!.length,
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (BuildContext context,index){
                ChatRoomObject chatRoomData = controller.chatRoomData!.data!.data![index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: ListTile(
                onTap: (){
                  Get.toNamed(Routes.chatInnerScreen,
                      arguments: {
                        "userData": chatRoomData.user
                      }
                  )!.then((onValue) => controller.getAllChatRoom());
                },
                shape: Border(
                  bottom: BorderSide(color: theme.primaryColor.withOpacity(0.7)),
                ),
                leading: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(chatRoomData.user!.profilePicture!),
                ),
                title: Text(
                  chatRoomData.user!.profile!.fullName!,
                  style: poppinsRegularStyle(
                    fontSize: 14,
                    context: context,
                    fontWeight: FontWeight.w600,
                    color: theme.primaryColor,
                  ),
                ),
                subtitle:chatRoomData.lastMessage!.media !=null?Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.photo)): Text(
                  chatRoomData.lastMessage!.sourceId !=null?"": chatRoomData.lastMessage!.msg!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: poppinsRegularStyle(
                    fontSize: chatRoomData.lastMessage!.sourceId !=null?16: 14,
                    context: context,
                    fontWeight: chatRoomData.lastMessage!.sourceId !=null?FontWeight.w700: FontWeight.w600,
                    color: theme.primaryColor.withOpacity(0.8),
                  ),
                ),
              ),
            );
          });
        }
      ),
    );
  }
}
