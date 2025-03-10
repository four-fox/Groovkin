// ignore_for_file: prefer_const_literals_to_create_immutables


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class GroupScreen extends StatelessWidget {
  const GroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
        appBar: customAppBar(
          backArrow: false,
          theme: theme,
          text: "My Groups",
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniEndDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton(
            mini: true,
            backgroundColor: DynamicColor.lightWhite,
            onPressed: () {
              Get.toNamed(Routes.createNewGroup);
            },
            child: Icon(
              Icons.add,
              color: theme.primaryColor,
            ),
          ),
        ),
        body: ListView.builder(itemBuilder: (BuildContext context, index) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Get.toNamed(Routes.theSquadScreen);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage("assets/profileImg.png"),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          "The Squad",
                          style: poppinsRegularStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            context: context,
                            color: theme.primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(
                    thickness: 0.5,
                    color: DynamicColor.grayClr,
                  )
                ],
              ),
            ),
          );
        }));
  }
}

class CreateNewGroup extends StatelessWidget {
  CreateNewGroup({super.key});
  RxBool selectAllValue = false.obs;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(
        theme: theme,
        text: "Create new group",
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            SearchTextFields(
              controller: TextEditingController(),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: DynamicColor.grayClr.withOpacity(0.6),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor: Colors.white,
                    ),
                    child: Obx(
                      () => Checkbox(
                          activeColor: DynamicColor.lightRedClr,
                          value: selectAllValue.value,
                          onChanged: (v) {
                            selectAllValue.value = v!;
                            if (v == true) {
                              for (var element in list) {
                                element.value = true;
                              }
                            } else {
                              for (var element in list) {
                                element.value = false;
                              }
                            }
                          }),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 6.0),
                  child: Text(
                    "Select All",
                    style: poppinsRegularStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      context: context,
                      color: theme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SizedBox(
                height: Get.height / 1.3,
                child: ListView.builder(
                    itemCount: list.length,
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, index) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Get.toNamed(Routes.createNewGroup);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 12),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        AssetImage("assets/profileImg.png"),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "The Squad",
                                      style: poppinsRegularStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        context: context,
                                        color: theme.primaryColor,
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  CircleAvatar(
                                    radius: 17,
                                    backgroundColor:
                                        DynamicColor.grayClr.withOpacity(0.6),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        unselectedWidgetColor: Colors.white,
                                      ),
                                      child: Obx(
                                        () => Checkbox(
                                            activeColor:
                                                DynamicColor.lightRedClr,
                                            value: list[index].value,
                                            onChanged: (v) {
                                              list[index].value = v;
                                            }),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Divider(
                                thickness: 1.2,
                                color: DynamicColor.grayClr,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: CustomButton(
            borderClr: Colors.transparent,
            onTap: () {
              Get.toNamed(Routes.viewCreatedGroup);
            },
            text: "Next",
          ),
        ),
      ),
    );
  }

  List list = [
    false.obs,
    false.obs,
    false.obs,
    false.obs,
    false.obs,
    false.obs,
    false.obs,
    false.obs,
    false.obs,
    false.obs,
    false.obs,
    false.obs,
    false.obs,
    false.obs,
    false.obs,
  ];
}

class ViewCreatedGroup extends StatelessWidget {
  const ViewCreatedGroup({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/grayClor.png"), fit: BoxFit.fill)),
        ),
        title: Text(
          "New group",
          style: poppinsMediumStyle(
            fontSize: 17,
            color: theme.primaryColor,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: ImageIcon(
            AssetImage("assets/backArrow.png"),
            color: theme.primaryColor,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 18),
            child: SizedBox(
              height: kToolbarHeight,
              width: 60,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundImage: AssetImage("assets/profileImg.png"),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      radius: 13,
                      backgroundColor: DynamicColor.avatarBgClr,
                      child: Icon(
                        Icons.add,
                        color: theme.primaryColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: TextFormField(
              style: poppinsRegularStyle(
                  fontSize: 12, color: DynamicColor.grayClr),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: DynamicColor.grayClr),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      BorderSide(color: DynamicColor.grayClr), //<-- SEE HERE
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      BorderSide(color: DynamicColor.grayClr), //<-- SEE HERE
                ),
                hintText: "title",
                contentPadding: EdgeInsets.only(left: 12, top: 12),
                hintStyle: poppinsRegularStyle(
                    fontSize: 12, color: DynamicColor.grayClr),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 12.0, top: 8),
            child: Text(
              "Participants 3  ",
              style: poppinsRegularStyle(
                  fontSize: 13, color: theme.primaryColor.withOpacity(0.5)),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: 10,
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, index) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Get.toNamed(Routes.createNewGroup);
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage:
                                AssetImage("assets/profileImg.png"),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text(
                              "The Squad",
                              style: poppinsRegularStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                context: context,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                          Spacer(),
                          CircleAvatar(
                              radius: 15,
                              backgroundColor:
                                  DynamicColor.grayClr.withOpacity(0.4),
                              child: Icon(
                                Icons.clear,
                                size: 20,
                                color: theme.primaryColor.withOpacity(0.7),
                              ))
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        bottom: true ,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: CustomButton(
            borderClr: Colors.transparent,
            onTap: () {
              Get.offAllNamed(Routes.userBottomNavigationNav);
              // Get.toNamed(Routes.inviteFriendsInGroups);
            },
            text: "Create group",
          ),
        ),
      ),
    );
  }
}
