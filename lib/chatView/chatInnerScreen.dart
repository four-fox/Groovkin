
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/Url.dart';
import 'package:popup_banner/popup_banner.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

import '../Components/Network/API.dart';
import '../Components/colors.dart';
import '../View/GroovkinUser/UserBottomView/groupFlow/theSquadScreen.dart';
import 'chatController.dart';
import 'chatInnerDataModel.dart';
import 'chatNewUserModel.dart';
import 'messageWidget.dart';

class ChatInnerScreen extends StatefulWidget {
  ChatInnerScreen({Key? key}) : super(key: key);
  
  bool notificationNav = false;
  bool staticNav = false;


  @override
  State<ChatInnerScreen> createState() => _ChatInnerScreenState();
}

class _ChatInnerScreenState extends State<ChatInnerScreen> {


  ChatController _controller = Get.find();

  var userData;
  
  Offset? _tapDownPosition;
  Timer? onStoppedTyping;
  bool firstTime = false;
  RxBool typing = false.obs;
  
  

  _onChangeHandler(value) {
    const duration = Duration(
        milliseconds:
        800); // set the duration that you want call stopTyping() after that.
    if (onStoppedTyping != null) {
      // if (_controller.conversationID != null) {
      //   if (firstTime == false) {
      //     firstTime = true;
      //     _controller.socket!.emit("typing", {
      //       "conversation_id": _controller.conversationID,
      //       "typing": true,
      //     });
      //   }
      // }
      onStoppedTyping!.cancel(); // clear timer
    }
    onStoppedTyping = Timer(duration, () => stopTyping());
  }

  stopTyping() {
    firstTime = false;
    // if (_controller.conversationID != null) {
    //   _controller.socket!.emit("typing", {
    //     "conversation_id": _controller.conversationID,
    //     "typing": false,
    //   });
    // }
  }


