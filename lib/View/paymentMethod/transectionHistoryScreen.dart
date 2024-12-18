// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';
import 'package:groovkin/utils/utils.dart';

class TransactionScreen extends StatefulWidget {
  TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  HomeController _controller = Get.find();

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
    super.initState();
    _controller.getAllCards().then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        addDefaultCardValue();
      });
    });
  }

  addDefaultCardValue() {
    if (_controller.transactionData.isNotEmpty) {
      final Map<String, dynamic> decode =
          jsonDecode(_controller.transactionData.first.cardDetails.toString());

      cardNumber =
          "${_controller.transactionData.first.first4digit!} 0000 0000 ${_controller.transactionData.first.last4digit!}";
      cardHolderName = _controller.transactionData.first.cardholderName!;
      expiryDate =
          "${decode["exp_month"].toString().length == 1 ? ("0${decode["exp_month"]}") : decode["exp_month"].toString()}/${decode["exp_year"].toString().substring(2)}";
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: "Transaction History"),
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
                  onTap: () {
                    Get.toNamed(Routes.viewAllCardList);
                  },
                ),
                CustomButton(
                  widths: 130,
                  onTap: () {
                    Get.toNamed(Routes.addCardDetails,
                        arguments: {"paymentMethod": 2});
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
            Text(
              "Transaction History",
              style: poppinsMediumStyle(
                fontSize: 17,
                context: context,
                color: theme.primaryColor,
              ),
            ),
            GetBuilder<HomeController>(builder: (homecontroller) {
              return Expanded(
                child: ListView.builder(
                    itemCount: homecontroller.transactionData.length,
                    itemBuilder: (BuildContext context, index) {
                      final transactionData =
                          homecontroller.transactionData[index];
                      return GestureDetector(
                        onTap: () {
                          // Get.toNamed(Routes.confirmationEventScreen);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 9),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: DynamicColor.darkGrayClr),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "# ${transactionData.customerId}",
                                      style: poppinsRegularStyle(
                                          fontSize: 12,
                                          context: context,
                                          color: DynamicColor.lightWhite),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      transactionData.cardholderName ?? "",
                                      style: poppinsMediumStyle(
                                        fontSize: 14,
                                        context: context,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                    Text(
                                      "${Utils.dateFormat(transactionData.createdAt!)}  ${Utils.timeFormat(transactionData.createdAt!)}",
                                      style: poppinsRegularStyle(
                                          fontSize: 12,
                                          context: context,
                                          color: DynamicColor.lightWhite),
                                    ),
                                  ],
                                ),
                                Text(
                                  "\$1000",
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
              );
            })
          ],
        ),
      ),
    );
  }
}

class ViewAllCardList extends StatefulWidget {
  const ViewAllCardList({super.key});

  @override
  State<ViewAllCardList> createState() => _ViewAllCardListState();
}

class _ViewAllCardListState extends State<ViewAllCardList> {
  HomeController _controller = Get.find();
  bool isAllCheck = false;
  List<bool> cardListCheckBox = [];

  @override
  void initState() {
    super.initState();
    _fetchCards();
  }

  void _fetchCards() async {
    await _controller.getAllCards();
    // Ensure transactionData has been populated
    if (_controller.transactionData.isNotEmpty) {
      setState(() {
        cardListCheckBox =
            List<bool>.filled(_controller.transactionData.length, false);
      });
    }
  }

  /// Function to handle "Select All"
  void _toggleSelectAll(bool value) {
    setState(() {
      isAllCheck = value;
      cardListCheckBox = List<bool>.filled(cardListCheckBox.length, value);

      // Ensure at least one item remains unselected
      if (value) {
        cardListCheckBox[cardListCheckBox.length - 1] = false;
      }
    });
  }

  /// Handle individual checkbox changes
  void _onItemCheck(int index, bool? value) {
    setState(() {
      if (value == true &&
          cardListCheckBox.where((isChecked) => isChecked).length ==
              cardListCheckBox.length - 1) {
        // Prevent the last unchecked item from being checked
        Utils.showFlutterToast("At least one card must remain unselected.");
        return;
      }
      cardListCheckBox[index] = value ?? false;

      // Update "Select All" status
      // isAllCheck = cardListCheckBox.where((isChecked) => isChecked).length ==
      //     cardListCheckBox.length - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(
        theme: theme,
        text: "Your Card List ",
      ),
      body: GetBuilder<HomeController>(builder: (homecontroller) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              Visibility(
                visible: cardListCheckBox.isEmpty
                    ? false
                    : cardListCheckBox.length != 1
                        ? true
                        : false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Select All"),
                    Checkbox.adaptive(
                      value: isAllCheck,
                      onChanged: (value) {
                        if (value != null) {
                          _toggleSelectAll(value);
                        }
                      },
                      activeColor: DynamicColor.yellowClr,
                      checkColor: Colors.white,
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: homecontroller.transactionData.length,
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, index) {
                      final transactionData =
                          homecontroller.transactionData[index];
                      final Map<String, dynamic> decode =
                          jsonDecode(transactionData.cardDetails.toString());

                      return Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  print("sasd");
                                  // Get.toNamed(Routes.confirmationEventScreen);
                                },
                                child: CreditCardWidget(
                                  isSwipeGestureEnabled: false,
                                  cardNumber:
                                      "${transactionData.first4digit!} 0000 0000 ${transactionData.last4digit!}",
                                  expiryDate:
                                      "${decode["exp_month"].toString().length == 1 ? ("0${decode["exp_month"]}") : decode["exp_month"].toString()}/${decode["exp_year"].toString().substring(2)}",
                                  cardHolderName:
                                      transactionData.cardholderName!,
                                  cvvCode: "",
                                  showBackView: false,
                                  onCreditCardWidgetChange: (p0) {},
                                  cardType: transactionData.brand == "visa"
                                      ? CardType.visa
                                      : null,
                                  isHolderNameVisible: true,
                                )),
                          ),
                          if (cardListCheckBox.isNotEmpty)
                            Visibility(
                              visible: isAllCheck,
                              child: Checkbox(
                                value: cardListCheckBox[index],
                                onChanged: (bool? value) {
                                  _onItemCheck(index, value);
                                },
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                activeColor: DynamicColor.yellowClr,
                                checkColor: Colors.white,
                              ),
                            ),
                        ],
                      );
                    }),
              ),
            ],
          ),
        );
      }),
      bottomNavigationBar: cardListCheckBox.any((isSelected) => isSelected)
          ? Container(
              margin: EdgeInsets.all(8.0),
              child: CustomButton(
                borderClr: Colors.transparent,
                onTap: () {
                  // _controller.deleteCard(dataa)
                },
                text: "Delete",
              ),
            )
          : null,
    );
  }
}
