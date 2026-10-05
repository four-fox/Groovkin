import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';
import 'package:groovkin/View/counters/bottomTextFields.dart';
import 'package:groovkin/View/counters/messagesListWidget.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int? receiverId = Get.arguments["receiverId"];
  int? sourceId = Get.arguments["sourceId"];

  int? userId = Get.arguments['userId'];
  int? eventId = Get.arguments['eventId'];

  final ManagerController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    _controller.mediaClass.clear();
    _controller.multiPartImg.clear();
    if (receiverId != null && sourceId != null) {
      _controller.getAllMessages(userId: receiverId, sourceId: sourceId);
    } else {
      _controller.getAllMessages(userId: userId, sourceId: eventId);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: customAppBar(
          theme: theme,
          text: "Messages",
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: MessageListWidget(),
            ),
            Positioned(
              bottom: 0,
              child: BottomTextFields(
                userId: userId,
                eventId: eventId,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
