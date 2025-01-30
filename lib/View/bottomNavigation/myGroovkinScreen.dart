import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/Url.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinUser/survey/surveyModel.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';
import 'package:groovkin/model/my_groovkin_model.dart' as groovkinModel;

class MyGroovkinScreen extends StatefulWidget {
  MyGroovkinScreen({super.key, this.appBar});

  bool? appBar = false;

  @override
  State<MyGroovkinScreen> createState() => _MyGroovkinScreenState();
}

class _MyGroovkinScreenState extends State<MyGroovkinScreen> {
  late HomeController _homeController;
  late AuthController _authController;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<HomeController>()) {
      _homeController = Get.find<HomeController>();
    } else {
      _homeController = Get.put(HomeController());
    }
    if (Get.isRegistered<AuthController>()) {
      _authController = Get.find<AuthController>();
    } else {
      _authController = Get.put(AuthController());
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GetBuilder<HomeController>(initState: (state) {
      _homeController.getMyGroovkinData();
    }, builder: (controller) {
      groovkinModel.Data? data = controller.myGroovkinModel?.data;
      return data == null
          ? SizedBox()
          : Scaffold(
              appBar: widget.appBar == true
                  ? null
                  : customAppBar(
                      theme: theme,
                      text: "My Groovkin",
                      backArrow: false,
                    ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    if (data.services.isNotEmpty)
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                        color: DynamicColor.avatarBgClr.withOpacity(0.44),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Given Services",
                              style: poppinsRegularStyle(
                                  fontSize: 16,
                                  color: DynamicColor.lightRedClr),
                            ),
                            widget.appBar == true
                                ? SizedBox.shrink()
                                : GestureDetector(
                                    onTap: () {
                                      Get.toNamed(Routes.serviceScreen,
                                          arguments: {
                                            "addMoreService": 2,
                                            "isComingFromMyGroovkin": true,
                                            "isService": data.services
                                          });
                                    },
                                    child: Icon(Icons.edit,
                                        color: DynamicColor.yellowClr),
                                  )
                          ],
                        ),
                      ),
                    ...data.services.map((data) {
                      return serviceWidget(
                        context: context,
                        theme: theme,
                        text: data.eventItem.name.toString(),
                        image: Url().imageUrl + data.eventItem.image.toString(),
                        isNetworkImage:
                            data.eventItem.image?.isNotEmpty ?? false,
                      );
                    }),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                      color: DynamicColor.avatarBgClr.withOpacity(0.44),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Insurance",
                            style: poppinsRegularStyle(
                                fontSize: 16, color: DynamicColor.lightRedClr),
                          ),
                          widget.appBar == true
                              ? SizedBox.shrink()
                              : GestureDetector(
                                  onTap: () {
                                    _authController.insuranceVal.value =
                                        data.isInsurance == 0 ? 0 : 1;
                                    Get.toNamed(Routes.insuranceScreen,
                                        arguments: {
                                          "insuranceNavigation": 2,
                                          "isFromGroovkin": true
                                        });
                                  },
                                  child: Icon(Icons.edit,
                                      color: DynamicColor.yellowClr),
                                )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: serviceWidget(
                          context: context,
                          theme: theme,
                          text: data.isInsurance == 0
                              ? "Insurance cannot be provided"
                              : "Insurance can be provided",
                          image: "assets/insurance.png"),
                    ),
                    if (data.hardwareProvides.isNotEmpty)
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                        color: DynamicColor.avatarBgClr.withOpacity(0.44),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Hardware",
                              style: poppinsRegularStyle(
                                  fontSize: 16,
                                  color: DynamicColor.lightRedClr),
                            ),
                            widget.appBar == true
                                ? SizedBox.shrink()
                                : GestureDetector(
                                    onTap: () {
                                      Get.toNamed(Routes.hardwareScreen,
                                          arguments: {
                                            "createEvent": false,
                                            "isFromGroovkin": true,
                                            "isHardware": data.hardwareProvides
                                          });
                                    },
                                    child: Icon(Icons.edit,
                                        color: DynamicColor.yellowClr),
                                  )
                          ],
                        ),
                      ),
                    if (data.hardwareProvides.isNotEmpty)
                      ListView.builder(
                          itemCount: data.hardwareProvides.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context, index) {
                            final hardwareData = data.hardwareProvides[index];
                            return Padding(
                              padding: EdgeInsets.only(left: 12.0, top: 6),
                              child: Row(
                                children: [
                                  Image(
                                    image: hardwareData.eventItem.image != null
                                        ? NetworkImage(Url().imageUrl +
                                            hardwareData.eventItem.image!)
                                        : AssetImage("assets/djing.png")
                                            as ImageProvider,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3.0),
                                    child: Text(
                                      hardwareData.eventItem.name,
                                      style: poppinsRegularStyle(
                                          fontSize: 13,
                                          color: theme.primaryColor,
                                          context: context),
                                    ),
                                  ),
                                  Icon(
                                    Icons.check,
                                    color: DynamicColor.lightRedClr,
                                    size: 17,
                                  )
                                ],
                              ),
                            );
                          }),
                    SizedBox(
                      height: 10,
                    ),
                    if (data.musicGenre.isNotEmpty)
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                        color: DynamicColor.avatarBgClr.withOpacity(0.44),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Music Genre",
                              style: poppinsRegularStyle(
                                  fontSize: 16,
                                  color: DynamicColor.lightRedClr),
                            ),
                            widget.appBar == true
                                ? SizedBox.shrink()
                                : GestureDetector(
                                    onTap: () {
                                      Get.toNamed(Routes.quickSurveyScreen,
                                          arguments: {"addMoreService": 2});
                                    },
                                    child: Icon(Icons.edit,
                                        color: DynamicColor.yellowClr),
                                  )
                          ],
                        ),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    // if (data.musicGenre.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                data.musicGenre[index].eventItem.name,
                                style: poppinsRegularStyle(
                                    fontSize: 16,
                                    color: DynamicColor.lightRedClr),
                              ),
                            ),
                            SizedBox(
                              height: 70,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: data.musicGenre[index].eventItem
                                          .categoryItems.length ??
                                      0,
                                  itemBuilder: (context, index2) {
                                    return musicGenre(
                                        theme: theme,
                                        context: context,
                                        title: data.musicGenre[index].eventItem
                                            .categoryItems[index2].name);
                                  }),
                            ),
                          ],
                        );
                      },
                      itemCount: data.musicGenre.isNotEmpty
                          ? data.musicGenre.length
                          : 0,
                    ),
                    SizedBox(
                      height: kToolbarHeight * 1.5,
                    ),
                  ],
                ),
              ),
            );
    });
  }

  Widget serviceWidget(
      {theme,
      image,
      context,
      onChanged,
      djValue,
      text,
      bool? isNetworkImage = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        children: [
          CircleAvatar(
              radius: 15,
              backgroundColor: DynamicColor.avatarBgClr.withOpacity(0.8),
              child: ImageIcon(
                isNetworkImage != null && isNetworkImage == true
                    ? NetworkImage(image)
                    : AssetImage(image ?? "assets/djing.png") as ImageProvider,
                size: 20,
              )),
          SizedBox(
            width: 5,
          ),
          Text(
            text ?? "DJing",
            style: poppinsMediumStyle(
              fontSize: 14,
              context: context,
              color: theme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  musicGenre({
    theme,
    context,
    String? title,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 6),
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                image: AssetImage('assets/venue1.png'),
                fit: BoxFit.fill,
                colorFilter: ColorFilter.mode(
                  DynamicColor.grayClr.withOpacity(0.3),
                  BlendMode.modulate,
                ))),
        child: Center(
          child: Text(
            title ?? "60's\nRock",
            textAlign: TextAlign.center,
            style: poppinsMediumStyle(
              fontSize: 10,
              color: theme.primaryColor,
              context: context,
            ),
          ),
        ),
      ),
    );
  }

  // String getImageWithServiceName(String name) {
  //   switch (name) {
  //     case "Lighting":
  //       return "assets/lighting.png";
  //     case "Master of Ceremony":
  //       return "assets/master.png";
  //     case "DJing":
  //       return "assets/djing.png";
  //     case "Photobooth":
  //       return "assets/photobooth.png";
  //     case "AV Equipment":
  //       return "assets/avequipment.png";
  //     default:
  //       return "assets/djing.png";
  //   }
  // }
}
