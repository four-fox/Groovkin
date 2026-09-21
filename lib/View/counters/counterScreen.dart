import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';
import 'package:groovkin/View/counters/bottomTextFields.dart';
import 'package:groovkin/View/counters/messagesListWidget.dart';
import 'package:groovkin/utils/backend_contract.dart';

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
  final TextEditingController _counterTextController = TextEditingController();

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
  void dispose() {
    _counterTextController.dispose();
    super.dispose();
  }

  Future<void> _submitCounter(EventController eventController) async {
    final id = eventId ?? eventController.eventDetail?.data?.id;
    if (id == null) return;
    await _controller.counterEventRequest(
      eventId: id,
      comment: _counterTextController.text.trim(),
    );
    if (mounted) Get.back();
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
          text: "Counters",
          actions: [
            GetBuilder<EventController>(builder: (eventController) {
              final detail = eventController.eventDetail?.data;
              final canEdit = API().sp.read("role") == "eventOrganizer" &&
                  detail != null &&
                  shouldShowEoRevise(
                    canReviseRequest: detail.canReviseRequest,
                    canEditRequest: detail.canEditRequest,
                    status: detail.status,
                    requestStatus: detail.requestStatus,
                  ) &&
                  (eventId == null || detail.id == eventId);
              if (!canEdit) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    eventController.duplicateValue.value = false;
                    eventController.draftValue.value = false;
                    eventController.assignValueForUpdate();
                    eventController.showEditPreviewScreen.value = true;
                    eventController.update();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        detail.canReviseRequest || detail.canEditRequest
                            ? "Revise"
                            : "Edit",
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.edit),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: MessageListWidget(),
            ),
            Positioned(
                bottom: 0,
                child: GetBuilder<EventController>(builder: (controller) {
                  final detail = controller.eventDetail?.data;
                  if (detail == null) {
                    return const SizedBox();
                  }
                  final showCounter = shouldShowPreApprovalCounter(
                    canCounterRequest: detail.canCounterRequest,
                    status: detail.status,
                    chatExists: (_controller.chatData?.data?.data ?? [])
                        .isNotEmpty,
                  );
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showCounter)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: CustomButton(
                            widths: Get.width,
                            heights: 37,
                            borderClr: Colors.transparent,
                            text: _controller.counteringRequest.value
                                ? "Sending..."
                                : "Counter",
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return AlertDialog(
                                    title: Text(
                                      'Send Counter',
                                      style: poppinsMediumStyle(
                                        context: dialogContext,
                                        fontSize: 16,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                    content: TextField(
                                      controller: _counterTextController,
                                      maxLines: 4,
                                      decoration: const InputDecoration(
                                        hintText:
                                            'Please lower the hourly rate to 80',
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(dialogContext),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(dialogContext);
                                          await _submitCounter(controller);
                                        },
                                        child: const Text('Submit'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      if (detail.status != "completed")
                        BottomTextFields(
                          userId: userId,
                          eventId: eventId,
                        ),
                    ],
                  );
                })),
          ],
        ),
      ),
    );
  }
}
