// ignore_for_file: sort_child_properties_last

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/Url.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/chatView/seenUnseenWidgets.dart';
import 'package:swipe_to/swipe_to.dart';

import '../Components/Network/API.dart';
import '../Components/switchWidget.dart';
import '../Components/textStyle.dart';
import '../Components/timeAgoWidget.dart';
import '../Routes/app_pages.dart';
import 'chatController.dart';
import 'chatInnerDataModel.dart';
import 'chatInnerScreen.dart';

Widget messageWidget(
    {ctx,
    ChatData? element,
    index,
    required ChatController controller,
    tapDownPosition,
    imageList}) {
  var theme = Theme.of(ctx);

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: SwipeTo(
      onRightSwipe: (v) {
        if (controller.chatData!.data!.data![index].isDeleted == 0) {
          controller.isReplying(true);
          controller.replyModel = controller.chatData!.data!.data![index];
          controller.replyId =
              controller.chatData!.data!.data![index].id.toString();
          if (controller.multipleImageList.isNotEmpty) {
            controller.multipleImageList.clear();
          }
          // controller.bottomContainer(true);
          controller.bottomContainer(!controller.bottomContainer.value);
          controller.fieldUpdate(false);
        }
        controller.update();
      },
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          tapDownPosition = details.globalPosition;
        },
        onLongPress: () {
          onLongPress(ctx, index, element, controller, tapDownPosition);
        },
        child: controller.chatData!.data!.data![index].sourceId != "null"
            ? controller.chatData!.data!.data![index].isDeleted == 1
                ? Align(
                    alignment:
                        controller.chatData!.data!.data![index].senderId !=
                                API().sp.read('userId')
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                    child: Container(
                      height: 55,
                      width: Get.width / 1.4,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.red.withValues(alpha:0.5),
                        // borderRadius: BorderRadius.circular(30)
                      ),
                      child: const Center(
                        child: Text(
                          "Message have been deleted",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Align(
                      alignment:
                          controller.chatData!.data!.data![index].senderId !=
                                  API().sp.read('userId')
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                      child: Container(
                        width: Get.width / 1.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: AssetImage("assets/grayClor.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, left: 8),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      Url().imageUrl +
                                          jsonDecode(controller
                                                  .chatData!
                                                  .data!
                                                  .data![index]
                                                  .event!)['banner_image']
                                              ['media_path'],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text(
                                      // jsonDecode(
                                      // jsonDecode(controller.chatData!.data!.data![index].parentChat!)['user'])['id']
                                      jsonDecode(controller
                                          .chatData!
                                          .data!
                                          .data![index]
                                          .event!)['venue']['venue_name'],
                                      style: poppinsMediumStyle(
                                        fontSize: 14,
                                        context: ctx,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: kToolbarHeight * 3,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              // height: kToolbarHeight*2,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        Url().imageUrl +
                                            jsonDecode(controller
                                                    .chatData!
                                                    .data!
                                                    .data![index]
                                                    .event!)['banner_image']
                                                ['media_path'],
                                        // jsonDecode(controller
                                        //         .chatData!
                                        //         .data!
                                        //         .data![index]
                                        //         .event!)['profile_picture']
                                        //     [0]['media_path'],
                                      ),
                                      fit: BoxFit.fill)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 8, top: 8),
                                        child: eventDateWidget(
                                            date:
                                                "${DateTime.parse(jsonDecode(controller.chatData!.data!.data![index].event!)['start_date_time']).day} ",
                                            day: formatShortMonth(jsonDecode(
                                                    controller.chatData!.data!
                                                        .data![index].event!)[
                                                'start_date_time']),
                                            theme: theme,
                                            context: ctx),
                                      )),
                                  locationWidget(
                                      text: jsonDecode(controller
                                          .chatData!
                                          .data!
                                          .data![index]
                                          .event!)['location'],
                                      theme: theme,
                                      context: ctx)
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, bottom: 6),
                              child: Text(
                                jsonDecode(controller.chatData!.data!
                                    .data![index].event!)['event_title'],
                                // "The Burning Cactus",
                                style: poppinsRegularStyle(
                                    fontSize: 11,
                                    context: ctx,
                                    color: DynamicColor.grayClr),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomButton(
                                onTap: () {
                                  Get.toNamed(Routes.upcomingScreen,
                                      arguments: {
                                        "eventId": int.parse(controller
                                            .chatData!
                                            .data!
                                            .data![index]
                                            .sourceId!),
                                        "reportedEventView": 1,
                                        "notInterestedBtn": 1,
                                        "appBarTitle": ""
                                        // "${singleEvent.status.toString().capitalize} Event"
                                      });
                                },
                                borderClr: Colors.transparent,
                                text: "View Details",
                              ),
                            ),
                            controller.chatData!.data!.data![index].senderId !=
                                    API().sp.read('userId')
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        right: 6.0, bottom: 6),
                                    child: SeenUnseenWidget(
                                      chatData: controller
                                          .chatData!.data!.data![index],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child:
                    controller.chatData!.data!.data![index].senderId !=
                            API().sp.read('userId')
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              controller.chatData!.data!.data![index]
                                          .isDeleted ==
                                      1
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      decoration: BoxDecoration(
                                          color: DynamicColor.grayClr,
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: const Center(
                                        child: Text(
                                          "Message have been deleted",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ),
                                    )
                                  : controller.chatData!.data!.data![index]
                                              .media !=
                                          null
                                      ? Flexible(
                                          flex: 3,
                                          child: Column(
                                            // alignment: Alignment.bottomRight,
                                            children: [
                                              Container(
                                                width: Get.width / 1.5,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  color: DynamicColor.grayClr,
                                                ),
                                                padding:
                                                    const EdgeInsets.all(6),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    controller
                                                                .chatData!
                                                                .data!
                                                                .data![index]
                                                                .parentChat ==
                                                            null
                                                        ? const SizedBox
                                                            .shrink()
                                                        : jsonDecode(controller
                                                                        .chatData!
                                                                        .data!
                                                                        .data![
                                                                            index]
                                                                        .parentChat!)[
                                                                    'media'] ==
                                                                null
                                                            ? const SizedBox
                                                                .shrink()
                                                            : GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  await controller
                                                                      .scroll(
                                                                          int.parse(
                                                                            json.decode(controller.chatData!.data!.data![index].parentChat!)['id'].toString(),
                                                                          ),
                                                                          index);
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          8.0),
                                                                  child:
                                                                      Container(
                                                                    width: Get
                                                                        .width,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                            border:
                                                                                Border(
                                                                              left: BorderSide(color: Colors.white, width: 5),
                                                                            ),
                                                                            color:
                                                                                Colors.grey),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          jsonDecode(jsonDecode(controller.chatData!.data!.data![index].parentChat!)['user'])['id'] == API().sp.read("userId")
                                                                              ? "You"
                                                                              : jsonDecode(jsonDecode(controller.chatData!.data!.data![index].parentChat!)['user'])['name'],
                                                                          style:
                                                                              const TextStyle(fontSize: 12),
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                              55,
                                                                          width:
                                                                              60,
                                                                          decoration: BoxDecoration(
                                                                              image: DecorationImage(
                                                                                  image: NetworkImage(
                                                                                    Url().imageUrl + (jsonDecode(jsonDecode(controller.chatData!.data!.data![index].parentChat!)['media'])[0]['filename']),
                                                                                  ),
                                                                                  fit: BoxFit.fill)),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                    controller
                                                                .chatData!
                                                                .data!
                                                                .data![index]
                                                                .media !=
                                                            null
                                                        ? Container(
                                                            constraints: BoxConstraints(
                                                                maxWidth: 270,
                                                                minHeight: 50,
                                                                maxHeight:
                                                                    json.decode(controller.chatData!.data!.data![index].media!)!.length ==
                                                                            2
                                                                        ? 125
                                                                        : 250),
                                                            child: ImageGrid(
                                                                imageUrls: json
                                                                    .decode(controller
                                                                        .chatData!
                                                                        .data!
                                                                        .data![
                                                                            index]
                                                                        .media!)))
                                                        : Container(),
                                                    controller
                                                                .chatData!
                                                                .data!
                                                                .data![index]
                                                                .msg ==
                                                            null
                                                        ? Container()
                                                        : Text(
                                                            controller
                                                                .chatData!
                                                                .data!
                                                                .data![index]
                                                                .msg
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 3),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: Text(
                                                          '${timeAgoSinceDate(controller.chatData!.data!.data![index].createdAt!.toString())}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Flexible(
                                          flex: 2,
                                          child: Stack(
                                            alignment: Alignment.bottomRight,
                                            children: [
                                              Container(
                                                constraints:
                                                    const BoxConstraints(
                                                  maxWidth: 250,
                                                  minWidth: 20,
                                                ),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color: DynamicColor.grayClr,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    controller
                                                                .chatData!
                                                                .data!
                                                                .data![index]
                                                                .parentChat ==
                                                            null
                                                        ? const SizedBox
                                                            .shrink()
                                                        : Container(
                                                            decoration:
                                                                const BoxDecoration(
                                                                    color: Colors
                                                                        .grey),
                                                            child:
                                                                GestureDetector(
                                                              onTap: () async {
                                                                await controller
                                                                    .scroll(
                                                                        int.parse(
                                                                          json
                                                                              .decode(controller.chatData!.data!.data![index].parentChat!)['id']
                                                                              .toString(),
                                                                        ),
                                                                        index);
                                                              },
                                                              child: Container(
                                                                width:
                                                                    Get.width,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(6),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      jsonDecode(jsonDecode(controller.chatData!.data!.data![index].parentChat!)['user'])['id'] ==
                                                                              API().sp.read(
                                                                                  "userId")
                                                                          ? "You"
                                                                          : jsonDecode(jsonDecode(controller
                                                                              .chatData!
                                                                              .data!
                                                                              .data![index]
                                                                              .parentChat!)['user'])['name'],
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                    controller.chatData!.data!.data![index].parentChat !=
                                                                            null
                                                                        ? jsonDecode(controller.chatData!.data!.data![index].parentChat!)['media'] ==
                                                                                null
                                                                            ? Text(
                                                                                jsonDecode(controller.chatData!.data!.data![index].parentChat!)['msg'] ?? jsonDecode(jsonDecode(controller.chatData!.data!.data![index].parentChat!)['event'])['event_title'],
                                                                                maxLines: 3,
                                                                                style: TextStyle(color: DynamicColor.blackClr),
                                                                              )
                                                                            : jsonDecode(controller.chatData!.data!.data![index].parentChat!)['msg'] == null
                                                                                ? Container(
                                                                                    height: 20,
                                                                                    width: 20,
                                                                                    decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(jsonDecode(jsonDecode(controller.chatData!.data!.data![index].parentChat!)['media'])[0]['filename']))),
                                                                                  )
                                                                                : ((json.decode(controller.chatData!.data!.data![index].parentChat!)['msg'] != null) && (jsonDecode(controller.chatData!.data!.data![index].parentChat!)['media'] != null))
                                                                                    ? Row(
                                                                                        children: [
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.only(right: 4.0),
                                                                                            child: Text(
                                                                                              jsonDecode(controller.chatData!.data!.data![index].parentChat!)['msg'],
                                                                                              style: const TextStyle(color: Colors.black),
                                                                                            ),
                                                                                          ),
                                                                                          Container(
                                                                                            height: 20,
                                                                                            width: 20,
                                                                                            decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(jsonDecode(jsonDecode(controller.chatData!.data!.data![index].parentChat!)['media'])[0]['filename']))),
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                    : Text(
                                                                                        json.decode(controller.chatData!.data!.data![index].parentChat!)['is_deleted'] == 1 ? "Message are deleted" : json.decode(controller.chatData!.data!.data![index].parentChat!)['msg'].toString(),
                                                                                        style: const TextStyle(fontSize: 12, color: Colors.black45),
                                                                                        maxLines: 3,
                                                                                      )
                                                                        : Container(),
                                                                  ],
                                                                ),
                                                                decoration:
                                                                    BoxDecoration(
                                                                        border:
                                                                            const Border(
                                                                          left: BorderSide(
                                                                              color: Colors.white,
                                                                              width: 5),
                                                                        ),
                                                                        color: Colors
                                                                            .grey
                                                                            .withValues(alpha:0.5)),
                                                              ),
                                                            ),
                                                          ),
                                                    (controller
                                                                    .chatData!
                                                                    .data!
                                                                    .data![
                                                                        index]
                                                                    .msg !=
                                                                null &&
                                                            controller
                                                                    .chatData!
                                                                    .data!
                                                                    .data![
                                                                        index]
                                                                    .media ==
                                                                null)
                                                        ? Padding(
                                                            padding: EdgeInsets.only(
                                                                top: controller
                                                                            .chatData!
                                                                            .data!
                                                                            .data![index]
                                                                            .parentChat !=
                                                                        null
                                                                    ? 6.0
                                                                    : 0),
                                                            child: Text(
                                                              controller
                                                                  .chatData!
                                                                  .data!
                                                                  .data![index]
                                                                  .msg
                                                                  .toString(),
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 3),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: Text(
                                                          '${timeAgoSinceDate(controller.chatData!.data!.data![index].createdAt!.toString())}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Spacer(),
                              controller.chatData!.data!.data![index]
                                          .isDeleted ==
                                      1
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      decoration: BoxDecoration(
                                          color: Colors.red.withValues(alpha:0.5),
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      child: const Center(
                                        child: Text(
                                          "Message have been deleted",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  : controller.chatData!.data!.data![index]
                                              .media !=
                                          null
                                      ? Flexible(
                                          flex: 2,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: Colors.white,
                                            ),
                                            padding: const EdgeInsets.all(6),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                controller
                                                            .chatData!
                                                            .data!
                                                            .data![index]
                                                            .parentChat ==
                                                        null
                                                    ? const SizedBox.shrink()
                                                    : jsonDecode(controller
                                                                    .chatData!
                                                                    .data!
                                                                    .data![index]
                                                                    .parentChat!)[
                                                                'media'] ==
                                                            null
                                                        ? const SizedBox
                                                            .shrink()
                                                        : GestureDetector(
                                                            onTap: () async {
                                                              await controller
                                                                  .scroll(
                                                                      int.parse(
                                                                        json
                                                                            .decode(controller.chatData!.data!.data![index].parentChat!)['id']
                                                                            .toString(),
                                                                      ),
                                                                      index);
                                                            },
                                                            child: Container(
                                                              width: Get.width,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                border: Border(
                                                                  left: BorderSide(
                                                                      color: Colors
                                                                          .white,
                                                                      width: 5),
                                                                ),
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 6),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    jsonDecode(jsonDecode(controller.chatData!.data!.data![index].parentChat!)['user'])['id'] ==
                                                                            API().sp.read(
                                                                                "userId")
                                                                        ? "You"
                                                                        : jsonDecode(jsonDecode(controller
                                                                            .chatData!
                                                                            .data!
                                                                            .data![index]
                                                                            .parentChat!)['user'])['name'],
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        vertical:
                                                                            8.0),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          55,
                                                                      width: 60,
                                                                      decoration: BoxDecoration(
                                                                          image: DecorationImage(
                                                                              image: NetworkImage(jsonDecode(jsonDecode(controller.chatData!.data!.data![index].parentChat!)['media'])[0]['filename']),
                                                                              fit: BoxFit.fill)),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                controller
                                                            .chatData!
                                                            .data!
                                                            .data![index]
                                                            .media !=
                                                        null
                                                    ? Container(
                                                        constraints: BoxConstraints(
                                                            maxWidth: 270,
                                                            minHeight: 50,
                                                            maxHeight: json
                                                                        .decode(controller
                                                                            .chatData!
                                                                            .data!
                                                                            .data![
                                                                                index]
                                                                            .media!)!
                                                                        .length ==
                                                                    2
                                                                ? 125
                                                                : 245),
                                                        child: ImageGrid(
                                                            imageUrls: json
                                                                .decode(controller
                                                                    .chatData!
                                                                    .data!
                                                                    .data![
                                                                        index]
                                                                    .media!)))
                                                    : Container(),
                                                controller.chatData!.data!
                                                            .data![index].msg ==
                                                        null
                                                    ? Container()
                                                    : Text(
                                                        controller
                                                            .chatData!
                                                            .data!
                                                            .data![index]
                                                            .msg
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                SeenUnseenWidget(
                                                  chatData: controller.chatData!
                                                      .data!.data![index],
                                                ),
                                                // Padding(
                                                //     padding: EdgeInsets.only(right: 3.0),
                                                //     child:Row(
                                                //       mainAxisAlignment: MainAxisAlignment.end,
                                                //       children: [
                                                //         Padding(
                                                //           padding: EdgeInsets.only(right: 3),
                                                //           child: Align(
                                                //             alignment: Alignment.bottomRight,
                                                //             child: Text('${timeAgoSinceDate(controller.chatData!.data!.data![index].createdAt!.toString())}',
                                                //               style: TextStyle(
                                                //                 fontSize: 10,
                                                //                 color: Colors.black87,
                                                //               ),
                                                //             ),
                                                //           ),
                                                //         ),
                                                //         controller.chatData!.data!.data![index].isSeen==1? Icon(Icons.done_all,
                                                //           size: 13,
                                                //           color: Colors.blue,
                                                //         ):Icon(Icons.check,
                                                //           size: 13,
                                                //           color: Colors.grey,
                                                //         ),
                                                //       ],
                                                //     )
                                                // )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Flexible(
                                          flex: 2,
                                          child: Container(
                                            constraints: const BoxConstraints(
                                              maxWidth: 250,
                                              minWidth: 20,
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                controller
                                                            .chatData!
                                                            .data!
                                                            .data![index]
                                                            .parentChat ==
                                                        null
                                                    ? const SizedBox.shrink()
                                                    : Container(
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors.grey,
                                                        ),
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            await controller
                                                                .scroll(
                                                                    int.parse(
                                                                      json
                                                                          .decode(controller
                                                                              .chatData!
                                                                              .data!
                                                                              .data![index]
                                                                              .parentChat!)['id']
                                                                          .toString(),
                                                                    ),
                                                                    index);
                                                          },
                                                          child: Container(
                                                            width: Get.width,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(6),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  jsonDecode(jsonDecode(controller.chatData!.data!.data![index].parentChat!)['user'])['id'] ==
                                                                          API().sp.read(
                                                                              "userId")
                                                                      ? "You"
                                                                      : jsonDecode(jsonDecode(controller
                                                                          .chatData!
                                                                          .data!
                                                                          .data![
                                                                              index]
                                                                          .parentChat!)['user'])['name'],
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                controller
                                                                            .chatData!
                                                                            .data!
                                                                            .data![
                                                                                index]
                                                                            .parentChat !=
                                                                        null
                                                                    ? jsonDecode(controller.chatData!.data!.data![index].parentChat!)['media'] ==
                                                                            null
                                                                        ? Text(
                                                                            jsonDecode(controller.chatData!.data!.data![index].parentChat!)['msg'] ??
                                                                                (jsonDecode(controller.chatData!.data!.data![index].parentChat!)['event'] == null ? "Event Reply" : jsonDecode(jsonDecode(controller.chatData!.data!.data![index].parentChat!)['event'])['event_title']),
                                                                            maxLines:
                                                                                3,
                                                                          )
                                                                        : jsonDecode(controller.chatData!.data!.data![index].parentChat!)['msg'] ==
                                                                                null
                                                                            ? Container(
                                                                                height: 55,
                                                                                width: 60,
                                                                                decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(jsonDecode(jsonDecode(controller.chatData!.data!.data![index].parentChat!)['media'])[0]['filename']), fit: BoxFit.fill)),
                                                                              )
                                                                            : ((json.decode(controller.chatData!.data!.data![index].parentChat!)['msg'] != null) && (jsonDecode(controller.chatData!.data!.data![index].parentChat!)['media'] != null))
                                                                                ? Row(
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: const EdgeInsets.only(right: 4.0),
                                                                                        child: Text(jsonDecode(controller.chatData!.data!.data![index].parentChat!)['msg']),
                                                                                      ),
                                                                                      Container(
                                                                                        height: 20,
                                                                                        width: 20,
                                                                                        decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(jsonDecode(jsonDecode(controller.chatData!.data!.data![index].parentChat!)['media'])[0]['filename']))),
                                                                                      ),
                                                                                    ],
                                                                                  )
                                                                                : Text(
                                                                                    json.decode(controller.chatData!.data!.data![index].parentChat!)['is_deleted'] == 1 ? "Message are deleted" : json.decode(controller.chatData!.data!.data![index].parentChat!)['msg'].toString(),
                                                                                    style: const TextStyle(
                                                                                      fontSize: 12,
                                                                                      color: Colors.black,
                                                                                    ),
                                                                                    maxLines: 3,
                                                                                  )
                                                                    : Container(),
                                                              ],
                                                            ),
                                                            decoration:
                                                                const BoxDecoration(
                                                                    border:
                                                                        Border(
                                                                      left: BorderSide(
                                                                          color: Colors
                                                                              .white,
                                                                          width:
                                                                              5),
                                                                    ),
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                        ),
                                                      ),
                                                (controller
                                                                .chatData!
                                                                .data!
                                                                .data![index]
                                                                .msg !=
                                                            null &&
                                                        controller
                                                                .chatData!
                                                                .data!
                                                                .data![index]
                                                                .media ==
                                                            null)
                                                    ? Padding(
                                                        padding: EdgeInsets.only(
                                                            top: controller
                                                                        .chatData!
                                                                        .data!
                                                                        .data![
                                                                            index]
                                                                        .parentChat !=
                                                                    null
                                                                ? 6.0
                                                                : 0),
                                                        child: Text(
                                                          controller
                                                              .chatData!
                                                              .data!
                                                              .data![index]
                                                              .msg
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      )
                                                    : const SizedBox.shrink(),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 3),
                                                      child: Align(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: Text(
                                                          '${timeAgoSinceDate(controller.chatData!.data!.data![index].createdAt!.toString())}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 3.0),
                                                      child: controller
                                                                  .chatData!
                                                                  .data!
                                                                  .data![index]
                                                                  .isSeen ==
                                                              1
                                                          ? const Icon(
                                                              Icons.done_all,
                                                              size: 13,
                                                              color:
                                                                  Colors.blue,
                                                            )
                                                          : const Icon(
                                                              Icons.check,
                                                              size: 13,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                            ],
                          )),
      ),
    ),
  );
}

/// long press to delete or reply
onLongPress(context, index, element, controller, tapDownPosition) {
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;
  showMenu(
    color: Colors.transparent,
    useRootNavigator: true,
    items: <PopupMenuEntry>[
      PopupMenuItem(
        value: index,
        padding: EdgeInsets.zero,
        child: controller.chatTilePopUp(element, context, index),
      )
    ],
    context: context,
    position: RelativeRect.fromLTRB(
      tapDownPosition!.dx,
      tapDownPosition!.dy,
      overlay.size.width - tapDownPosition!.dx,
      overlay.size.height - tapDownPosition!.dy,
    ),
  );
}
