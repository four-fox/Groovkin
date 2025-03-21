import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

typedef ListenFunction = Function(String onData);

// Todo  SingleTon Class
class SocketIoClass {
  io.Socket? socket;
  SocketIoClass._interval();

  static SocketIoClass? singleton;

  factory SocketIoClass() {
    return singleton ??= SocketIoClass._interval();
  }

  // Todo Connect Socket

  connectSocket() {
    socket = io.io("", <String, dynamic>{
      'transports': ['webscoket'],
    });

    socket!.connect();

    socket!.onConnect((data) {
      if (kDebugMode) {
        print("Your Socket Is Connected!");
      }
    });
  }

  // Todo ListenMessage Socket

  listenMessageSocket(
    String event,
    ListenFunction listenFuntion,
  ) async {
    socket!.off(event);
    socket!.on(event, (data) {
      listenFuntion.call(data);
    });
  }
}
