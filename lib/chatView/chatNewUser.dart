import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Components/colors.dart';
import '../Components/textFields.dart';
import '../Components/textStyle.dart';
import '../Routes/app_pages.dart';
import 'chatController.dart';
import 'chatNewUserModel.dart';

class ChatNewUserScreen extends StatelessWidget {
  ChatNewUserScreen({super.key});

  final ChatController _controller = Get.find();

  Timer? onStoppedTyping;

  _onChangeHandler() {
    const duration = Duration(
        milliseconds:
            800); // set the duration that you want call stopTyping() after that.
    onStoppedTyping = Timer(duration, () => stopTyping());
  }

  stopTyping() {
    _controller.getNewUser();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: ImageIcon(
                const AssetImage("assets/backArrow.png"),
                color: theme.primaryColor,
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Chat",
          style: poppinsMediumStyle(
            fontSize: 17,
            context: context,
            color: theme.primaryColor,
          ),
        ),
      ),
      body: GetBuilder<ChatController>(initState: (v) {
        _controller.getNewUser();
      }, builder: (controller) {
        return NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification.metrics.pixels ==
                scrollNotification.metrics.maxScrollExtent) {
              if (controller.getNewUserWait == false) {
                controller.getNewUserWait = true;
                if (controller.newUserData!.data!.nextPageUrl != null) {
                  String link = controller.newUserData!.data!.nextPageUrl!;
                  controller.getNewUser(nextUrl: link);
                  return true;
                }
              }
              return false;
            }
            return false;
          },
          child: controller.newUserChatLoader.value == true
              ? const SizedBox.shrink()
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      color: DynamicColor.blackClr,
                      child: SearchTextFields(
                        borderRadius: 12,
                        controller: controller.searchingController,
                        bgColor: DynamicColor.blackClr,
                        // readOnly: true,
                        onChanged: (v) {
                          if (v != "") {
                            _onChangeHandler();
                          } else {
                            controller.searchingController.clear();
                            _onChangeHandler();
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: controller.newUserData!.data!.data!.isEmpty
                          ? Center(
                              child: Text(
                                "No Data",
                                style: poppinsMediumStyle(
                                  fontSize: 17,
                                  context: context,
                                  color: theme.primaryColor,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount:
                                  controller.newUserData!.data!.data!.length,
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, index) {
                                UserData userDataa =
                                    controller.newUserData!.data!.data![index];
                                return GestureDetector(
                                  onTap: () {
                                    Get.toNamed(Routes.chatInnerScreen,
                                        arguments: {"userData": userDataa});
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: ListTile(
                                      shape: Border(
                                        bottom: BorderSide(
                                            color: theme.primaryColor
                                                .withOpacity(0.7)),
                                      ),
                                      leading: CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(
                                            userDataa.profilePicture!),
                                      ),
                                      title: Text(
                                        "${userDataa.profile!.fullName}",
                                        style: poppinsRegularStyle(
                                          fontSize: 14,
                                          context: context,
                                          fontWeight: FontWeight.w600,
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                      subtitle: Text(
                                        userDataa.email!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: poppinsRegularStyle(
                                          fontSize: 14,
                                          context: context,
                                          color: theme.primaryColor
                                              .withOpacity(0.8),
                                        ),
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
