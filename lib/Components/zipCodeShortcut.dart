import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/authView/autController.dart';

class ZipCodeShortcut extends StatelessWidget {
  const ZipCodeShortcut({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (controller) {
        final zip =
            controller.userData?.data?.profile?.zipCode?.toString().trim();
        final hasZip = zip != null && zip.isNotEmpty;
        final label = hasZip ? 'ZIP Code: $zip' : 'ZIP Code: Add';
        return GestureDetector(
          onTap: () {
            if (controller.userData?.data?.profile != null) {
              controller.profileDataBind(scrollToZip: true);
            } else {
              Get.toNamed(
                Routes.profileScreen,
                arguments: {'scrollToZip': true},
              );
            }
          },
          child: Text(
            label,
            style: poppinsMediumStyle(
              fontSize: compact ? 11 : 12,
              context: context,
              color: DynamicColor.lightYellowClr,
              underline: true,
            ),
          ),
        );
      },
    );
  }
}
