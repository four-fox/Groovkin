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
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  final HomeController _controller = Get.find();

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
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CreditCardWidget(
              glassmorphismConfig: Glassmorphism.defaultConfig(),
              // glassmorphismConfig:
              //     useGlassMorphism ? Glassmorphism.defaultConfig() : null,
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
                  color2: DynamicColor.lightWhite.withValues(alpha: 0.5),
                  color1: DynamicColor.lightWhite.withValues(alpha: 0.5),
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
            const SizedBox(
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
            // GetBuilder<HomeController>(builder: (homecontroller) {
            //   return Expanded(
            //     child: ListView.builder(
            //         itemCount: homecontroller.transactionData.length,
            //         itemBuilder: (BuildContext context, index) {
            //           final transactionData =
            //               homecontroller.transactionData[index];
            //           return GestureDetector(
            //             onTap: () {
            //               // Get.toNamed(Routes.confirmationEventScreen);
            //             },
            //             child: Padding(
            //               padding: const EdgeInsets.symmetric(vertical: 4.0),
            //               child: Container(
            //                 padding: const EdgeInsets.symmetric(
            //                     vertical: 4.0, horizontal: 9),
            //                 decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(10),
            //                     color: DynamicColor.darkGrayClr),
            //                 child: Row(
            //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                   children: [
            //                     Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       children: [
            //                         Text(
            //                           "# ${transactionData.customerId}",
            //                           style: poppinsRegularStyle(
            //                               fontSize: 12,
            //                               context: context,
            //                               color: DynamicColor.lightWhite),
            //                           maxLines: 1,
            //                           overflow: TextOverflow.ellipsis,
            //                         ),
            //                         Text(
            //                           transactionData.cardholderName ?? "",
            //                           style: poppinsMediumStyle(
            //                             fontSize: 14,
            //                             context: context,
            //                             color: theme.primaryColor,
            //                           ),
            //                         ),
            //                         Text(
            //                           "${Utils.dateFormat(transactionData.createdAt!)}  ${Utils.timeFormat(transactionData.createdAt!)}",
            //                           style: poppinsRegularStyle(
            //                               fontSize: 12,
            //                               context: context,
            //                               color: DynamicColor.lightWhite),
            //                         ),
            //                       ],
            //                     ),
            //                     Text(
            //                       "\$1000",
            //                       style: poppinsMediumStyle(
            //                         fontSize: 14,
            //                         fontWeight: FontWeight.w700,
            //                         context: context,
            //                         color: theme.primaryColor,
            //                       ),
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           );
            //         }),
            //   );
            // })
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
  final HomeController _controller = Get.find();
  bool isDeleteCard = false;
  bool cardListCheckBox = false;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    _fetchCards();
  }

  Future _fetchCards() async {
    await _controller.getAllCards();
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
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: homecontroller.transactionData.isEmpty
                ? Center(
                    child: Text(
                      "No Card Found!",
                      style: poppinsMediumStyle(
                        fontSize: 16,
                        context: context,
                        color: theme.primaryColor,
                      ),
                    ),
                  )
                : Column(
                    children: [
                      if (_controller.transactionData.isNotEmpty &&
                          _controller.transactionData.length != 1)
                        Material(
                          color: Colors.transparent,
                          child: GestureDetector(
                            onTap: () {
                              if (isDeleteCard == true) {
                                setState(() {
                                  isDeleteCard = false;
                                  selectedIndex = null;
                                });
                              } else {
                                setState(() {
                                  isDeleteCard = true;
                                });
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text("Delete Card"),
                                Checkbox(
                                  value: isDeleteCard,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true) {
                                        isDeleteCard = true;
                                      } else {
                                        isDeleteCard = false;
                                        selectedIndex = null;
                                      }
                                    });
                                  },
                                  checkColor: Colors.white,
                                  activeColor: DynamicColor.yellowClr,
                                )
                              ],
                            ),
                          ),
                        ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: homecontroller.transactionData.length,
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, index) {
                              final transactionData =
                                  homecontroller.transactionData[index];
                              final Map<String, dynamic> decode = jsonDecode(
                                  transactionData.cardDetails.toString());
                              return Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                        onTap: () {
                                          // Get.toNamed(Routes.confirmationEventScreen);
                                        },
                                        child: CreditCardWidget(
                                          glassmorphismConfig:
                                              Glassmorphism.defaultConfig(),
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
                                          cardType:
                                              transactionData.brand == "visa"
                                                  ? CardType.visa
                                                  : null,
                                          isHolderNameVisible: true,
                                        )),
                                  ),
                                  Visibility(
                                    visible:
                                        isDeleteCard, // * if delete all is true then show
                                    child: Checkbox(
                                      value: selectedIndex ==
                                          index, // * Only the selected checkbox will be true
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            selectedIndex =
                                                index; // Set selected checkbox index
                                          } else {
                                            selectedIndex =
                                                null; // Deselect the checkbox
                                          }
                                        });
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
        bottomNavigationBar:
            GetBuilder<HomeController>(builder: (homecontroller) {
          // Show "Delete" button if a card is selected
          if (selectedIndex != null) {
            return SafeArea(
              bottom: true,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                child: CustomButton(
                  borderClr: Colors.transparent,
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierColor: Colors.black.withValues(alpha: 0.7),
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Confirm Deletion"),
                          content: const Text(
                            "Are you sure you want to delete this payment method? This action cannot be undone.",
                          ),
                          actions: [
                            CustomButton(
                              widths: context.width * .25,
                              heights: 40,
                              onTap: () {
                                Get.back();
                              },
                              text: "No",
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomButton(
                              heights: 40,
                              widths: context.width * .25,
                              onTap: () {
                                Get.back();

                                // Get the selected card's ID and perform deletion
                                final int id = homecontroller
                                    .transactionData[selectedIndex!].id!;
                                homecontroller
                                    .deleteCard(id.toString())
                                    .then((value) {
                                  _fetchCards().then((_) {
                                    // Reset state after deletion
                                    setState(() {
                                      selectedIndex = null;
                                      isDeleteCard = false;
                                    });
                                  }); // Refresh the card list after deletion
                                });
                              },
                              text: "Yes",
                            ),
                          ],
                        );
                      },
                    );
                  },
                  text: "Delete",
                ),
              ),
            );
          }
          // Show "Replace" button if there's only one card left and none are selected
          else if (homecontroller.transactionData.length == 1 &&
              selectedIndex == null) {
            return SafeArea(
              bottom: true,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                child: CustomButton(
                  onTap: () {
                    Get.toNamed(Routes.addCardDetails, arguments: {
                      "isFromreplaced": true,
                      "paymentMethod": 2,
                    });
                    // Add functionality for "Replace" if required
                  },
                  text: "Replace",
                ),
              ),
            );
          }
          return const SizedBox();
          // Return null if neither condition is met (no button shown)
        }));
  }
}
