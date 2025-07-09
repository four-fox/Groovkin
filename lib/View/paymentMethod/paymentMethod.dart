// ignore_for_file: prefer_const_literals_to_create_immutables, must_be_immutable
import 'package:flutter/material.dart';

import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/authView/autController.dart';

class PaymentMethodScreen extends StatelessWidget {
  PaymentMethodScreen({super.key});

  int paymentMethodVal = Get.arguments['paymentMethod'] ?? 1;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(
        theme: theme,
      ),
      body: GetBuilder<AuthController>(builder: (controller) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25),
          child: Column(
            children: [
              cardsType(
                  theme: theme,
                  context: context,
                  controller: controller,
                  radioValuee: 0,
                  onChanged: (v) {
                    controller.radioValue.value = v;
                    controller.update();
                  }),
              const SizedBox(
                height: 24,
              ),
              cardsType(
                  theme: theme,
                  context: context,
                  radioValuee: 1,
                  controller: controller,
                  image: "assets/masterCard.png",
                  onChanged: (v) {
                    controller.radioValue.value = v;
                    controller.update();
                  }),
              const SizedBox(
                height: 24,
              ),
              cardsType(
                  theme: theme,
                  context: context,
                  radioValuee: 2,
                  controller: controller,
                  image: "assets/amex.png",
                  onChanged: (v) {
                    controller.radioValue.value = v;
                    controller.update();
                  }),
            ],
          ),
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: CustomButton(
          borderClr: Colors.transparent,
          onTap: () {
            Get.toNamed(Routes.addCardDetails,
                arguments: {'paymentMethod': paymentMethodVal});
          },
          text: "Add Card",
        ),
      ),
    );
  }

  Widget cardsType(
      {theme, context, controller, image, radioValuee, onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          border: Border.all(
            color: DynamicColor.whiteClr.withValues(alpha:0.4),
          ),
          borderRadius: BorderRadius.circular(10),
          image: const DecorationImage(
              image: AssetImage("assets/grayClor.png"), fit: BoxFit.fill)),
      child: Row(
        children: [
          Image(
            image: AssetImage(image ?? "assets/visaCard.png"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "**** **** **** 4567",
                  style: poppinsRegularStyle(
                      fontSize: 16,
                      color: theme.primaryColor,
                      context: context),
                ),
                Text(
                  "Expires 10/24",
                  style: poppinsRegularStyle(
                      fontSize: 12,
                      color: theme.primaryColor,
                      context: context),
                ),
              ],
            ),
          ),
          const Spacer(),
          Theme(
            data: ThemeData(
              //here change to your color
              unselectedWidgetColor: DynamicColor.yellowClr,
            ),
            child: Radio(
              value: radioValuee,
              groupValue: controller.radioValue.value,
              activeColor: DynamicColor.yellowClr,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class ViewPaymentMethod extends StatefulWidget {
  const ViewPaymentMethod({super.key});

  @override
  State<ViewPaymentMethod> createState() => _ViewPaymentMethodState();
}

class _ViewPaymentMethodState extends State<ViewPaymentMethod> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  RxBool defaultPayment = true.obs;
  OutlineInputBorder? border;

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withValues(alpha:0.7),
        width: 2.0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: "Payment Methods"),
      body: Column(
        children: [
          CreditCardWidget(
            glassmorphismConfig: Glassmorphism.defaultConfig(),
            // glassmorphismConfig:
            // useGlassMorphism ? Glassmorphism.defaultConfig() : null,
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            cardHolderName: cardHolderName,
            cvvCode: cvvCode,
            bankName: 'Axis Bank',
            frontCardBorder:
                !useGlassMorphism ? Border.all(color: Colors.grey) : null,
            backCardBorder:
                !useGlassMorphism ? Border.all(color: Colors.grey) : null,
            showBackView: isCvvFocused,
            obscureCardNumber: true,
            obscureCardCvv: true,
            isHolderNameVisible: true,
            backgroundImage: useBackgroundImage ? 'assets/card_bg.png' : null,
            isSwipeGestureEnabled: true,
            onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
            customCardTypeIcons: <CustomCardTypeIcon>[
              CustomCardTypeIcon(
                cardType: CardType.mastercard,
                cardImage: Image.asset(
                  'assets/mastercard.png',
                  height: 48,
                  width: 48,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  borderClr: Colors.transparent,
                  widths: Get.width / 3.5,
                  backgroundClr: false,
                  color2: DynamicColor.lightBlackClr,
                  color1: DynamicColor.lightBlackClr,
                  text: "All",
                ),
                CustomButton(
                  borderClr: Colors.transparent,
                  widths: Get.width / 3.0,
                  onTap: () {
                    Get.back();
                  },
                  text: "Add new card",
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(image: AssetImage("assets/doubleArrowUp.png")),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today 5 : 30 PM",
                        style: poppinsRegularStyle(
                            fontSize: 14,
                            color: DynamicColor.grayClr.withValues(alpha:0.8)),
                      ),
                      Text(
                        "John",
                        style: poppinsMediumStyle(
                          fontSize: 14,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  "21-Aug-2023",
                  style: poppinsRegularStyle(
                      fontSize: 14, color: DynamicColor.redClr),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Divider(
              thickness: 2,
              color: DynamicColor.grayClr.withValues(alpha:0.7),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Image(image: AssetImage("assets/doubleArrowDown.png")),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today 6 : 00 PM",
                        style: poppinsRegularStyle(
                            fontSize: 14,
                            color: DynamicColor.grayClr.withValues(alpha:0.8)),
                      ),
                      Text(
                        "John",
                        style: poppinsMediumStyle(
                          fontSize: 14,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  "21-Aug-2023",
                  style: poppinsRegularStyle(
                      fontSize: 14, color: DynamicColor.greenClr),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Divider(
              thickness: 2,
              color: DynamicColor.grayClr.withValues(alpha:0.7),
            ),
          ),
        ],
      ),
    );
  }
}
