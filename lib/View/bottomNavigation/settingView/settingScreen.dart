// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/Network/Url.dart';
import 'package:groovkin/Components/alertmessage.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:intl/intl.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  RxBool switchValue = false.obs;

  RxBool switchProfileValue = false.obs;

  late AuthController _authController;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<AuthController>()) {
      _authController = Get.find<AuthController>();
    } else {
      _authController = Get.put(AuthController());
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: GetBuilder<AuthController>(initState: (v) {
        _authController.getProfile(userId: API().sp.read("userId"));
      }, builder: (controller) {
        return controller.getProfileLoader.value == false
            ? const SizedBox.shrink()
            : Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight * 2.4),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: sp.read("role") == "User"
                          ? const BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                            )
                          : null,
                      border: sp.read("role") == "eventOrganizer"
                          ? Border(
                              bottom: BorderSide(
                                  width: 4.0,
                                  color: DynamicColor.grayClr.withOpacity(0.6)),
                            )
                          : null,
                      image: const DecorationImage(
                          image: AssetImage("assets/grayClor.png"),
                          fit: BoxFit.fill),
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          Container(
                            height: kToolbarHeight * 1.2,
                            // padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: DynamicColor.blackClr,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: DynamicColor.lightYellowClr),
                              // image: DecorationImage(
                              //   image: NetworkImage(Url().imageUrl+controller.userData!.data!.profilePicture!.mediaPath!),
                              //   fit: BoxFit.contain,
                              // )
                            ),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                controller.userData!.data?.profilePicture !=
                                        null
                                    ? "${Url().imageUrl}${controller.userData?.data?.profilePicture?.mediaPath}"
                                    : groupPlaceholder,
                              ),
                            ),
                          ),
                          Text(
                            controller.userData!.data!.name!,
                            style: poppinsMediumStyle(
                              context: context,
                              fontSize: 16,
                              color: theme.primaryColor,
                            ),
                          ),
                          if (controller.userData!.data!.profile != null)
                            Text(
                              'Member since ${DateFormat.MMMd().format(controller.userData!.data!.profile!.createdAt!)}',
                              style: poppinsMediumStyle(
                                  context: context,
                                  fontSize: 10,
                                  color: DynamicColor.grayClr.withOpacity(0.9)),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        customWidget(
                            context: context,
                            onTap: () {
                              // Get.toNamed(Routes.profileScreen);
                              sp.read("role") == "eventOrganizer"
                                  ? Get.toNamed(Routes.viewProfileScreen,
                                      arguments: {
                                          "venueDetails": null,
                                          "venueId": null,
                                        })
                                  : Get.toNamed(Routes.viewProfileScreen,
                                      arguments: {
                                          "eventDetails": null,
                                          "eventId": null,
                                        });
                            }),
                        // sp.read("role") =="eventOrganizer"? customWidget(context: context,
                        //  img: "assets/venueLocation.png",
                        //    text: "Notes for Venue page",
                        //    onTap: (){
                        //      Get.toNamed(Routes.venueScreen);
                        //    }
                        //  ):SizedBox.shrink(),
                        API().sp.read("role") != "User"
                            ? customWidget(
                                context: context,
                                img: "assets/messageCenter.png",
                                text: "Message Center",
                                onTap: () {
                                  Get.toNamed(Routes.chatRoom);
                                })
                            : const SizedBox.shrink(),
                        // sp.read("role") =="User"?SizedBox.shrink(): customWidget(context: context,
                        // img: "assets/following.png",
                        //   text: "Following",
                        //   onTap: (){
                        //   Get.toNamed(Routes.followingScreen);
                        //   }
                        // ),

                        customWidget(
                            context: context,
                            img: "assets/lock.png",
                            text: "Change Password",
                            onTap: () {
                              Get.toNamed(Routes.newPasswordScreen);
                              // Get.toNamed(Routes.sendEmailForOtp);
                            }),

                        // Obx(
                        //   () => customWidget(
                        //       context: context,
                        //       img: "assets/switchIcon.png",
                        //       text: "Switch Profile",
                        //       toggleCondition: true,
                        //       switchCondition: switchProfileValue.value,
                        //       onChanged: (v) {
                        //         print(API().sp.read("role"));
                        //         switchProfileValue.value = v;
                        //         if (API().sp.read("role") == "User") {
                        //           API().sp.write('role', 'eventOrganizer');
                        //           Get.offAllNamed(Routes.switchProfileScreen);
                        //         }
                        //       }),
                        // ),

                        Obx(
                          () => customWidget(
                              context: context,
                              img: "assets/themeIcon.png",
                              text: "Light & Dark Mood",
                              toggleCondition: true,
                              switchCondition: switchValue.value,
                              onChanged: (v) {
                                switchValue.value = v;
                              }),
                        ),

                        if (API().sp.read("currentRole") != "User")
                          customWidget(
                              context: context,
                              img: "assets/switchIcon.png",
                              text: "Switch Role",
                              onTap: () {
                                if (API().sp.read("role") == "eventOrganizer" &&
                                    API().sp.read("currentRole") ==
                                        "eventOrganizer") {
                                  controller.changeRoles(ChangeRole.user);
                                  BotToast.showText(
                                      text: "Change Role to User");
                                } else if (API().sp.read("role") == "User" &&
                                    API().sp.read("currentRole") ==
                                        "eventOrganizer") {
                                  controller.changeRoles(ChangeRole.organizer);
                                  BotToast.showText(
                                      text: "Change Role to Event Organizer");
                                }
                                if (API().sp.read("role") == "eventManager" &&
                                    API().sp.read("currentRole") ==
                                        "eventManager") {
                                  controller.changeRoles(ChangeRole.user);
                                  BotToast.showText(
                                      text: "Change Role to User");
                                } else if (API().sp.read("role") == "User" &&
                                    API().sp.read("currentRole") ==
                                        "eventManager") {
                                  controller.changeRoles(ChangeRole.manager);
                                  BotToast.showText(
                                      text: "Change Role to Event Organizer");
                                }

                                // showModalBottomSheet(
                                //     shape: RoundedRectangleBorder(
                                //         borderRadius:
                                //             BorderRadius.circular(12.0)),
                                //     context: context,
                                //     builder: (context) {
                                //       return SafeArea(
                                //         child: Column(
                                //           mainAxisSize: MainAxisSize.min,
                                //           children: [
                                //             API().sp.read("role") == "User"
                                //                 ? SizedBox()
                                //                 : ListTile(
                                //                     shape:
                                //                         RoundedRectangleBorder(
                                //                             borderRadius:
                                //                                 BorderRadius
                                //                                     .circular(
                                //                                         12.0)),
                                //                     onTap: () {
                                //                       Navigator.pop(context);
                                //                       controller.changeRoles(
                                //                           ChangeRole.user);
                                //                     },
                                //                     title: Text("User"),
                                //                   ),
                                //             API().sp.read("role") ==
                                //                     "eventOrganizer"
                                //                 ? SizedBox()
                                //                 : ListTile(
                                //                     shape:
                                //                         RoundedRectangleBorder(
                                //                             borderRadius:
                                //                                 BorderRadius
                                //                                     .circular(
                                //                                         12.0)),
                                //                     onTap: () {
                                //                       Navigator.pop(context);
                                //                       controller.changeRoles(
                                //                           ChangeRole.organizer);
                                //                     },
                                //                     title:
                                //                         Text("Event Organizer"),
                                //                   ),
                                //             API().sp.read("role") ==
                                //                     "eventManager"
                                //                 ? SizedBox()
                                //                 : ListTile(
                                //                     shape:
                                //                         RoundedRectangleBorder(
                                //                             borderRadius:
                                //                                 BorderRadius
                                //                                     .circular(
                                //                                         12.0)),
                                //                     onTap: () {
                                //                       Navigator.pop(context);
                                //                       controller.changeRoles(
                                //                           ChangeRole.manager);
                                //                     },
                                //                     title:
                                //                         Text("Venue Manager"),
                                //                   ),
                                //           ],
                                //         ),
                                //       );
                                //     });
                                // if (API().sp.read("role") == "eventManager") {
                                //   controller.changeRoles(ChangeRole.organizer);
                                // } else {
                                //   controller.changeRoles(ChangeRole.manager);
                                // }
                              }),
                        API().sp.read("role") != "User"
                            ? customWidget(
                                context: context,
                                img: "assets/groovkinInvite.png",
                                text: "Groovkin Invites",
                                onTap: () {
                                  Get.toNamed(Routes.groovkinInviteScreen);
                                })
                            : const SizedBox.shrink(),
                        API().sp.read("role") == "User"
                            ? customWidget(
                                context: context,
                                img: "assets/groovkin.png",
                                text: "My Groovkin",
                                onTap: () {
                                  Get.toNamed(Routes.userMyGroovkinScreen);
                                })
                            : const SizedBox.shrink(),
                        API().sp.read("role") == "User"
                            ? customWidget(
                                context: context,
                                img: "assets/groovkinInvitePic.png",
                                text: "Groovkin Invite",
                                onTap: () {
                                  Get.toNamed(Routes.groovkinInviteScreen);
                                })
                            : const SizedBox.shrink(),
                        API().sp.read("role") == "eventOrganizer"
                            ? customWidget(
                                context: context,
                                img: "assets/groovkinInvite.png",
                                text: "My Tag Collection",
                                iconText: true,
                                onTap: () {
                                  Get.toNamed(Routes.myTagCollection);
                                })
                            : const SizedBox.shrink(),
                        API().sp.read("currentRole") == "eventOrganizer"
                            ? customWidget(
                                context: context,
                                text: "Subscription",
                                iconShow: false,
                                onTap: () {
                                  Get.toNamed(Routes.subscriptionScreen,
                                      arguments: {"isFromSettingScreen": true});
                                })
                            : const SizedBox(),

                        sp.read("role") == "User"
                            ? const SizedBox.shrink()
                            : customWidget(
                                context: context,
                                img: "assets/paymentMethods.png",
                                text: "Wallet",
                                iconShow: true,
                                onTap: () {
                                  Get.toNamed(Routes.transactionScreen);
                                  // Get.toNamed(Routes.paymentMethodScreen,
                                  // arguments: {
                                  //   "paymentMethod": 2
                                  // }
                                  // );
                                }),

                        SizedBox(
                          height: API().sp.read("role") == "eventOrganizer"
                              ? 30
                              : 90,
                        ),
                        GestureDetector(
                          onTap: () {
                            customAlertt(
                                alignment: Alignment.topLeft,
                                title: 'Logout',
                                text: 'Are you sure you want to logout?',
                                cancelAlert: 'No',
                                btnSuccess: 'Yes',
                                onTap: () async {
                                  await controller.logout();
                                });
                          },
                          child: Container(
                              height: 48,
                              width: Get.width,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                    image: AssetImage("assets/buttonBg.png"),
                                    fit: BoxFit.fill),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ImageIcon(
                                    const AssetImage("assets/logoutIcon.png"),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  Text(
                                    "Logout",
                                    style: poppinsMediumStyle(
                                      context: context,
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            customAlertt(
                                alignment: Alignment.topLeft,
                                title: 'Delete Account',
                                text: 'Are you sure you want to Delete?',
                                cancelAlert: 'No',
                                btnSuccess: 'Yes',
                                onTap: () {
                                  Get.back();
                                  controller.deleteAccount();
                                });
                          },
                          child: Container(
                              height: 48,
                              width: Get.width,
                              decoration: BoxDecoration(
                                image: const DecorationImage(
                                  image: AssetImage("assets/buttonBg.png"),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    "Delete Account",
                                    style: poppinsMediumStyle(
                                      context: context,
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              )),
                        ),
                        const SizedBox(
                          height: kToolbarHeight * 1.2,
                        ),
                      ],
                    ),
                  ),
                ),
              );
      }),
    );
  }

  Widget customWidget(
      {img,
      context,
      text,
      bool iconText = false,
      GestureTapCallback? onTap,
      bool toggleCondition = false,
      switchCondition,
      ValueChanged<bool>? onChanged,
      bool iconShow = false}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                iconText == false
                    ? Image(
                        image: AssetImage(img ?? "assets/profileIcon.png"),
                      )
                    : Text(
                        "#",
                        style: poppinsMediumStyle(
                          fontSize: 18,
                          context: context,
                          color: DynamicColor.lightYellowClr.withOpacity(0.8),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0, top: 4),
                  child: Text(
                    text ?? "Profile",
                    style: poppinsMediumStyle(
                      fontSize: 16,
                      context: context,
                      color: DynamicColor.grayClr.withOpacity(0.7),
                    ),
                  ),
                ),
                const Spacer(),
                toggleCondition == false
                    ? iconShow == true
                        ? const SizedBox.shrink()
                        : Icon(
                            Icons.arrow_forward_ios,
                            color: DynamicColor.grayClr.withOpacity(0.7),
                          )
                    : SizedBox(
                        height: 30,
                        child: Switch(
                            inactiveThumbColor: DynamicColor.yellowClr,
                            activeColor: DynamicColor.yellowClr,
                            inactiveTrackColor: DynamicColor.whiteClr,
                            activeTrackColor: DynamicColor.whiteClr,
                            value: switchCondition,
                            onChanged: onChanged),
                      )
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Divider(
              color: DynamicColor.grayClr.withOpacity(0.7),
              thickness: 1.2,
            ),
          ],
        ),
      ),
    );
  }
}
