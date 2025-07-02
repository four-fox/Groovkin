import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/paymentMethod/subscriptionController.dart';
import 'package:groovkin/View/paymentMethod/subscription_screen_two.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final isFromSettingScreen = Get.arguments?["isFromSettingScreen"] ?? false;

  late SubscriptionController subscriptionController;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<SubscriptionController>()) {
      subscriptionController = Get.find<SubscriptionController>();
    } else {
      subscriptionController = Get.put(SubscriptionController());
    }
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await subscriptionController.getSubscription();
    // });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GetBuilder<SubscriptionController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          centerTitle: true,
          title: Text(
            "Groovkin Subscription",
            style: poppinsMediumStyle(
              fontSize: 17,
              context: context,
              color: theme.primaryColor,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (!isFromSettingScreen) ...[
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.serviceScreen,
                            arguments: {"addMoreService": 1});
                        // Get.offAllNamed(Routes.welComeScreen);
                      },
                      child: Container(
                        height: 33,
                        width: 80,
                        // padding: EdgeInsets.symmetric(horizontal: 8,vertical: 10),
                        decoration: BoxDecoration(
                          color: DynamicColor.lightBlackClr.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            "Skip",
                            style: poppinsRegularStyle(
                                fontSize: 12,
                                context: context,
                                color: DynamicColor.whiteClr),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                  borderClr: Colors.transparent,
                  widths: 260,
                  heights: 52,
                  text: "Premium Subscription",
                  style: poppinsMediumStyle(
                    fontSize: 17,
                    context: context,
                    fontWeight: FontWeight.w700,
                    color: theme.primaryColor,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 90,
                  width: 95,
                  child: Image(
                    image: AssetImage("assets/subscribe.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: DynamicColor.darkGrayClr.withOpacity(0.7),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      GradientText(
                        'Groovkin Subscription',
                        style: poppinsMediumStyle(
                            fontSize: 19.0, context: context),
                        colors: [
                          const Color(0xffd6a331).withOpacity(0.5),
                          const Color(0xffd6a331),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      customRow(context: context, theme: theme),
                      const SizedBox(
                        height: 15,
                      ),
                      customRow(
                          text: "Tofu kogi meggings, kale chips.",
                          context: context,
                          theme: theme),
                      const SizedBox(
                        height: 15,
                      ),
                      customRow(
                          text: "Irony copper mug taxidermy.",
                          context: context,
                          theme: theme),
                      const SizedBox(
                        height: 15,
                      ),
                      customRow(
                          text: "Squid cold-pressed occupy taiyaki.",
                          context: context,
                          theme: theme),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // controller.subscriptionModel == null ||
                //         controller.subscriptionModel!.data == null ||
                //         controller.subscriptionModel!.data!.isEmpty
                //     ? const SizedBox()
                //     : Row(
                //         children:
                //             controller.subscriptionModel!.data!.map((data) {
                //           return Expanded(
                //             child: GestureDetector(
                //               onTap: () {
                //                 // Get.toNamed(Routes.paymentMethodScreen,
                //                 //     arguments: {"paymentMethod": 1});
                //               },
                //               child: Container(
                //                 // height: context.height * .20,
                //                 margin: const EdgeInsets.only(right: 10),
                //                 // width: double.infinity,
                //                 // height: 160,
                //                 padding: const EdgeInsets.only(
                //                     top: 20, bottom: 20, left: 13),
                //                 decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(15),
                //                     color: const Color(0xffd9a733)),
                //                 child: Column(
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: [
                //                     SizedBox(
                //                       width: 150,
                //                       child: Text(
                //                         '${data.subcriptionName!.capitalize} \$${data.subcriptionPrice} /${data.subcriptionSubType!.capitalize}',
                //                         style: poppinsMediumStyle(
                //                           fontSize: 18,
                //                           context: context,
                //                           color: theme.primaryColor,
                //                         ),
                //                         maxLines: 2,
                //                         overflow: TextOverflow.ellipsis,
                //                       ),
                //                     ),
                //                     const SizedBox(
                //                       height: 8,
                //                     ),
                //                     Text(
                //                       data.subcriptionDescription ?? "",
                //                       style: poppinsRegularStyle(
                //                         fontSize: 13,
                //                         context: context,
                //                         color: theme.scaffoldBackgroundColor,
                //                       ),
                //                       maxLines: 3,
                //                       softWrap: true,
                //                       overflow: TextOverflow.ellipsis,
                //                     ),
                //                   ],
                //                 ),
                //               ),
                //             ),
                //           );
                //         }).toList(),
                //       ),
                // const SizedBox(
                //   height: 20,
                // ),
                // Padding(
                //   padding:
                //       const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                //   child: CustomButton(
                //     borderClr: Colors.transparent,
                //     color1: DynamicColor.blackClr,
                //     color2: DynamicColor.blackClr,
                //     onTap: () {
                //       // Get.toNamed(Routes.paymentMethodScreen,
                //       //     arguments: {
                //       //       "paymentMethod":1
                //       //     }
                //       // );
                //     },
                //     style: poppinsMediumStyle(
                //       fontSize: 18,
                //       fontWeight: FontWeight.w600,
                //       color: theme.primaryColor,
                //     ),
                //     text: "Buy Subscription",
                //   ),
                // ),
                const SubscriptionScreenTwo(),
                const SizedBox(
                  height: 5,
                ),
                if (!isFromSettingScreen)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                    child: CustomButton(
                      borderClr: Colors.transparent,
                      color1: DynamicColor.blackClr,
                      color2: DynamicColor.blackClr,
                      onTap: () {
                        Get.toNamed(Routes.serviceScreen,
                            arguments: {"addMoreService": 1});
                        // Get.toNamed(Routes.paymentMethodScreen,
                        //     arguments: {
                        //       "paymentMethod":1
                        //     }
                        // );
                      },
                      style: poppinsMediumStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: theme.primaryColor,
                      ),
                      text: "Continue without premium",
                    ),
                  ),
                // SizedBox(
                //   height: 20,
                // ),
                // Text(
                //   'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s',
                //   maxLines: 2,
                //   textAlign: TextAlign.center,
                //   style: poppinsMediumStyle(
                //     fontSize: 13,
                //     color: theme.primaryColor,
                //   ),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget customRow({text, context, color, theme}) {
    return Row(
      children: [
        const Image(
          image: AssetImage("assets/star.png"),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          text ?? 'Biodiesel mumble irony literally.',
          style: poppinsRegularStyle(
            context: context,
            fontSize: 15,
            color: DynamicColor.whiteClr.withOpacity(0.6),
          ),
        )
      ],
    );
  }
}
