import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';
import 'package:groovkin/View/counters/bottomTextFields.dart';
import 'package:groovkin/View/counters/messagesListWidget.dart';

class CounterScreen extends StatefulWidget {
  CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  RxBool textFieldShow = false.obs;
  bool accept = Get.arguments['acceptVal'];
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
      // _controller.getAllMessages(userId: receiverId, sourceId: sourceId);
    } else {
      _controller.getAllMessages(userId: userId, sourceId: eventId);
    }
  }

  @override
  void didUpdateWidget(covariant CounterScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print("DIDUPDAED");
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(
        theme: theme,
        text: "Counters",
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
              child: GetBuilder<EventController>(
                builder: (controller) => ((textFieldShow.value == false) &&
                        (controller.eventDetail!.data!.status != "completed"))
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        child: CustomButton(
                          widths: Get.width,
                          heights: 37,
                          borderClr: Colors.transparent,
                          text: "Counter",
                          onTap: () {
                            textFieldShow.value = !textFieldShow.value;
                            setState(() {});
                          },
                        ),
                      )
                    : controller.eventDetail!.data!.status == "completed"
                        ? SizedBox.shrink()
                        : BottomTextFields(
                            userId: userId,
                            eventId: eventId,
                          ),
              )),
        ],
      ),
    );
  }
}
