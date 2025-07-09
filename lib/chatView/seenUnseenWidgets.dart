import 'package:flutter/material.dart';

import '../Components/Network/API.dart';
import '../Components/timeAgoWidget.dart';
import 'chatInnerDataModel.dart';

class SeenUnseenWidget extends StatefulWidget {
  const SeenUnseenWidget({super.key, this.chatData});

  final ChatData? chatData;

  @override
  State<SeenUnseenWidget> createState() => _SeenUnseenWidgetState();
}

class _SeenUnseenWidgetState extends State<SeenUnseenWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 3.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 3),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  '${timeAgoSinceDate(widget.chatData!.createdAt!.toString())}',
                  style: TextStyle(
                    fontSize: 10,
                    color: widget.chatData!.senderId != API().sp.read('userId')
                        ? Colors.black87
                        : Colors.white,
                  ),
                ),
              ),
            ),
            widget.chatData!.isSeen == 1
                ? const Icon(
                    Icons.done_all,
                    size: 13,
                    color: Colors.blue,
                  )
                : const Icon(
                    Icons.check,
                    size: 13,
                    color: Colors.grey,
                  ),
          ],
        ));
  }
}
