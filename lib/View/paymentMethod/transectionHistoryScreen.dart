


// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class TransactionScreen extends StatelessWidget {
  TransactionScreen({super.key});

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
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme,text: "Transaction History"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CreditCardWidget(
              glassmorphismConfig:
              useGlassMorphism ? Glassmorphism.defaultConfig() : null,
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              isSwipeGestureEnabled: true,
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
              backgroundImage:
              useBackgroundImage ? 'assets/card_bg.png' : null,
              onCreditCardWidgetChange:
                  (CreditCardBrand creditCardBrand) {},
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                CustomButton(
                  color2: DynamicColor.lightWhite.withOpacity(0.5),
                  color1: DynamicColor.lightWhite.withOpacity(0.5),
                  // bgImage: ,
                  widths: 80,
                  heights: 35,
                  backgroundClr: false,
                  borderClr: Colors.transparent,
                  text: "All",
                  onTap: (){
                    Get.toNamed(Routes.viewAllTransactionHistory);
                  },
                ),
                CustomButton(
                  widths: 130,
                  onTap: (){
                    Get.toNamed(Routes.addCardDetails,
                    arguments: {
                      "paymentMethod": 2
                    }
                    );
                  },
                  heights: 35,
                  backgroundClr: true,
                  borderClr: Colors.transparent,
                  text: "Add new card",
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Text("Transaction History",
              style: poppinsMediumStyle(
                fontSize: 17,
                context: context,
                color: theme.primaryColor,
              ),
            ),
            Expanded(
              child: SizedBox(
                height: Get.height/2.27,
                child: ListView.builder(
                    itemCount: 18,
                    itemBuilder: (BuildContext context,index){
                  return GestureDetector(
                    onTap: (){
                      Get.toNamed(Routes.confirmationEventScreen);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 4.0,horizontal: 9),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: DynamicColor.darkGrayClr
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("# SB-001598",
                                  style: poppinsRegularStyle(
                                    fontSize: 12,
                                    context: context,
                                    color: DynamicColor.lightWhite
                                  ),
                                ),
                                Text("Mark Anderson",
                                  style: poppinsMediumStyle(
                                    fontSize: 14,
                                    context: context,
                                    color: theme.primaryColor,
                                  ),
                                ),
                                Text("09-Aug-23  08:00PM",
                                  style: poppinsRegularStyle(
                                      fontSize: 12,
                                      context: context,
                                      color: DynamicColor.lightWhite
                                  ),
                                ),
                              ],
                            ),
                            Text("\$1000",
                              style: poppinsMediumStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  context: context,
                                  color: theme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }
}


class ViewAllTransactionHistory extends StatelessWidget {
  const ViewAllTransactionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme,text: "Transaction History",),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: ListView.builder(
            // itemCount: 18,
          shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext context,index){
              return GestureDetector(
                onTap: (){
                  Get.toNamed(Routes.confirmationEventScreen);
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4.0,horizontal: 9),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: DynamicColor.darkGrayClr
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("# SB-001598",
                              style: poppinsRegularStyle(
                                  fontSize: 12,
                                  context: context,
                                  color: DynamicColor.lightWhite
                              ),
                            ),
                            Text("Mark Anderson",
                              style: poppinsMediumStyle(
                                  fontSize: 14,
                                  context: context,
                                  color: theme.primaryColor,
                              ),
                            ),
                            Text("09-Aug-23  08:00PM",
                              style: poppinsRegularStyle(
                                  fontSize: 12,
                                  context: context,
                                  color: DynamicColor.lightWhite
                              ),
                            ),
                          ],
                        ),
                        Text("\$1000",
                          style: poppinsMediumStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              context: context,
                              color: theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}

