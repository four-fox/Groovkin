import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/switchWidget.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/utils/utils.dart';

/// custom Event Widget
userCustomEvent(
    {GestureTapCallback? onTap,
    theme,
    context,
    img,
    title,
    subtitle,
    location,
    bool networkImg = false,
    datee,
    dayy,
    isDelete}) {
  return GestureDetector(
    onTap: (isDelete != null && isDelete == true)
        ? () {
            Utils.showToast();
          }
        : onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      // color: isDelete ? DynamicColor.disabledColor : Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isDelete != null && isDelete == true)
            Utils.accountDelete(context),
          const SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 23,
                backgroundImage: networkImg == false
                    ? AssetImage(img ?? "assets/eventPreview.png")
                    : NetworkImage(img) as ImageProvider,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? "90’s Grunge and Bowling",
                      style: poppinsRegularStyle(
                        fontSize: 12,
                        context: context,
                        color: theme.cardColor,
                      ),
                    ),
                    Text(
                      subtitle ?? "The Burning Cactus",
                      style: poppinsRegularStyle(
                          fontSize: 13,
                          context: context,
                          color: DynamicColor.grayClr),
                    ),
                    SizedBox(
                      width: Get.width / 1.7,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ImageIcon(
                            const AssetImage("assets/location.png"),
                            color: DynamicColor.grayClr,
                          ),
                          SizedBox(
                            width: Get.width / 2,
                            child: Text(
                              location ?? "Herkimer County Fairgrounds",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: poppinsRegularStyle(
                                fontSize: 12,
                                context: context,
                                color: theme.cardColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              eventDateWidget(
                date: datee,
                day: dayy,
                theme: theme,
                context: context,
                bgClr: theme.primaryColor,
                textClr: theme.scaffoldBackgroundColor,
              ),
            ],
          ),
          Divider(
            color: theme.primaryColor,
          ),
        ],
      ),
    ),
  );
}
