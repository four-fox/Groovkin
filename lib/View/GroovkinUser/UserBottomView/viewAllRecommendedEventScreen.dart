import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/customEventWidget.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/organizerHomeModel/alleventsModel.dart';
import 'package:intl/intl.dart';

class ViewAllRecommendedScreen extends StatelessWidget {
  ViewAllRecommendedScreen({Key? key}) : super(key: key);

  HomeController _controller = Get.find();

  String urlText = Get.arguments['urlText'];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    print(urlText);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: Get.arguments['appBarText']),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification.metrics.pixels ==
              scrollNotification.metrics.maxScrollExtent) {
            if (_controller.recommendedEventData!.data!.nextPageUrl != null) {
              if (_controller.newsFeedWait == false) {
                _controller.newsFeedWait = true;
                Future.delayed(Duration(seconds: 2), () {
                  _controller.newsFeedWait = false;
                });
                _controller.getRecommended(
                    fullUrl:
                        _controller.recommendedEventData!.data!.nextPageUrl);
                return true;
              }
            }
            return false;
          }
          return false;
        },
        child: GetBuilder<HomeController>(initState: (v) {
          _controller.getRecommended(url: urlText);
        }, builder: (controller) {
          return controller.getRecommendedLoader.value == false
              ? SizedBox.shrink()
              : controller.recommendedEventData!.data!.data!.isEmpty
                  ? noData(context: context, theme: theme)
                  : Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: DynamicColor.darkGrayClr),
                        child: ListView.builder(
                            itemCount: controller
                                .recommendedEventData!.data!.data!.length,
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, index) {
                              EventData singleEventData = controller
                                  .recommendedEventData!.data!.data![index];
                              return userCustomEvent(
                                  dayy: DateFormat.MMM()
                                      .format(singleEventData.startDateTime!),
                                  datee:
                                      "${singleEventData.startDateTime!.day}\n",
                                  networkImg:
                                      singleEventData.bannerImage == null
                                          ? false
                                          : true,
                                  img: singleEventData.bannerImage == null
                                      ? null
                                      : singleEventData.bannerImage!.mediaPath
                                          .toString(),
                                  title: singleEventData.eventTitle.toString(),
                                  location: singleEventData.location,
                                  subtitle: singleEventData.venue!.venueName
                                      .toString(),
                                  onTap: () {
                                    if (API().sp.read("role") == "User") {
                                      Get.toNamed(Routes.userEventDetailsScreen,
                                          arguments: {
                                            "notify": true,
                                            "notifyBackBtn": true,
                                            'appBarTitle': "Event Preview",
                                            "statusText":
                                                singleEventData.id.toString()
                                          });
                                    } else {
                                      Get.toNamed(Routes.upcomingScreen,
                                          arguments: {
                                            "eventId": singleEventData.id,
                                            "reportedEventView": 1,
                                            "notInterestedBtn": 1,
                                            "appBarTitle":
                                                Get.arguments['appBarText']
                                          });
                                    }
                                  },
                                  context: context,
                                  theme: theme);
                            }),
                      ),
                    );
        }),
      ),
    );
  }
}

class ViewAllNearByScreen extends StatelessWidget {
  const ViewAllNearByScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ViewAllTopRatingScreen extends StatelessWidget {
  const ViewAllTopRatingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
