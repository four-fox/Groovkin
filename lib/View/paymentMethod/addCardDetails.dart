import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/alertmessage.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';
import 'package:groovkin/main.dart';

class AddCardDetails extends StatefulWidget {
  const AddCardDetails({super.key});

  @override
  State<AddCardDetails> createState() => _AddCardDetailsState();
}

class _AddCardDetailsState extends State<AddCardDetails> {
  bool fromSignUp = Get.arguments?["fromSignUp"] ?? false;

  late HomeController _controller;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  RxBool defaultPayment = true.obs;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  int paymentMethodFlow = Get.arguments['paymentMethod'];
  bool isFromreplaced = Get.arguments?["isFromreplaced"] ?? false;

  //  ################################################## Replaced ###########################################

  saveCard() {
    final validate = formKey.currentState!.validate();
    if (!validate) return;
    if (validate) {
      isFromreplaced == true
          ? Get.back()
          : _controller.addCard(
              cardHolderName,
              cardNumber
                  .toString()
                  .replaceAll(RegExp(r'\s+'), ''), // Remove all whitespace
              expiryDate.split("/").first,
              expiryDate.split("/").last,
              cvvCode,
              fromSignUp);
    }
  }

  @override
  void initState() {
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withValues(alpha: 0.7),
        width: 2.0,
      ),
    );
    super.initState();
    if (Get.isRegistered<HomeController>()) {
      _controller = Get.find<HomeController>();
    } else {
      _controller = Get.put(HomeController());
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: customAppBar(theme: theme, backArrow: fromSignUp ? false : true),
      body: Column(
        children: <Widget>[
          // SizedBox(
          //   height: 30,
          // ),
          CreditCardWidget(
            // glassmorphismConfig:
            //     useGlassMorphism ? Glassmorphism.defaultConfig() : null,
            glassmorphismConfig: Glassmorphism.defaultConfig(
                isDark: isDark(context) ? true : false),
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            cardHolderName: cardHolderName,
            cvvCode: cvvCode,
            // bankName: 'Axis Bank',
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
                  'assets/masterCard.png',
                  height: 48,
                  width: 48,
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CreditCardForm(
                    formKey: formKey,
                    obscureCvv: true,
                    obscureNumber: true,
                    cardNumber: cardNumber,
                    cvvCode: cvvCode,
                    isHolderNameVisible: true,
                    isCardNumberVisible: true,
                    isExpiryDateVisible: true,
                    cardHolderValidator: (cardHolderValue) {
                      if (cardHolderValue!.isEmpty) {
                        return "Please input a valid card holder";
                      }
                      return null;
                    },
                    cardHolderName: cardHolderName,
                    expiryDate: expiryDate,
                    inputConfiguration: InputConfiguration(
                      // themeColor: Colors.blue,
                      // textColor: Colors.white,
                      cardNumberDecoration: InputDecoration(
                        // labelText: 'Number',
                        hintText: 'Card Number',
                        hintStyle: TextStyle(
                            color:
                                isDark(context) ? Colors.white : Colors.black),
                        labelStyle: TextStyle(
                            color:
                                isDark(context) ? Colors.white : Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      expiryDateDecoration: InputDecoration(
                        hintStyle: TextStyle(
                            color:
                                isDark(context) ? Colors.white : Colors.black),
                        labelStyle: TextStyle(
                            color:
                                isDark(context) ? Colors.white : Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),

                        // labelText: 'Expired Date',
                        hintText: 'Expired Date',
                      ),
                      cvvCodeDecoration: InputDecoration(
                        hintStyle: TextStyle(
                            color:
                                isDark(context) ? Colors.white : Colors.black),
                        labelStyle: TextStyle(
                            color:
                                isDark(context) ? Colors.white : Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        // labelText: 'CVV',
                        hintText: 'CVV',
                      ),
                      cardHolderDecoration: InputDecoration(
                        hintStyle: TextStyle(
                            color:
                                isDark(context) ? Colors.white : Colors.black),
                        labelStyle: TextStyle(
                            color:
                                isDark(context) ? Colors.white : Colors.black),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        // labelText: 'CVV',
                        hintText: 'Card Holder',
                      ),
                    ),
                    onCreditCardModelChange: onCreditCardModelChange,
                  ),
                  // Row(
                  //   children: [
                  //     Obx(
                  //       () => Theme(
                  //         data: Theme.of(context).copyWith(
                  //           unselectedWidgetColor: Colors.white,
                  //         ),
                  //         child: Checkbox(
                  //             activeColor: DynamicColor.yellowClr,
                  //             value: defaultPayment.value,
                  //             onChanged: (v) {
                  //               defaultPayment.value = v!;
                  //             }),
                  //       ),
                  //     ),
                  //     Text(
                  //       'Set as default payment method.',
                  //       style: poppinsRegularStyle(
                  //         fontSize: 13,
                  //         context: context,
                  //         color: Theme.of(context).primaryColor,
                  //       ),
                  //     )
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (fromSignUp == true) ...[
                CustomButton(
                  borderClr: Colors.transparent,
                  onTap: () {
                    Get.offAllNamed(Routes.createCompanyProfileScreen,
                        arguments: {
                          "updationCondition": false,
                          "skipBtnHide": false,
                        });
                  },
                  text: "Skip",
                ),
                SizedBox(
                  height: 5,
                ),
              ],
              CustomButton(
                borderClr: Colors.transparent,
                onTap: () {
                  if (paymentMethodFlow == 1) {
                    showDialog(
                        barrierColor: Colors.transparent,
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AlertWidget(
                            height: kToolbarHeight * 5,
                            container: SizedBox(
                              width: Get.width,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 4),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Payment Success',
                                      style: poppinsMediumStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        context: context,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                    CircleAvatar(
                                      radius: 38,
                                      backgroundColor: DynamicColor.yellowClr,
                                      child: Icon(
                                        Icons.check,
                                        size: 45,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Text(
                                          'Your Payment has been\nsuccessfully done ',
                                          textAlign: TextAlign.center,
                                          style: poppinsMediumStyle(
                                            fontSize: 20,
                                            context: context,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface,
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                    Future.delayed(const Duration(seconds: 2), () {
                      Get.back();
                      Get.toNamed(Routes.serviceScreen,
                          arguments: {"addMoreService": 1});
                    });
                  } else if (paymentMethodFlow == 2) {
                    saveCard();
                    // Get.back();
                    // Get.toNamed(Routes.viewPaymentMethod);
                  } else {
                    Get.toNamed(Routes.paymentConfirmationScreen);
                  }
                },
                text: isFromreplaced ? "Replace" : "Add",
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
