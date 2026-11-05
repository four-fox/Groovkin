import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/location/location_contract.dart';

Future<void> showLocationMessage(
  BuildContext context,
  LocationCheckResult result,
) {
  if (result.feedback == LocationFeedback.field &&
      result.kind == LocationCheckKind.rejected) {
    return Future.value();
  }
  final message = result.message.trim().isEmpty
      ? (result.kind == LocationCheckKind.network
          ? kLocationNetworkMessage
          : kLocationServerMessage)
      : result.message.trim();
  return showDialog<void>(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xffeac15a), Color(0xffb77712)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.kind == LocationCheckKind.rejected
                    ? 'Registration area'
                    : 'Try again',
                style: poppinsRegularStyle(
                  fontSize: 16,
                  color: DynamicColor.whiteClr,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: poppinsRegularStyle(
                  fontSize: 14,
                  color: DynamicColor.whiteClr,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: Get.back,
                  child: Container(
                    height: 35,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: DynamicColor.blackClr,
                    ),
                    child: Center(
                      child: Text(
                        'OK',
                        style: poppinsMediumStyle(
                          fontSize: 16,
                          color: DynamicColor.whiteClr,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
