// ignore_for_file: unused_field, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/alertmessage.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';
import 'package:groovkin/View/counters/messagesModel.dart';
import 'package:intl/intl.dart';
import 'package:popup_banner/popup_banner.dart';

class MessageListWidget extends StatelessWidget {
  MessageListWidget({Key? key}) : super(key: key);

  ManagerController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification.metrics.pixels ==
            scrollNotification.metrics.maxScrollExtent) {
          if (_controller.chatData!.data!.nextPageUrl != null) {
            if (_controller.chatWaiting == false) {
              _controller.chatWaiting = true;
              Future.delayed(Duration(seconds: 2), () {
                _controller.chatWaiting = false;
              });
              _controller.getAllMessages(
                  fullUrl: _controller.chatData!.data!.nextPageUrl);
              return true;
            }
          }
          return false;
        }
        return false;
      },
      child: GetBuilder<ManagerController>(builder: (controller) {
        return controller.chatData == null
            ? SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.only(bottom: kToolbarHeight * 1.2),
                child: ListView.builder(
                    itemCount: controller.chatData!.data!.data!.length,
                    reverse: true,
                    itemBuilder: (BuildContext context, index) {
                      MessageItem messageObject =
                          controller.chatData!.data!.data![index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  messageObject.user!.id ==
                                          API().sp.read("userId")
                                      ? "Message by you"
                                      : messageObject.user!.name!,
                                  style: poppinsRegularStyle(
                                    context: context,
                                    fontSize: 12,
                                    color: DynamicColor.lightYellowClr,
                                  ),
                                ),
                                Text(
                                  getTimeMethod(messageObject.createdAt!),
                                  style: poppinsRegularStyle(
                                      context: context,
                                      fontSize: 12,
                                      color: DynamicColor.lightRedClr),
                                ),
                              ],
                            ),
                            /// da d image widgets d
                            messageObject.media!.isNotEmpty? imageWidgets(items: messageObject):SizedBox.shrink(),

                            ///da landy da message widget d
                            messageObject.msg != null? Text(messageObject.msg!,
                              style: poppinsRegularStyle(
                                context: context,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: theme.primaryColor,
                              ),
                            ):SizedBox.shrink(),
                            Divider(),
                          ],
                        ),
                      );
                    }));
      }),
    );
  }
}


imageWidgets({required MessageItem items}){
  return SizedBox(
    height: kToolbarHeight*5,
    width: Get.width/1.5,
    child: GridView.builder(
      itemCount: items.media!.length,
      shrinkWrap: false,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:items.media!.length == 1? 1: 2, // Change the number according to your preference
        crossAxisSpacing: 6.0,
        mainAxisSpacing: 6.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        List<String> a = [];
        return Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: (){
                a.clear();
                for (var element in items.media!) {
                  a.add(element.filename!);
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
                        image: NetworkImage(items.media![index].filename!,),
                        fit: BoxFit.cover
                    )
                ),
              ),
            ),
            ((items.media!.length>4) && (index == 3))? GestureDetector(
              onTap: (){
                a.clear();
                for (var element in items.media!) {
                  a.add(element.filename!);
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
                child: Text("+${items.media!.length - 4} more",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff00327A),),
                ),
              ),
            ):SizedBox.shrink()
          ],
        );
      },
    ),
  );
}
