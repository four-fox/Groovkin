


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventsFlow/eventController.dart';

class ConfirmationEventScreen extends StatefulWidget {
  ConfirmationEventScreen({Key? key}) : super(key: key);

  @override
  State<ConfirmationEventScreen> createState() => _ConfirmationEventScreenState();
}

class _ConfirmationEventScreenState extends State<ConfirmationEventScreen> {
  EventController _controller = Get.find();

  num? downPayment;
  num? tax;
  num? groovkinTax;
  num? stripeTax;
  num? balanceDue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    downPayment =double.parse(_controller.hourlyRateController.text)*double.parse(_controller.paymentSchedule!.value)/100;
    tax = double.parse(_controller.hourlyRateController.text)*5/100;
    groovkinTax = double.parse(_controller.hourlyRateController.text)*5/100;
    stripeTax = double.parse(_controller.hourlyRateController.text)*10/100;
    num aa = (downPayment!+ tax!+ groovkinTax!+ stripeTax!);
    print(aa);
    balanceDue =(downPayment!+ tax!+groovkinTax!+stripeTax!) -  double.parse(_controller.hourlyRateController.text);
  }

  // AuthController _authController = Get.find();
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme,text: "Confirmation",
          actions: [
            ((_controller.eventDetail == null) && (_controller.draftCondition.value == true))?
            GestureDetector(
              onTap: (){
                _controller.postEventFunction(context,theme,draft: true);
              },
              child: Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(Icons.drafts),),
            ):SizedBox.shrink()]
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            // customWidget(theme: theme,context: context),
        SizedBox(
          height: 10,
    ),
    Text(((_controller.eventDetail != null)&&(_controller.eventDetail!.data!.venue != null))?_controller.eventDetail!.data!.venue!.venueName! : _controller.venuesDetails!.venueName!,
    style: poppinsRegularStyle(
    fontSize: 14,
    context: context,
    color: theme.primaryColor,
    ),
    ),
    Text(((_controller.eventDetail != null)&&(_controller.eventDetail!.data!.venue != null))?_controller.eventDetail!.data!.venue!.location!: _controller.venuesDetails!.location!,
    style: poppinsRegularStyle(
    fontSize: 14,
    context: context,
    color: DynamicColor.grayClr.withOpacity(0.7)
    ),
    ),
            SizedBox(
              height: 10,
            ),
            customWidget(theme: theme,context: context,title: "Date",value: _controller.eventDateController.text),
            SizedBox(
              height: 10,
            ),
            customWidget(theme: theme,context: context,title: "Time",value: _controller.proposedTimeWindowsController.text),
            SizedBox(
              height: 10,
            ),
            customWidget(theme: theme,context: context,title: "Subtotal",value: "\$ ${_controller.hourlyRateController.text}"),
            SizedBox(
              height: 10,
            ),
            customWidget(theme: theme,context: context,title: "${_controller.paymentSchedule!.value}% Down Payment",value: "\$$downPayment"),
            SizedBox(
              height: 10,
            ),
            customWidget(theme: theme,context: context,title: "Tax (5%) ",value: "\$$tax"),
            SizedBox(
              height: 10,
            ),
            customWidget(theme: theme,context: context,title: "Groovkin Tax(5%)",value: "\$$groovkinTax"),
            SizedBox(
              height: 10,
            ),
            customWidget(theme: theme,context: context,title: "Stripe Tax(10%)",value: "\$$stripeTax"),
            SizedBox(
              height: 10,
            ),
            customWidget(theme: theme,context: context,title: "Balance Due",value: "\$$balanceDue"),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: DynamicColor.grayClr,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
        child: CustomButton(
          borderClr: Colors.transparent,
          onTap: (){
            Get.toNamed(Routes.disclaimerScreen);
          },
          text: "Next",
        ),
      ),
    );
  }

  Widget customWidget({context,theme,title,value}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title??"Invoice Number",
          style: poppinsRegularStyle(
            fontSize: 16,
            context: context,
            color: theme.primaryColor,
          ),
        ),
        Text(value??"# SB-001598",
          style: poppinsRegularStyle(
            fontSize: 14,
            context: context,
            color: theme.primaryColor,
          ),
        ),

      ],
    );
  }
}
