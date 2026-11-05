// ignore_for_file: unnecessary_import

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:dio/dio.dart' as form;
import 'package:http_parser/http_parser.dart';
import '../Components/Network/API.dart';
import '../Components/mediaModel.dart';
import '../services/socket_io_class.dart';
import '../services/socket_session.dart';
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

class ChatController extends GetxController {
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
  RxBool peerTyping = false.obs;
  String? _boundConversationId;
  bool? _lastTypingEmit;

  @override
  void onInit() {
    super.onInit();
    initDatabase();
    SocketIoClass().addSessionBinder(_bindRealtimeEvents);
    SocketIoClass().start();
  }

  @override
  void onClose() {
    emitTyping(false);
    _unbindRealtimeEvents();
    SocketIoClass().removeSessionBinder(_bindRealtimeEvents);
    super.onClose();
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
  final searchingController = TextEditingController();

  getNewUser({
    nextUrl,
  }) async {
    newUserChatLoader(true);
    // if(searchingController.text.isNotEmpty){
    //   searchValue = "&search${searchingController.text}";
    // }
    var formData = form.FormData.fromMap(
      {
        "search": searchingController.text,
        "role_name": API().sp.read('role') == "eventOrganizer"
            ? "venue_manager"
            : "event_owner"
      },
    );

    var response =
        await API().postApi(formData, "get-all-users", fullUrl: nextUrl);

    if (response.statusCode == 200) {
      if (nextUrl == null) {
        newUserData = ChatNewUserModel.fromJson(response.data);
        getNewUserWait = false;
      } else {
        newUserData!.data!.data!
            .addAll(ChatNewUserModel.fromJson(response.data).data!.data!);
        newUserData!.data!.nextPageUrl =
            ChatNewUserModel.fromJson(response.data).data!.nextPageUrl;
        getNewUserWait = false;
      }
      newUserChatLoader(false);
      update();
    }
  }

  ///get chat room
  RxBool getAllChatRoomLoader = true.obs;
  ChatRoomModel? chatRoomData;
  bool getAllChatRoomWait = false;
  final chatRoomDataController = TextEditingController();

  getAllChatRoom({nextUrl}) async {
    getAllChatRoomLoader(false);

    var fromData = form.FormData.fromMap({
      "search": chatRoomDataController.text,
    });

    var response = await API().postApi(fromData, 'get-inbox', fullUrl: nextUrl);

    if (response.statusCode == 200) {
      if (nextUrl == null) {
        chatRoomData = ChatRoomModel.fromJson(response.data);
        getAllChatRoomWait = false;
      } else {
        chatRoomData!.data!.data!
            .addAll(ChatRoomModel.fromJson(response.data).data!.data!);
        chatRoomData!.data!.nextPageUrl =
            ChatNewUserModel.fromJson(response.data).data!.nextPageUrl;
        getNewUserWait = false;
      }

      getAllChatRoomLoader(true);
      update();
    }
  }

  /// get all chats
  RxBool getAllChatLoader = true.obs;
  ChatInnerDataModel? chatData;

  getAllChat({id, nextUrl}) async {
    if (nextUrl == null) {
      initDatabase();
      getAllChatLoader(false);
    }
    var formData = form.FormData.fromMap({'user_id': id});
    var response = await API().postApi(formData, "chats", fullUrl: nextUrl);
    if (response.statusCode == 200) {
      if (nextUrl == null) {
        chatData = null;
        chatData = ChatInnerDataModel.fromJson(response.data);
        chatWait = false;
        isChat.value = true;
      } else {
        chatData!.data!.data!
            .addAll(ChatInnerDataModel.fromJson(response.data).data!.data!);
        chatData!.data!.nextPageUrl =
            ChatInnerDataModel.fromJson(response.data).data!.nextPageUrl;
        chatWait = false;
      }
      if (chatData!.data!.data!.isNotEmpty) {
        if (jsonDecode(chatData!.data!.data![0].user!)['user_status'] ==
            'true') {
          innerUserOnline.value = true;
        }
        conversationID = chatData!.data!.data![0].conversationId;
        _ensureConversationBindings();
        if (response.data['data']['data'][0]['creator_id'] !=
            API().sp.read("userId")) {
          messageSeen(conversationID);
        }
      }
      getAllChatLoader(true);
      update();
      if (chatData!.data!.data!.isNotEmpty) {
        insertChatDatabase();
      }
    }
  }

  /// send message

  RxBool isSendLoading = false.obs;
  sendMessage({receiverId}) async {
    isSendLoading.value = true;
    if (multipleImageList.isNotEmpty) {
      chatFileList.clear();
      for (int i = 0; i < multipleImageList.length; i++) {
        chatFileList.add(
          form.MultipartFile.fromFileSync(
            multipleImageList[i].filename!,
            filename: "Image.${multipleImageList[i].filename!.split('.').last}",
            contentType: MediaType(
                "image", multipleImageList[i].filename!.split('.').last),
          ),
        );
      }
    }

    var formData = form.FormData.fromMap({
      'receiver_id': receiverId,
      "type": "single_message",
      if (messageController.text.isNotEmpty) 'msg': messageController.text,
      if (chatFileList.isNotEmpty) "media[]": chatFileList,
      if (bottomContainer.value || replyId != null) "parent_id": replyId,
    });

    var response =
        await API().postApi(formData, 'send-message', showProgress: false);

    if (response.statusCode == 200) {
      var d = ChatData.fromJson(response.data['data']);
      if (d.senderId == API().sp.read("userId")) {
        conversationID = d.conversationId;
        _ensureConversationBindings();
        chatData!.data!.data!.insert(0, d);
      }
      insertChatDatabase(oneInsertion: true, model: d);
      if (chatData!.data!.data!.length > 5) {
        scrollController!
            .jumpTo(index: 0, automaticAlignment: false, alignment: 0.4);
      }
      clearData();
      update();
    }
    isSendLoading.value = false;
  }

  clearData() async {
    emitTyping(false);
    messageController.clear();
    chatFileList.clear();
    replyModel = null;
    isReplying(false);
    replyId = null;
    bottomContainer(false);
    multipleImageList.clear();
  }

  void closeOpenThread() {
    emitTyping(false);
    peerTyping.value = false;
  }

  /// Tell the server this user is typing. Payload matches the broadcast
  /// contract (`conversation_id`, `user_id`, `is_typing`), not the old
  /// `typing` boolean.
  void emitTyping(bool isTyping) {
    final conversationId = conversationID;
    if (conversationId == null || conversationId.isEmpty) return;
    if (_lastTypingEmit == isTyping) return;
    _lastTypingEmit = isTyping;
    SocketIoClass().emit(
      kTypingEmitEvent,
      typingEmitPayload(
        conversationId: conversationId,
        userId: API().sp.read('userId'),
        isTyping: isTyping,
      ),
    );
  }

  void _bindRealtimeEvents() {
    final userId = normalizeUserId(API().sp.read('userId'));
    if (userId != null) {
      SocketIoClass().on('receiver-message-$userId', _onIncomingMessage);
    }
    _ensureConversationBindings();
  }

  void _unbindRealtimeEvents() {
    final userId = normalizeUserId(API().sp.read('userId'));
    if (userId != null) {
      SocketIoClass().off('receiver-message-$userId');
    }
    _releaseConversationBindings();
  }

  void _ensureConversationBindings() {
    final conversationId = conversationID;
    if (_boundConversationId != null &&
        _boundConversationId != conversationId) {
      _releaseConversationBindings();
    }
    if (conversationId == null || conversationId.isEmpty) return;
    _boundConversationId = conversationId;
    final realtime = SocketIoClass();
    realtime.on('seen-message-$conversationId', _onSeen);
    realtime.on('message-delete-everyone-$conversationId', (data) {
      _onDeleted(data);
    });
    realtime.on('typing-$conversationId', _onTyping);
  }

  void _releaseConversationBindings() {
    final conversationId = _boundConversationId;
    _boundConversationId = null;
    _lastTypingEmit = null;
    if (conversationId == null || conversationId.isEmpty) return;
    final realtime = SocketIoClass();
    realtime.off('seen-message-$conversationId');
    realtime.off('message-delete-everyone-$conversationId');
    realtime.off('typing-$conversationId');
  }

  bool receiver = false;

  void _onIncomingMessage(dynamic data) {
    final message = parseIncomingMessage(data);
    if (message == null) return;
    if (receiver == false) {
      receiver = true;
      if (isChat.value == true) {
        messageSeen(conversationID);
      }
      Future.delayed(const Duration(seconds: 1), () {
        receiver = false;
      });
      receiveMessageEvent(data);
    }
    if (conversationID == message['conversation_id']) {
      messageNotificationSocket(message['id']);
    }
  }

  ///socket value updation
  receiveMessageEvent(data) {
    final message = parseIncomingMessage(data);
    if (message == null) return;
    try {
      _applyIncomingMessage(message);
    } catch (_) {
      if (kDebugMode) {
        debugPrint('incoming chat event ignored');
      }
    }
  }

  void _applyIncomingMessage(Map<String, dynamic> message) {
    if (isChat.value == false) {
      final rooms = chatRoomData?.data?.data;
      if (rooms == null) return;
      final lastMessage = LastMessage.fromJson(message);
      for (int a = 0; a < rooms.length; a++) {
        if (rooms[a].conversationId == lastMessage.conversationId) {
          rooms[a].lastMessage = lastMessage;
          rooms[a].updatedAt = lastMessage.updatedAt;
        }
      }
      rooms.sort((a, b) {
        final left = a.updatedAt;
        final right = b.updatedAt;
        if (left == null && right == null) return 0;
        if (left == null) return 1;
        if (right == null) return -1;
        return right.compareTo(left);
      });
      update();
    } else {
      final items = chatData?.data?.data;
      if (items == null) return;
      final incoming = ChatData.fromJson(message);
      if (incoming.senderId != API().sp.read("userId")) {
        items.insert(0, incoming);
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
        Future.delayed(const Duration(milliseconds: 500), () {
          animatedOpacity(false);
          update();
        });
      } else {
        animatedOpacity = true.obs;
        update();
        Future.delayed(const Duration(milliseconds: 1000), () {
          animatedOpacity(false);
          update();
        });
      }
      // }
      // }
    }
  }

  /// Existing client ack. The production event list does not rename this emit.
  messageNotificationSocket(id) {
    SocketIoClass().emit("message-ack", {
      "id": id,
    });
  }

  /// seen all message
  messageSeen(conversationId) async {
    var formData = form.FormData.fromMap({
      'conversation_id': conversationId,
    });
    var response =
        await API().postApi(formData, 'all-message-seen', showProgress: false);
    if (response.statusCode == 200) {
      for (int i = 0; i < chatData!.data!.data!.length; i++) {
        chatData!.data!.data![i].isSeen = 1;
        // seenMessageSocket(innerScreenChatData!.data!.data![i].id, i);
        update();
      }
    }
  }

  /// Kept so older call sites still attach the conversation listener once.
  seenMessageSocket(conversationId, i) {
    if (conversationId != null) {
      conversationID = conversationId.toString();
      _ensureConversationBindings();
    }
  }

  disposedAllSeen(messageId) {
    if (messageId == null) return;
    SocketIoClass().off('seen-message-$messageId');
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
      'UserChat',
      where: "conversation_id = '$conversationID'",
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
        type: maps[i]["type"],
        user: maps[i]["user"],
        parentChat: maps[i]['parent_chat'],
        event: maps[i]["event"],
      );
    });
  }

  void _onSeen(dynamic raw) {
    final items = chatData?.data?.data;
    if (items == null) return;
    final ids = parseSeenMessageIds(raw);
    var changed = false;
    for (final item in items) {
      final inConversation = item.conversationId == conversationID;
      final matched = ids.isEmpty
          ? inConversation
          : item.id != null && ids.contains(item.id);
      if (matched && item.isSeen != 1) {
        item.isSeen = 1;
        changed = true;
      }
    }
    if (!changed) return;
    insertChatDatabase();
    update();
  }

  void _onTyping(dynamic raw) {
    final event = parseTypingEvent(raw);
    if (event == null) return;
    if (event.conversationId != null &&
        event.conversationId != conversationID) {
      return;
    }
    final self = normalizeUserId(API().sp.read('userId'));
    if (event.userId != null && self != null && event.userId == self) return;
    peerTyping.value = event.isTyping;
    update();
  }

  Future<void> _onDeleted(dynamic raw) async {
    final payload = parseDeleteEveryoneData(raw);
    if (payload == null || isChat.value != true) return;
    final items = chatData?.data?.data;
    if (items == null) return;
    ChatData deleted;
    try {
      deleted = ChatData.fromJson(payload);
    } catch (_) {
      return;
    }
    deleted.isDeleted = 1;
    final index = items.indexWhere((element) => element.id == deleted.id);
    if (index < 0) return;
    items[index].isDeleted = 1;
    final database = await _chatDatabase.getDatabase;
    await database.update(
      'UserChat',
      items[index].toJson(),
      where: '(id = ${deleted.id})',
    );
    update();
  }

  deleteForEveryOneSocket(conversationId) {
    if (conversationId == null) return;
    conversationID = conversationId.toString();
    _ensureConversationBindings();
  }

  disposedDeleteForEveryOneSocket(conversationId) {
    if (conversationId == null) return;
    SocketIoClass().off('message-delete-everyone-$conversationId');
  }

  alertDialog(
    ChatData element,
    index, {
    isTime = false,
  }) {
    return Get.dialog(AlertDialog(
      backgroundColor: Colors.black87,
      title: const Text(
        'Delete Message',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
      content: const Text(
        'Are you sure you want to delete the message?',
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
      actions: [
        TextButton(
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            onPressed: () async {
              conversationID = element.conversationId;
              var db = await _chatDatabase.getDatabase;
              print(chatData!.data!.data![index].toJson());
              await db.delete('UserChat',
                  where: '(id = ${chatData!.data!.data![index].id})');
              chatData!.data!.data = await getChatLocalDb();
              var formData = form.FormData.fromMap({"message_id": element.id});
              var response = await API().postApi(
                formData,
                'delete-for-me',
              );
              if (response.statusCode == 200) {
                chatData!.data!.data!.removeWhere((chat) {
                  return element.id == chat.id;
                });
                update();
                getAllChatRoom();

                Get.back();
              }
            }),
        isTime == true
            ? const SizedBox()
            : element.senderId == API().sp.read("userId")
                ? TextButton(
                    child: const Text(
                      'Delete For EveryOne',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    onPressed: () async {
                      conversationID =
                          chatData!.data!.data![index].conversationId;
                      var db = await _chatDatabase.getDatabase;
                      chatData!.data!.data![index].isDeleted = 1;
                      await db.update(
                        'UserChat',
                        chatData!.data!.data![index].toJson(),
                        where: '(id = ${chatData!.data!.data![index].id})',
                      );
                      chatData!.data!.data = await getChatLocalDb();
                      var formData =
                          form.FormData.fromMap({"message_id": element.id});
                      var resp = await API().postApi(
                        formData,
                        'delete-for-everyone',
                      );
                      if (resp.statusCode == 200) {
                        chatData!.data!.data!.any((chat) {
                          if (element.id == chat.id) {
                            chatData!.data!.data![index].isDeleted = 1;
                            return true;
                          }
                          return false;
                        });
                      }
                      Get.back();
                      update();
                      getAllChatRoom();
                    })
                : const SizedBox(),
        TextButton(
            child: const Text(
              'No',
              style: TextStyle(color: Colors.white, fontSize: 12),
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
          color: const Color(0xFF4C4C4C),
          child: GridView.count(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
            crossAxisCount: /*element.senderId == API().sp.read("userId") ? */
                2 /*:3*/,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
                        } else /* if (item.title == 'Delete')*/ {
                          Navigator.pop(context);
                          var date = DateTime.parse(element.createdAt!);
                          var difference =
                              DateTime.now().difference(date).inHours;

                          // var difference = DateTime.now().difference(date).inHours;
                          print(difference);
                          if (difference > 1) {
                            FocusManager.instance.primaryFocus!.unfocus();
                            alertDialog(
                              element,
                              index,
                              isTime: true,
                            );
                          } else {
                            FocusManager.instance.primaryFocus!.unfocus();
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
                            margin: const EdgeInsets.only(top: 2),
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
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
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            crossAxisCount: 2,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: menuItems
                .map((item) => GestureDetector(
                      onTap: () async {
                        isReplying(false);
                        replyModel = null;
                        // replyId = null;
                        // Map<Permission, PermissionStatus> statuses =
                        //     await permissionsNeeded.request();
                        if (item.title == 'Camera') {
                          customPopupMenuController.hideMenu();
                          // if (statuses.values.every(
                          //     (status) => status == PermissionStatus.granted)) {
                          isPermissionsGranted = true;
                          _imgFromGallery(ImageSource.camera, 'camera');
                          // } else {
                          //   BotToast.showText(text: 'Permission not granted');
                          // }
                        } else if (item.title == 'Gallery') {
                          customPopupMenuController.hideMenu();
                          // if (statuses.values.every(
                          //     (status) => status == PermissionStatus.granted)) {
                          //   isPermissionsGranted = true;
                          // getImages();
                          _imgFromGallery(ImageSource.gallery, 'gallery');
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
                            margin: const EdgeInsets.only(top: 2),
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
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
  _imgFromGallery(ImageSource source, type) async {
    try {
      imageFile = null;
      multipleImageList.clear();
      chatFileList.clear();
      file = null;
      List<PlatformFile>? result;
      if (type == 'gallery') {
        result = await FilePicker.pickFiles(
          type: FileType.any,
        );
        for (int i = 0; i < result.length; i++) {
          multipleImageList.add(MediaClass(
            filename: result[i].path,
            fileType: result[i].extension,
          ));
          // chatFileList.add(form.MultipartFile.fromFileSync(
          //   result.files[i].path!,
          //   filename: "Image.${result.files[i].path!.split('.').last}",
          //   contentType:
          //   MediaType("image", result.files[i].path!.split('.').last),
          // ));
        }
      } else {
        final XFile? xFile =
            await _picker.pickImage(source: source, imageQuality: 50);
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
    Get.lazyPut<ChatController>(() => ChatController());
  }
}
