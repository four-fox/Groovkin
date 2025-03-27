


// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class PaymentConfirmationScreen extends StatelessWidget {
  PaymentConfirmationScreen({super.key});

  RxBool acceptTerms = false.obs;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme,text: "Confirmation"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              customRow(theme: theme,context: context,
                  title: "Invoice Number",
                  value: "# SB-001598"
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Mark Anderson",
                  style: poppinsMediumStyle(
                    fontSize: 18,
                    context: context,
                    color: theme.primaryColor,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width:Get.width/ 3,
                  child: Text("35 County Road T500, Waubay,sd, 53233  United States", style: poppinsRegularStyle(
                      fontSize: 12,
                      context: context,
                      color: DynamicColor.lightWhite,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              customRow(theme: theme,context: context,),
              const SizedBox(
                height: 10,
              ),
              customRow(theme: theme,context: context,
              title: "Time",
                value: "08 : 00 PM"
              ),
              const SizedBox(
                height: 10,
              ),
              customRow(theme: theme,context: context,
              title: "Subtotal",
                value: "\$1000"
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Description",
                style: poppinsMediumStyle(
                  fontSize: 18,
                  context: context,
                  color: theme.primaryColor,
                ),
                ),
              ),
              Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”',
                style: poppinsRegularStyle(
                  fontSize: 12,
                  context: context,
                  color: theme.primaryColor,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              customRow(theme: theme,context: context,
                  title: "50% Down Payment",
                  value: "\$500"
              ),
              const SizedBox(
                height: 10,
              ),
              customRow(theme: theme,context: context,
                  title: "Tax (5%)",
                  value: "\$50"
              ),
              const SizedBox(
                height: 10,
              ),
              customRow(theme: theme,context: context,
                  title: "Groovkin Tax(5%)",
                  value: "\$50"
              ),
              const SizedBox(
                height: 10,
              ),
              customRow(theme: theme,context: context,
                  title: "Stripe Tax(10%)",
                  value: "\$100"
              ),
              const SizedBox(
                height: 10,
              ),
              customRow(theme: theme,context: context,
                  title: "Balance Due",
                  value: "\$500"
              ),
              Divider(
                thickness: 2,
                color: DynamicColor.avatarBgClr,
              ),
              const SizedBox(
                height: 15,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Disclaimer",
                  style: poppinsMediumStyle(
                    fontSize: 18,
                    context: context,
                    color: theme.primaryColor,
                  ),
                ),
              ),
              Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”',
                style: poppinsRegularStyle(
                  fontSize: 12,
                  context: context,
                  color: theme.primaryColor,
                ),
              ),
              Row(crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(
                        ()=> Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: theme.primaryColor,
                      ),
                      child: SizedBox(
                        width: 25,
                        child: Checkbox(
                            activeColor: DynamicColor.lightRedClr,
                            value: acceptTerms.value, onChanged: (v){
                          acceptTerms.value = !acceptTerms.value;
                        }),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: SizedBox(
                      child: Text('i have read and agree to the terms and conditions',
                        style: poppinsRegularStyle(
                            fontSize: 12,context: context,
                            color: theme.primaryColor,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: CustomButton(
                  heights: 50,
                  onTap: (){
                    Future.delayed(const Duration(milliseconds: 2000),(){
                      Get.offAllNamed(Routes.bottomNavigationView,
                          arguments: {
                            "indexValue": 0
                          }
                      );
                    });
                    Get.toNamed(Routes.successPaymentScreen);
                  },
                  widths: Get.width,
                  text: "Agree & Accept",
                  borderClr: Colors.transparent,
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget customRow({title,value,theme,context}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title??"Date",
          style: poppinsRegularStyle(
              fontSize: 16,
              context: context,
              color: theme.primaryColor,
          ),
        ),
        Text(value??"09-Aug-23",
          style: poppinsRegularStyle(
              fontSize: 16,
              context: context,
              color: theme.primaryColor,
          ),
        ),
      ],
    );
  }
}


class SuccessPaymentScreen extends StatelessWidget {
  const SuccessPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: DynamicColor.greenClr.withOpacity(0.4),
              child: CircleAvatar(
                radius: 35,
                backgroundColor: DynamicColor.greenClr.withOpacity(0.6),
                child: Icon(Icons.check,
                size: 40,
                  color: theme.primaryColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Accept',
              style: poppinsMediumStyle(
                fontSize: 18,
                context: context,
                fontWeight: FontWeight.w700,
                color: theme.primaryColor,
              ),
              ),
            ),
            Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s',
            style: poppinsRegularStyle(
              fontSize: 14,
              context: context,
              color: theme.primaryColor,
            ),
            ),
          ],
        ),
      ),
    );
  }
}