  @override
  void initState() {
    _controller.replyModel = null;
    _controller.isReplying(false);
    _controller.replyId = null;


    _controller.multipleImageList.clear();
    _controller.messageController.clear();
    userData = Get.arguments['userData'];
    isOnChat.value = true;
    super.initState();
    _controller.scrollController = GroupedItemScrollController();
    _controller.itemPositionsListener.itemPositions.addListener(() {
      if (_controller.itemPositionsListener.itemPositions.value.isNotEmpty) {
        if (Get.width > 380) {
          if (_controller.itemPositionsListener.itemPositions.value.first.index >
              22) {
            if (_controller.bottomPosition.value == false) {
              _controller.bottomPosition.value = true;
            }
          } else if (_controller
              .itemPositionsListener.itemPositions.value.first.index <
              10) {
            if (_controller.bottomPosition.value == true) {
              _controller.bottomPosition.value = false;
            }
          }
        } else {
          if (_controller.itemPositionsListener.itemPositions.value.first.index >
              12) {
            if (_controller.bottomPosition.value == false) {
              _controller.bottomPosition.value = true;
            }
          } else if (_controller
              .itemPositionsListener.itemPositions.value.first.index <
              5) {
            if (_controller.bottomPosition.value == true) {
              _controller.bottomPosition.value = false;
            }
          }
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        isOnChat.value = false;
        _controller.isChat.value = false;
        print('${_controller.isChat.value}');
        print('value of is chat');
        return true;
      },
      child: GetBuilder<ChatController>(
        initState: (v){
          _controller.getAllChat(id: userData!.id);
        },
          builder: (controller) {
            return Scaffold(
                backgroundColor: Colors.transparent,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight*1.2),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                ///Todo latter on
                                controller.isChat.value = false;
                                isOnChat.value = false;
                                _controller.innerUserOnline.value = false;
                                // _controller.offChatInnerScreenSocket();
                                ///Todo latter on
                                Get.back();
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(3.0),
                                    child: Icon(
                                      Icons.arrow_back_ios_new_rounded,
                                      color: Colors.black45,
                                      size: 20,
                                    ),
                                  )),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            GestureDetector(
                              onTap: (){
                                ///Todo latter on
                                /* if(notificationFlow == false){
                                  if (chatData!.user!.profile!.userImage != null || chatData!.userImage != null) {
                                    Get.toNamed(Routes.photoViews, arguments: {
                                      'fileImage': false,
                                      'image': chatRoomNavigation==true? chatData!.user!.profile!.userImage:chatData!.userImage,
                                    });
                                  }
                                }else{
                                  if (chatData['profile']['user_image'] != null *//*|| chatData!.userImage != null*//*) {
                                    Get.toNamed(Routes.photoViews, arguments: {
                                      'fileImage': false,
                                      'image': chatData['profile']['user_image'],
                                    });
                                  }
                                }*/
                                ///Todo latter on
                              },
                              child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                  // NetworkImage(groupPlaceholder)
                                  NetworkImage(userData!.profilePicture!)
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: (){
                                ///ToDo latter on
                                /*Get.toNamed(Routes.viewOtherProfile,
                                    arguments: {
                                      "otherUserData": notificationFlow==true?chatData['id'] : chatRoomNavigation==true? chatData.addresserId:chatData.userId,
                                    });*/
                                ///ToDo latter on
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userData!.profile!.fullName! ,style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                  ),
                                  ),
                                  SizedBox(
                                    height: 1,
                                  ),
                                  ///ToDo latter on
                                  /*   Obx(()=> _controller.innerUserOnline.value == true?
                                  Text(
                                    typing.value == false? "Online":"Typing....." ,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 10,
                                        color: DynamicColors.primaryColor),
                                  ):Text(
                                    typing.value == false? "":"Typing....." ,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 10,
                                        color: DynamicColors.primaryColor),
                                  )
                                  ),*/
                                  ///ToDo latter on
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        thickness: 1.2,
                      ),
                    ],
                  ),
                ),
                body:controller.getAllChatLoader.value == false?SizedBox.shrink(): Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (scrollNotification.metrics.pixels ==
                            scrollNotification.metrics.maxScrollExtent) {
                          if (controller.chatWait == false) {
                            controller.chatWait = true;
                            if (controller.chatData!.data!.nextPageUrl != null) {
                              String link =
                                  controller.chatData!.data!.nextPageUrl;
                              controller.getAllChat(id:userData!.id,nextUrl: link);
                              return true;
                            }
                          }
                          return false;
                        }
                        return false;
                      },
                      child: Stack(
                        children: [
                          buildStickyGroupedListView(context),
                          Obx(() => _controller.bottomPosition.value == true
                              ? Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding:
                              const EdgeInsets.only(bottom: 100, right: 20),
                              child: GestureDetector(
                                onTap: () {
                                  _controller.scrollController!.jumpTo(
                                      index: 0,
                                      alignment: 0.5,
                                      automaticAlignment: false);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black.withOpacity(0.7)),
                                  child: Icon(Icons.keyboard_double_arrow_down,
                                    color: DynamicColor.yellowClr,
                                  ),
                                ),
                              ),
                            ),
                          )
                              : SizedBox.shrink())
                        ],
                      ),
                    ),
                    /// da da parent message show kavalo widget d.......
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        controller.isReplying.value == true? replying(controller,): (controller.multipleImageList.isNotEmpty)? imageShowContainer(controller): SizedBox.shrink(),
                        textFieldsContainer(controller),
                      ],
                    )
                  ],
                )
            );
          }
      ),
    );
  }

  ///heading time or date
  Widget headerDateTime(DateTime dates) {
    return SizedBox(
      height: 50,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: 120,
          decoration: BoxDecoration(
            color: DynamicColor.yellowClr.withOpacity(0.6),
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${"${dates.month}".padLeft(2,"0")}${"/${dates.day}".padLeft(2,"0")}/${dates.year}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.white
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget replying(controller) {
    Map<String, dynamic> jsonMap = json.decode(controller.replyModel.user);
    String name = controller.replyModel.senderId == API().sp.read("userId")?"You": jsonMap['name'];
    return Container(
      color: Colors.white,
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name,
                style: TextStyle(fontSize: 14,
                color: Colors.black87
                ),
              ),
              GestureDetector(
                  onTap: (){
                    controller.replyModel = null;
                    controller.isReplying(false);
                    controller.replyId = null;
                    controller.multipleImageList.clear();
                    controller.update();
                  },
                  child: Icon(Icons.clear,
                  color: DynamicColor.yellowClr,
                  ))
            ],
          ),
          Container(
            width: Get.width,
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                      color: Colors.black,
                      width: 5
                  ),
                ),
                // borderRadius: BorderRadius.circular(5),
                color: Colors.grey.withOpacity(0.5)
            ),
            child:controller.replyModel!.media == null && controller.replyModel!.msg != null? Text(controller.replyModel!.msg.toString(),
              style: TextStyle(
                  color: Colors.black87
              ),
              maxLines: 3,
            ) :controller.replyModel!.media == null && controller.replyModel!.msg == null ?
            Text(json.decode(controller.replyModel.event!)['event_title'].toString().capitalize!,
              style: TextStyle(
                  color: Colors.black87
              ),
              maxLines: 1,
            )
                :Row(
              children: [
                controller.replyModel!.msg == null ? Container(): Flexible(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.only(right: 6.0),
                    child: Text(controller.replyModel!.msg.toString(),
                      style: TextStyle(
                          color: Colors.black87
                      ),
                    ),
                  ),
                ),
                // Spacer(),
                Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(Url().imageUrl + jsonDecode(controller.replyModel!.media)[0]['filename'])
                          ,fit: BoxFit.fill),
                    )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// container of send image
  Widget imageShowContainer(controller){
    return Container(
      color: Colors.white,
      width: Get.width,
      height: 70,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: controller.multipleImageList.length,
          scrollDirection: Axis.horizontal,
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 3,vertical: 2),
          itemBuilder: (BuildContext context,index){
            return Stack(
              alignment: Alignment.topRight,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.0),
                  child: Container(
                    height: 120,
                    width: 60,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(File(controller.multipleImageList[index].filename)),fit: BoxFit.fill
                        )
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    controller.multipleImageList.remove(controller.multipleImageList[index]);
                    controller.update();
                  },
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.amber,
                    child: Icon(Icons.clear,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }

  /// send message text fields widget
  Widget textFieldsContainer(controller){
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          SizedBox(
            width: Get.width/1.16,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 3.0,horizontal: 6),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.white),
                ),
                child: TextField(
                  maxLines: 3,
                  minLines: 1,
                  style: TextStyle(fontSize: 14,
                      color: Colors.black
                  ),
                  onChanged: (v){
                    _onChangeHandler(v);
                  },
                  controller: controller.messageController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 5,right: 6,top: 15),
                    hintText: "Write message",
                    hintStyle: TextStyle(fontSize: 14,
                        color: Colors.black87.withOpacity(0.5)
                    ),
                    suffixIcon:
                    CustomPopupMenu(
                      controller: controller.customPopupMenuController,
                      menuBuilder: controller.popUpMenu,
                      horizontalMargin: 0,
                      showArrow: true,
                      barrierColor: Colors.transparent,
                      pressType: PressType.singleClick,
                      child: Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:BorderRadius.circular(5)
                          ),
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Icon(Icons.photo,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              ///Todo latter on
              if(controller.messageController.text.isNotEmpty || controller.multipleImageList.isNotEmpty){
                _controller.sendMessage(receiverId: userData!.id);
              }else{
                bottomToast(text: "Please write something");
                // BotToast.showText(text: "Please write something");
              }
              ///Todo latter on
            },
            child: Padding(
              padding: EdgeInsets.all(6.0),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius:BorderRadius.circular(5)
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Icon(Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  /// Dalta da messages list d
  StickyGroupedListView<ChatData, DateTime> buildStickyGroupedListView(BuildContext context,{shrinkWrap = false}){
    return StickyGroupedListView<ChatData, DateTime>(
      elements: _controller.chatData!.data!.data!,
      order: StickyGroupedListOrder.ASC,
      itemPositionsListener: _controller.itemPositionsListener,
      itemScrollController: _controller.scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      groupBy: (ChatData element) {
        var dates = DateTime.parse(element.createdAt!.toString());
        return DateTime(
            dates.year,dates.month,dates.day);
      },
      itemComparator: (element1, element2) =>
          DateTime.parse(element2.createdAt!).compareTo(
              DateTime.parse(element1.createdAt!)),
      stickyHeaderBackgroundColor:
      Colors.white,
      floatingHeader: true,
      shrinkWrap: false,
      reverse: true,
      addSemanticIndexes: true,
      padding: EdgeInsets.only(bottom: _controller.isReplying.value == true?120: 75),
      groupComparator: (item1, item2) => item2.compareTo(item1),
      groupSeparatorBuilder: (ChatData element) {
        DateTime dates =DateTime.parse(element.createdAt.toString());
        ///time ao date top wala d dalta
        return headerDateTime(dates);
      },
      indexedItemBuilder: (context, chatMessageItem, index){
        if(_controller.chatData!.data!.data![index].isSeen == 0){
          ///ToDo latter on
          _controller.disposedAllSeen(_controller.chatData!.data!.data![index].conversationId);
          _controller.seenMessageSocket(_controller.chatData!.data!.data![index].conversationId,index);
          ///ToDo latter on
        }
        ///ToDo latter on
       /* _controller.socket!.on('typing-${_controller.chatData!.data!.data![index].conversationId}', (data) {
          print(data);
          for (var element in _controller.chatRoomData!.data!.data!) {
            if(element.conversationId == data['conversation_id']){
              typing.value = data['typing'];
              // _controller.update();
            }
          }
        });*/
        ///ToDo latter on
        for(int a = 0; a <_controller.chatData!.data!.data!.length; a++){
          _controller.disposedDeleteForEveryOneSocket(_controller.chatData!.data!.data![index].conversationId);
          _controller.deleteForEveryOneSocket(_controller.chatData!.data!.data![index].conversationId);

        }
        // _controller.socket!.on('typing-${_controller.innerScreenChatData!.data!.data![index].conversationId}', (data) => {
        //
        // });
        return Stack(
          children: [
            _controller.selectedIndexes == index
                ?
            Obx(() {
              return AnimatedOpacity(
                opacity: _controller.animatedOpacity
                    .value ==
                    true
                    ? 1.0
                    : 0.0,
                duration: const Duration(
                    milliseconds: 1500),
                child: Container(
                    decoration: BoxDecoration(
                      color: _controller
                          .selectedIndexes ==
                          index
                          ?
                          Colors.red.withOpacity(0.8)
                          : Colors.transparent,
                    ),
                    child: _getItem(context,_controller.chatData!.data!.data![index],index)),
              );
            })
                : SizedBox.shrink(),
            _getItem(context,_controller.chatData!.data!.data![index],index)
          ],
        ) ;
      },
    );
  }

  _getItem(BuildContext ctx, ChatData element, int index) {
    return messageWidget(ctx: ctx, element: element,index: index, controller: _controller,tapDownPosition:_tapDownPosition, /*imageList: a*/);
  }
}

/// Chat have images
class ImageGrid extends StatelessWidget {
  final List imageUrls;

  ImageGrid({required this.imageUrls});
  List<String> a = [];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: imageUrls.length,
      shrinkWrap: false,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:imageUrls.length == 1? 1: 2, // Change the number according to your preference
        crossAxisSpacing: 6.0,
        mainAxisSpacing: 6.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: (){
                a.clear();
                for (var element in imageUrls) {
                  a.add(element['filename']);
                }
                PopupBanner(
                  context: context,
                  images: a,
                  dotsColorActive: Colors.black45,
                  autoSlide: false,
                  // useDots: false,
                  onClick: (index) {
                    debugPrint("CLICKED $index");
                  },
                ).show();
              },
              child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(imageUrls[index]['filename'],),
                        fit: BoxFit.cover
                    )
                ),
              ),
            ),
            ((imageUrls.length>4) && (index == 3))? GestureDetector(
              onTap: (){
                a.clear();
                for (var element in imageUrls) {
                  a.add(element['filename']);
                }
                PopupBanner(
                  context: context,
                  images: a,
                  dotsColorActive: Colors.black45,
                  autoSlide: false,
                  // useDots: false,
                  onClick: (index) {
                    debugPrint("CLICKED $index");
                  },
                ).show();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                ),
                padding: EdgeInsets.all(7),
                child: Text("+${imageUrls.length - 4} more",
                  style: TextStyle(
                      fontSize: 12,
                    color: Color(0xff00327A),),
                ),
              ),
            ):SizedBox.shrink()
          ],
        );
      },
    );
  }
}
