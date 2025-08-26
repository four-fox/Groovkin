import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/View/GroovkinManager/managerController.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';

Future<bool?> showBottomSelectedCardSheet(BuildContext context) async {
  final result = await showModalBottomSheet(
      isScrollControlled: true,
      // backgroundColor: Colors.transparent,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Showselectedbottomsheetcard();
      });
  return result ?? false;
}

class Showselectedbottomsheetcard extends StatefulWidget {
  const Showselectedbottomsheetcard({super.key});

  @override
  State<Showselectedbottomsheetcard> createState() =>
      _ShowselectedbottomsheetcardState();
}

class _ShowselectedbottomsheetcardState
    extends State<Showselectedbottomsheetcard> {
  late HomeController _homeController;
  late ManagerController _managerController;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<HomeController>()) {
      _homeController = Get.find<HomeController>();
    } else {
      _homeController = Get.put(HomeController());
    }

    if (Get.isRegistered<ManagerController>()) {
      _managerController = Get.find<ManagerController>();
    } else {
      _managerController = Get.put(ManagerController());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // color: DynamicColor.blackClr,
        image: const DecorationImage(
            image: AssetImage("assets/grayClor.png"), fit: BoxFit.fill),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: GetBuilder<HomeController>(initState: (state) {
        // _homeController.getAllCards();
      }, builder: (controller) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // small drag indicator
            Container(
              width: 50,
              height: 5,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: DynamicColor.yellowClr,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            // heading
            Text(
              "Select Card",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            GetBuilder<ManagerController>(builder: (managerController) {
              return Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.transactionData.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final data = controller.transactionData[index];
                    return Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: managerController.selectedCardId == data.id
                                ? DynamicColor.yellowClr
                                : Colors.grey,
                            width: 1.5),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${data.first4digit} **** **** ${data.last4digit}",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          Radio<int>.adaptive(
                            value: data.id!,
                            groupValue: managerController.selectedCardId,
                            activeColor: DynamicColor.yellowClr,
                            onChanged: (value) {
                              managerController.selectedCardId = value;
                              managerController.update();
                              // ✅ close bottom sheet and return true
                              Navigator.pop(context, true);
                            },
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        );
      }),
    );
  }
}
