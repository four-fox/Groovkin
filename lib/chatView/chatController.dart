
// ignore_for_file: unnecessary_import

import 'dart:convert';
import 'dart:io';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:dio/dio.dart' as form;
import 'package:http_parser/http_parser.dart';

import '../Components/Network/API.dart';
import '../Components/Network/Url.dart';
import '../Components/mediaModel.dart';
import 'chatInnerDataModel.dart';
import 'chatNewUserModel.dart';
import 'chatRoomModel.dart';
import 'dbConfig/dbConfig.dart';


/// camera and gallery choose icon model
class ItemModel {
  String title;
  IconData icon;

  ItemModel(this.title, this.icon);
}


RxBool isOnChat = false.obs;
class ChatController extends GetxController{
  /// bool variables

  RxBool bottomPosition = false.obs;
  int? selectedIndexes;
  RxBool animatedOpacity = false.obs;
  RxBool isReplying = false.obs;
  bool chatWait = false;
  var replyModel;
  // ChatData? replyModel;
  String? replyId;
  bool isPermissionsGranted = false;
  RxBool fieldUpdate = false.obs;
  String? conversationID;
  RxBool bottomContainer = false.obs;

  ///media
  XFile? imageFile;
  XFile? videoFile;
  File? videoThumbnail;
  File? pdfThumbnail;
  File? file;
  List<form.MultipartFile> chatFileList = [];
  RxBool isChat = false.obs;
  RxBool innerUserOnline = false.obs;


  /// choose gallery for image
  List<MediaClass> multipleImageList = [];
  final messageController = TextEditingController();
  GroupedItemScrollController? scrollController;
  final ItemPositionsListener itemPositionsListener =
  ItemPositionsListener.create();
  final ImagePicker _picker = ImagePicker();
  dynamic pickImageError;
  dynamic chatDatabase;
  final UserChatItemDatabase _chatDatabase = UserChatItemDatabase();
  final focusNode = FocusNode();

  late List<ItemModel> chatTileMenuList = [
    ItemModel('Delete', Icons.delete),
    ItemModel('Reply', Icons.reply),
  ];
  List<Permission> permissionsNeeded = [Permission.camera, Permission.storage];
  final CustomPopupMenuController customPopupMenuController =
  CustomPopupMenuController();

  List<ItemModel> menuItems = [
    ItemModel('Camera', Icons.camera_alt),
    ItemModel('Gallery', Icons.photo),
  ];

