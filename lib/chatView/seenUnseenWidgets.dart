

import 'package:flutter/material.dart';

import '../Components/Network/API.dart';
import '../Components/timeAgoWidget.dart';
import 'chatInnerDataModel.dart';

class SeenUnseenWidget extends StatelessWidget {
   SeenUnseenWidget({super.key,this.chatData});

   ChatData? chatData;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(right: 3.0),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 3),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text('${timeAgoSinceDate(chatData!.createdAt!.toString())}',
                  style: TextStyle(
                    fontSize: 10,
                    color: chatData!.senderId != API().sp.read('userId')
                        ? Colors.black87:Colors.white,
                  ),
                ),
              ),
            ),
            chatData!.isSeen==1? Icon(Icons.done_all,
              size: 13,
              color: Colors.blue,
            ):Icon(Icons.check,
              size: 13,
              color: Colors.grey,
            ),
          ],
        )
    );
  }
}
