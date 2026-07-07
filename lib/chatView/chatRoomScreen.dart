import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/chatView/chatController.dart';
import 'package:groovkin/main.dart';

import '../Components/textFields.dart';
import '../Components/textStyle.dart';
import '../Routes/app_pages.dart';
import 'chatRoomModel.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final ChatController _controller = Get.find();

  Timer? onStoppedTyping;

  _onChangeHandler() {
    const duration = Duration(
        milliseconds:
            800); // set the duration that you want call stopTyping() after that.
    onStoppedTyping = Timer(duration, () => stopTyping());
  }

  stopTyping() {
    _controller.getAllChatRoom();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          Get.toNamed(Routes.chatNewUserScreen);
        },
        child: Container(
          height: 35,
          width: 120,
          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                color: theme.cardColor,
              ),
            ),
          ),
        ),
      ),
      appBar: customAppBar(text: "Inbox", theme: theme),
      body: GetBuilder<ChatController>(initState: (v) {
        _controller.chatRoomDataController.clear();
        _controller.getAllChatRoom();
      }, builder: (controller) {
        return NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification.metrics.pixels ==
                scrollNotification.metrics.maxScrollExtent) {
              if (controller.getAllChatRoomWait == false) {
                controller.getAllChatRoomWait = true;
                if (controller.chatRoomData!.data!.nextPageUrl != null) {
                  String link = controller.chatRoomData!.data!.nextPageUrl!;
                  controller.getNewUser(nextUrl: link);
                  return true;
                }
              }
              return false;
            }
            return false;
          },
          child: controller.getAllChatRoomLoader.value == false
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      color: isDark(context)
                          ? DynamicColor.blackClr
                          : DynamicColor.whiteClr,
                      child: SearchTextFields(
                        borderRadius: 12,
                        controller: controller.chatRoomDataController,
                        bgColor: isDark(context)
                            ? DynamicColor.blackClr
                            : DynamicColor.whiteClr,
                        onChanged: (v) {
                          if (v != "") {
                            _onChangeHandler();
                          } else {
                            controller.chatRoomDataController.clear();
                            _onChangeHandler();
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: controller.chatRoomData!.data!.data!.isEmpty
                          ? Center(
                              child: Text(
                                "No Data",
                                style: poppinsMediumStyle(
                                  fontSize: 17,
                                  context: context,
                                  color: isDark(context)
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount:
                                  controller.chatRoomData!.data!.data!.length,
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, index) {
                                ChatRoomObject chatRoomData =
                                    controller.chatRoomData!.data!.data![index];

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: ListTile(
                                    onTap: () {
                                      Get.toNamed(Routes.chatInnerScreen,
                                              arguments: {
                                            "userData": chatRoomData.user
                                          })!
                                          .then((onValue) =>
                                              controller.getAllChatRoom());
                                    },
                                    shape: Border(
                                      bottom: BorderSide(
                                          color: theme.primaryColor
                                              .withValues(alpha: 0.7)),
                                    ),
                                    leading: CircleAvatar(
                                      radius: 25,
                                      backgroundImage: NetworkImage(
                                          chatRoomData.user!.profilePicture!),
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
                                    subtitle:
                                        ((chatRoomData.lastMessage!.media !=
                                                    null) &&
                                                chatRoomData.lastMessage!
                                                        .isDeleted ==
                                                    0)
                                            ? const Align(
                                                alignment: Alignment.centerLeft,
                                                child: Icon(Icons.photo))
                                            : Text(
                                                chatRoomData.lastMessage!
                                                            .isDeleted ==
                                                        1
                                                    ? "Message have been deleted"
                                                    : chatRoomData.lastMessage!
                                                                .sourceId !=
                                                            null
                                                        ? "created event message"
                                                        : chatRoomData
                                                            .lastMessage!.msg!,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: poppinsRegularStyle(
                                                  fontSize: ((chatRoomData
                                                                  .lastMessage!
                                                                  .sourceId !=
                                                              null) &&
                                                          (chatRoomData
                                                                  .lastMessage!
                                                                  .isDeleted ==
                                                              0))
                                                      ? 16
                                                      : 14,
                                                  context: context,
                                                  fontWeight: chatRoomData
                                                              .lastMessage!
                                                              .sourceId !=
                                                          null
                                                      ? FontWeight.w700
                                                      : FontWeight.w600,
                                                  color: theme.primaryColor
                                                      .withValues(alpha: 0.8),
                                                ),
                                              ),
                                  ),
                                );
                              }),
                    ),
                  ],
                ),
        );
      }),
    );
  }
}