  var sp = GetStorage();
  IO.Socket? socket;
  // var token = sp.read('token');

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // executeConditionalCode();
    _socketConnect();
    // getAllUser();
    initDatabase();
  }

  /// socket initialization
  void _socketConnect() async {
    print("object object");
    Map<String, dynamic> map =
    {'token': API().sp.read("token"), 'user_id': API().sp.read("userId")};
    socket = IO.io(
        Url().socketUrl,
        OptionBuilder()
            .setTransports(['websocket', 'polling'])
            .setAuth(map).build());

    socket!.connect();

    socket!.onConnect((data) {
      print('connect');
    });

    // socket!.on('receiver-message-${API().sp.read("id")}', (data) {
    //   receiveMessageEvent(data);
    // });

    // socket!.onConnect((_) {
    //   socket!.emit('user-connect', {'user_id': API().sp.read('userId')});
    //   print('socket is connect');
    // });

    socket!.onDisconnect((_) {
      print('disconnect');
    });
    // connectDisconnect();
  }

  ///Data base initialized
  initDatabase() async {
    chatDatabase = await _chatDatabase.getDatabase;
    // getMessageCount();
  }


  /// get all user for new chat
  RxBool newUserChatLoader = false.obs;
  ChatNewUserModel? newUserData;
  bool getNewUserWait = false;
  getNewUser({nextUrl, }) async{
    newUserChatLoader(true);
    String type =API().sp.read('role')=="eventOrganizer"?"venue_manager": "event_owner";
    var response = await API().getApi(url:"get-all-users?role_name=$type",fullUrl: nextUrl);
    if(response.statusCode == 200){
      if(nextUrl == null){
        newUserData = ChatNewUserModel.fromJson(response.data);
        getNewUserWait = false;
      }else{
        newUserData!.data!.data!.addAll(ChatNewUserModel.fromJson(response.data).data!.data!);
        newUserData!.data!.nextPageUrl =
            ChatNewUserModel.fromJson(response.data).data!.nextPageUrl;
        getNewUserWait = false;
      }
      newUserChatLoader(false);
      update();
    }
  }

  ///user check online or offline
  // connectDisconnect() {
  //   socket!.on('user-connected', (data) {
  //     print('user is connected');
  //     var d = UserData.fromJson(data);
  //     if(isChat.value == false){
  //       if(chatRoomData != null) {
  //         for (var element in chatRoomData!.data!.data!) {
  //           if (d.id == element.user!.id) {
  //             if (element.user!.userStatus!.value != true) {
  //               element.user!.userStatus!.value = true;
  //             }
  //           }
  //           update();
  //         }
  //       }
  //     }else{
  //       if(innerScreenChatData!.data!.data != null){
  //         if(/*(*/jsonDecode(innerScreenChatData!.data!.data![0].user!)['user_status'] != true/*) && d.id == jsonDecode(innerScreenChatData!.data!.data![0].user!)['id']*/){
  //           jsonDecode(innerScreenChatData!.data!.data![0].user!)['user_status'] = true;
  //           innerUserOnline.value = true;
  //           update();
  //         }
  //       }
  //     }
  //
  //   });
  //   socket!.on('user-dis-connected', (dataaa) {
  //     print('user is disConnected');
  //     var d = UserData.fromJson(dataaa);
  //     if((isChat.value == false) && (innerUserOnline.value == false)){
  //       if (chatRoomData != null) {
  //         int i = chatRoomData!.data!.data!
  //             .indexWhere((element) => element.user!.id == d.id);
  //         if (i >= 0) {
  //           chatRoomData!.data!.data![i].user!.userStatus!.value = false;
  //         }
  //         update();
  //         // for (var element in chatRoomData!.data!.data!) {
  //         //   if (/*users != null &&*/ d.id == element.user!.id) {
  //         //     if (element.user!.userStatus!.value != false) {
  //         //       element.user!.userStatus!.value = false;
  //         //     }
  //         //   }
  //         //   update();
  //         // }
  //       }
  //     }else{
  //       if(innerScreenChatData!.data!.data != null){
  //         if(jsonDecode(innerScreenChatData!.data!.data![0].user!)['user_status'] == true){
  //           jsonDecode(innerScreenChatData!.data!.data![0].user!)['user_status'] = false;
  //           innerUserOnline.value = false;
  //           update();
  //         }
  //       }
  //     }
  //   });
  // }


  ///get chat room
  RxBool getAllChatRoomLoader = true.obs;
  ChatRoomModel?chatRoomData;
  getAllChatRoom() async{
    getAllChatRoomLoader(false);
    var response = await API().getApi(url: 'get-inbox');
    if(response.statusCode == 200){
      chatRoomData = ChatRoomModel.fromJson(response.data);
      for (int i = 0; i < chatRoomData!.data!.data!.length; i++) {
        disposedReceiverSocket();
        receiveMessage();
      }
      getAllChatRoomLoader(true);
      update();
    }
  }

  ///get all chat
  RxBool getAllChatLoader = true.obs;
  ChatInnerDataModel? chatData;
  getAllChat({id,nextUrl}) async{
      if(nextUrl == null){
        getAllChatLoader(false);
      }
      var formData = form.FormData.fromMap({
        'user_id': id
      });
      var response = await API().postApi(formData,"chats");
      if(response.statusCode == 200){
        if(nextUrl == null){
          chatData = null;
          chatData = ChatInnerDataModel.fromJson(response.data);
          chatWait = false;
          isChat.value = true;
        }else{
          chatData!.data!.data!
              .addAll(ChatInnerDataModel.fromJson(response.data).data!.data!);
          chatData!.data!.nextPageUrl =
              ChatInnerDataModel.fromJson(response.data).data!.nextPageUrl;
          chatWait = false;
        }
        if (chatData!.data!.data!.isNotEmpty) {
          if(jsonDecode(chatData!.data!.data![0].user!)['user_status'] =='true'){
            innerUserOnline.value = true;
          }
          conversationID = chatData!.data!.data![0].conversationId;
          messageSeen(conversationID);
        }
        getAllChatLoader(true);
        update();
        insertChatDatabase();
      }
  }

  ///send message
  sendMessage({receiverId}) async{
    try{
      if (multipleImageList.isNotEmpty) {
        for (int i = 0; i < multipleImageList.length; i++) {
          chatFileList.add(form.MultipartFile.fromFileSync(
            multipleImageList[i].filename!,
            filename: "Image.${multipleImageList[i].filename!.split('.').last}",
            contentType: MediaType(
                "image", multipleImageList[i].filename!.split('.').last),
          ));
        }
      }
      var formData = form.FormData.fromMap({
        'receiver_id': receiverId,
        if (messageController.text.isNotEmpty) 'msg': messageController.text,
        if (chatFileList.isNotEmpty) "media[]": chatFileList,
        if (bottomContainer.value || replyId != null) "parent_id": replyId
      });
      var response = await API().postApi(formData,'send-message');
      if (response.statusCode == 200) {
        var d = ChatData.fromJson(response.data['data']);
        conversationID = d.conversationId;
        if (d.senderId == API().sp.read("userId")) {
          chatData!.data!.data!.insert(0, d);
        }
        // insertChatDatabase(oneInsertion: true, model: d);
        if (chatData!.data!.data!.length > 5) {
          scrollController!
              .jumpTo(index: 0, automaticAlignment: false, alignment: 0.4);
        }
        clearData();
        update();
      }
    }catch (e){
      print(e);
    }
  }

  clearData() async{
    messageController.clear();
    chatFileList.clear();
    replyModel = null;
    isReplying(false);
    replyId = null;
    bottomContainer(false);
    multipleImageList.clear();
  }


  /// socket disposed receiver
  disposedReceiverSocket() async {
    socket!.off(
        'receiver-message-${API().sp.read("userId")}', (data) => {print(data)});
  }

  ///receive message from socket
  bool receiver = false;
  receiveMessage() async {
    socket!.on('receiver-message-${API().sp.read("userId")}', (data) {
      if (receiver == false) {
        receiver = true;
        if(isChat.value ==true){
          messageSeen(conversationID);
        }
        Future.delayed(Duration(seconds: 1), () {
          receiver = false;
        });
        receiveMessageEvent(data);
      }
      if(conversationID == data['message']['conversation_id']){
        messageNotificationSocket(data['message']['id']);
      }
    });
  }

  ///socket value updation
  receiveMessageEvent(data) {
    if (isChat.value == false) {
      var d = LastMessage.fromJson(data['message']);
      for(int a= 0; a<chatRoomData!.data!.data!.length; a++){
        if(chatRoomData!.data!.data![a].conversationId == d.conversationId){
          chatRoomData!.data!.data![a].lastMessage = d;
          chatRoomData!.data!.data![a].updatedAt = d.updatedAt;
        }
        chatRoomData!.data!.data!.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
        update();
      }
    }
    else {
      var d = ChatData.fromJson(data['message']);
      if (d.senderId != API().sp.read("userId")) {
        insertChatDatabase(oneInsertion: true, model: d);
      }
      update();
    }
  }

  ///scrollToIndex
  scroll(id, currentIndex) {
    if (id != null) {
      print(id);
      int index = chatData!.data!.data!.indexWhere((element) {
        return element.id == id;
      });
      selectedIndexes = index;

      // if (chatData!.data!.data![index].isDeleted == null ||
      //     chatData!.data!.data![index].isDeleted != 0) {
      //   if (currentIndex <= 1 && (index - currentIndex) <= 3) {
      //     animatedOpacity = true.obs;
      //     update();
      //     Future.delayed(Duration(milliseconds: 1000), () {
      //       animatedOpacity(false);
      //       update();
      //     });
      //   } else {
      if ((index - currentIndex) > 2) {
        scrollController!
            .jumpTo(index: index, alignment: 0.5, automaticAlignment: false);
        animatedOpacity = true.obs;
        Future.delayed(Duration(milliseconds: 500), () {
          animatedOpacity(false);
          update();
        });
      } else {
        animatedOpacity = true.obs;
        update();
        Future.delayed(Duration(milliseconds: 1000), () {
          animatedOpacity(false);
          update();
        });
      }
      // }
      // }
    }
  }

  ///message notification socket
  messageNotificationSocket(id) async{
    socket!.emit("message-ack", {
      "id": id,
    });
  }

  /// seen all message
  messageSeen(conversationId) async {
    try{
      var formData = form.FormData.fromMap({
        'chat_id': conversationId,
      });
      var response = await API().postApi(formData,'all-message-seen');
      if (response.statusCode == 200) {
        for (int i = 0; i < chatData!.data!.data!.length; i++) {
          chatData!.data!.data![i].isSeen = 1;
          // seenMessageSocket(innerScreenChatData!.data!.data![i].id, i);
          update();
        }
      }
    }catch(e){
      print(e);
    }
  }

  ///seen all message from both side
  seenMessageSocket(conversationId, i) {
    socket!.on('seen-message-$conversationId', (data) => {
      print(data),
      // for (int i = 0; i < data["message_count"]; i++) {
      if (chatData != null) {
        if (chatData!.data!.data![i].isSeen == 0) {
          chatData!.data!.data![i].isSeen = 1,
          // } else {
          // break;
        }
      },
      // },
      update(),
    });
  }

  ///disposed all seen message
  disposedAllSeen(messageId) async{
    socket!.on('seen-message-$messageId', (data) => {});
  }


  ///inner screen condition in socket
  chatInnerScreenSocket() async{
    socket!.on('chat-screen-active-conversationID', (data) => {
      print(data),
    });
  }

  ///insert data in db
  insertChatDatabase({oneInsertion = false, ChatData? model}) async {
    final db = await chatDatabase;
    if (oneInsertion == true) {
      await db.insert(
        'UserChat',
        model!.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      for (int i = 0; i < chatData!.data!.data!.length; i++) {
        await chatDatabase.insert(
          'UserChat',
          chatData!.data!.data![i].toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    }
    chatData!.data!.data = await getChatLocalDb();
    update();
  }

  ///sqlite db
  Future<List<ChatData>> getChatLocalDb() async {
    final db = await chatDatabase;

    if (db == null) {
      return [];
    }
    final List<Map<String, dynamic>> maps = await db.query(
      'UserChat', where: "conversation_id = '$conversationID'",
    );
    return List.generate(maps.length, (i) {
      return ChatData(
        id: maps[i]["id"],
        senderId: maps[i]["sender_id"],
        receiverId: maps[i]["receiver_id"],
        sourceId: maps[i]["source_id"],
        parentId: maps[i]["parent_id"],
        conversationId: maps[i]["conversation_id"],
        msg: maps[i]["msg"],
        media: maps[i]["media"],
        fileType: maps[i]["file_type"],
        reply: maps[i]["reply"],
        deleteBy: maps[i]["delete_by"],
        isDeleted: maps[i]["is_deleted"],
        isSeen: maps[i]["receiver_id"] == API().sp.read("id")
            ? 1
            : maps[i]["is_seen"] ?? 0,
        createdAt: maps[i]["created_at"],
        updatedAt: maps[i]["updated_at"],
        isEventRequest: maps[i]["is_event_request"],
        eventRequestAccepted: maps[i]["event_request_accepted"],
        flaggedBy: maps[i]["flagged_by"],
        user: maps[i]["user"],
        parentChat: maps[i]['parent_chat'],
      );
    });
  }


  ///delete for every one socket on
  deleteForEveryOneSocket(conversationId) async{
    socket!.on('message-delete-everyone-$conversationId', (data) async {
      // ChatItem.fromJson(response!.data['data']);
      var d = ChatData.fromJson(data['data']);
      d.isDeleted = 1;
      if(isChat.value == true){
        int index =
        chatData!.data!.data!.indexWhere((element) => element.id == d.id);
        chatData!.data!.data![index].isDeleted = 1;
        var dbs = await _chatDatabase.getDatabase;
        dbs.update('UserChat', d.toJson(), where: '(id = ${d.id})');
        update();
      }else{
        // getChatRoom();
      }
    });
  }

  ///disposed delete message socket
  disposedDeleteForEveryOneSocket(conversationId) async{
    socket!.on('message-delete-everyone-$conversationId', (data) async {});
  }


  alertDialog(
      ChatData element,
      index, {
        isTime = false,
      }) {
    return Get.dialog(AlertDialog(
      backgroundColor: Colors.black87,
      title: Text(
        'Delete Message',
        style: TextStyle(
            color: Colors.white, fontSize: 18),
      ),
      content: Text(
        'Are you sure you want to delete the message?',
        style: TextStyle(
            color: Colors.white, fontSize: 15),
      ),
      actions: [
        TextButton(
            child: Text(
              'Delete',
              style: TextStyle(
                  color: Colors.white, fontSize: 12),
            ),
            onPressed: () async {
              conversationID = element.conversationId;
              var db = await _chatDatabase.getDatabase;
              print(chatData!.data!.data![index].toJson());
              await db.delete('UserChat',
                  where:
                  '(id = ${chatData!.data!.data![index].id})');
              chatData!.data!.data = await getChatLocalDb();
              var formData = form.FormData.fromMap({
                "message_id": element.id
              });
              var response = await API().postApi(formData, 'delete-for-me',);
              if(response.statusCode == 200){
                chatData!.data!.data!.removeWhere((chat) {
                  return element.id == chat.id;
                });
                update();
                getAllChatRoom();
                Get.back();
              }
            }),
        isTime == true
            ? SizedBox()
            : element.senderId == API().sp.read("userId")
            ? TextButton(
            child: Text(
              'Delete For EveryOne',
              style: TextStyle(
                  color: Colors.white, fontSize: 12),
            ),
            onPressed: () async {
              conversationID = chatData!.data!.data![index].conversationId;
              var db = await _chatDatabase.getDatabase;
              chatData!.data!.data![index].isDeleted = 1;
              await db.update(
                'UserChat',
                chatData!.data!.data![index].toJson(),
                where:
                '(id = ${chatData!.data!.data![index].id})',
              );
              chatData!.data!.data = await getChatLocalDb();
              var formData =
              form.FormData.fromMap({"message_id": element.id});
              var resp = await API().postApi(formData, 'delete-for-everyone',);
              if (resp.statusCode == 200) {
                chatData!.data!.data!.any((chat) {
                  if (element.id == chat.id) {
                    chatData!.data!.data![index].isDeleted =
                    1;
                    return true;
                  }
                  return false;
                });
              }
              Get.back();
              update();
              getAllChatRoom();
            })
            : SizedBox(),
        TextButton(
            child: Text(
              'No',
              style: TextStyle(
                  color: Colors.white, fontSize: 12),
            ),
            onPressed: () {
              // print(API().sp.read("userId"));
              // print(element.senderId);
              Get.back();
            }),
      ],
    ));
  }


  ///alert for replay or delete Chat
  Widget chatTilePopUp(ChatData element, context, index, {isTime = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          width: 140,
          height: 50,
          color: Color(0xFF4C4C4C),
          child: GridView.count(
            padding: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
            crossAxisCount:/*element.senderId == API().sp.read("userId") ? */2/*:3*/,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: chatTileMenuList
                .map((item) => GestureDetector(
              onTap: () async {
                if (item.title == 'Reply') {
                  Navigator.pop(context);
                  isReplying(true);
                  replyModel = element;
                  replyId = element.id.toString();
                  focusNode.requestFocus();
                  update();
                } else/* if (item.title == 'Delete')*/ {
                  Navigator.pop(context);
                  var date = DateTime.parse(element.createdAt!);
                  var difference =
                      DateTime.now().difference(date).inHours;

                  // var difference = DateTime.now().difference(date).inHours;
                  print(difference);
                  if (difference > 1) {
                    alertDialog(
                      element,
                      index,
                      isTime: true,
                    );
                  } else {
                    alertDialog(
                      element,
                      index,
                    );
                  }
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    item.icon,
                    size: 20,
                    color: Colors.white,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 2),
                    child: Text(
                      item.title,
                      style:
                      TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ))
                .toList(),
          ),
        ),
      ),
    );
  }

  /// Custom Popup Menu
  Widget popUpMenu() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          width: 150,
          height: 50,
          color: const Color(0xFF4C4C4C),
          child: GridView.count(
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            crossAxisCount: 2,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: menuItems
                .map((item) => GestureDetector(
              onTap: () async {
                isReplying(false);
                replyModel = null;
                // replyId = null;
                Map<Permission, PermissionStatus> statuses =
                await permissionsNeeded.request();
                if (item.title == 'Camera') {
                  customPopupMenuController.hideMenu();
                  // if (statuses.values.every(
                  //     (status) => status == PermissionStatus.granted)) {
                  isPermissionsGranted = true;
                  _imgFromGallery(ImageSource.camera,'camera');
                  // } else {
                  //   BotToast.showText(text: 'Permission not granted');
                  // }
                } else if (item.title == 'Gallery') {
                  customPopupMenuController.hideMenu();
                  // if (statuses.values.every(
                  //     (status) => status == PermissionStatus.granted)) {
                  //   isPermissionsGranted = true;
                  // getImages();
                  _imgFromGallery(ImageSource.gallery,'gallery');
                  // } else {
                  //   BotToast.showText(text: 'Permission not granted');
                  // }
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    item.icon,
                    size: 20,
                    color: Colors.white,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 2),
                    child: Text(
                      item.title,
                      style:
                      TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ))
                .toList(),
          ),
        ),
      ),
    );
  }

  ///camera ftn
  _imgFromGallery(ImageSource source,type) async {
    try {
      imageFile = null;
      multipleImageList.clear();
      chatFileList.clear();
      file = null;
      FilePickerResult? result;
      if(type == 'gallery') {
        result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.any,
        );
        for (int i = 0; i < result!.files.length; i++) {
          multipleImageList.add(MediaClass(
            filename: result.files[i].path,
            fileType: result.files[i].extension,
          ));
          // chatFileList.add(form.MultipartFile.fromFileSync(
          //   result.files[i].path!,
          //   filename: "Image.${result.files[i].path!.split('.').last}",
          //   contentType:
          //   MediaType("image", result.files[i].path!.split('.').last),
          // ));
        }
      }else{
        final XFile? xFile = await _picker.pickImage(source: source, imageQuality: 50);
        multipleImageList.add(MediaClass(
          filename: xFile!.path,
          fileType: xFile.name,
        ));
        // chatFileList.add(form.MultipartFile.fromFileSync(
        //   xFile.path,
        //   filename: "Image.${xFile.path.split('.').last}",
        //   contentType:
        //   MediaType("image", xFile.path.split('.').last),
        // ));
      }
      fieldUpdate(true);
      update();
    } catch (e) {
      pickImageError = e;
    }
  }

}


class ChatBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<ChatController>(() => ChatController());
  }
}