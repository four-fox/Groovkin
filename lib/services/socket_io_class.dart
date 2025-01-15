import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketClass {
  io.Socket? _mainSocket;

  static final SocketClass singleton = SocketClass._interval();
  SocketClass._interval();

  factory SocketClass() {
    return singleton;
  }

  io.Socket? get mainSocket => _mainSocket;

  connectSocket() {
    io.io(
        "",
        io.OptionBuilder()
            .setTransports(['websocket', 'polling']).setAuth({}).build());

    _mainSocket!.connect();

    _mainSocket!.onConnect((_) {
      print('socket is connect');
    });
  }

  joinRoom() {
    mainSocket!.emit("joinRoom", {
      'roomId': "",
      'userId': "",
    });
  }

  sendMessage() {
    mainSocket!.emit("sendMessage", {
      'roomId': "",
      'message': "",
    });
  }

  void onReceiveMessage(Function(String) callback) {
    mainSocket!.on('receiveMessage', (data) {
      callback(data);
    });
  }
}
