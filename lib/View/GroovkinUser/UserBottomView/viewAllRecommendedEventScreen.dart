import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/customEventWidget.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/organizerHomeModel/alleventsModel.dart';
import 'package:groovkin/discovery/discovery_config.dart';
import 'package:groovkin/discovery/discovery_contract.dart';
import 'package:groovkin/discovery/discovery_widgets.dart';
import 'package:groovkin/Components/searchRadiusSelector.dart';
import 'package:intl/intl.dart';

class ViewAllRecommendedScreen extends StatefulWidget {
  const ViewAllRecommendedScreen({super.key});

  @override
  State<ViewAllRecommendedScreen> createState() =>
      _ViewAllRecommendedScreenState();
}

class _ViewAllRecommendedScreenState extends State<ViewAllRecommendedScreen> {
  late HomeController _controller;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<HomeController>()) {
      _controller = Get.find<HomeController>();
    } else {
      _controller = Get.put(HomeController());
    }
  }

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
            final paginator = _controller.recommendedEventData?.data;
            final recommendationFeed = urlText == 'recommended-for-you-events';
            final hasMore = recommendationFeed &&
                    DiscoveryConfig.compileTime.enabled
                ? _controller.hasMoreRecommendations
                : (paginator?.currentPage ?? 0) < (paginator?.lastPage ?? 0);
            if (hasMore) {
              if (_controller.newsFeedWait == false) {
                if (urlText == 'recommended-for-you-events') {
                  _controller.loadNextRecommended();
                } else if (paginator?.nextPageUrl != null) {
                  _controller.newsFeedWait = true;
                  _controller
                      .getRecommended(
                        url: urlText,
                        fullUrl: paginator!.nextPageUrl,
                      )
                      .whenComplete(() => _controller.newsFeedWait = false);
                }
                return true;
              }
            }
            return false;
          }
          return false;
        },
        child: RefreshIndicator(
          onRefresh: () => urlText == 'recommended-for-you-events'
              ? _controller.invalidateRecommendations()
              : _controller.getRecommended(url: urlText),
          child: GetBuilder<HomeController>(initState: (v) {
            _controller.getRecommended(url: urlText);
          }, builder: (controller) {
            final recommendationFeed = urlText == 'recommended-for-you-events';
            final discoveryFeed = recommendationFeed &&
                DiscoveryConfig.compileTime.enabled;
            return Column(
              children: [
                if (discoveryFeed)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SearchRadiusSelector(
                          selected: controller.recommendedRadius,
                          options: controller.allowedSearchRadii,
                          onSelected: controller.setRecommendationRadius,
                        ),
                        if (controller.radiusPendingSave)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              'Showing this radius for now. It was not saved to your profile.',
                              style: poppinsRegularStyle(
                                fontSize: 12,
                                context: context,
                                color: DynamicColor.grayClr,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                Expanded(
                  child: controller.getRecommendedLoader.value == false
                ? discoveryFeed
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink()
                : controller.recommendedEventData!.data!.data!.isEmpty
                    ? discoveryFeed
                        ? DiscoveryFeedNotice(
                            message: controller.discoveryRecommendationNotice ??
                                recommendationEmptyMessage(
                                  locationStatus:
                                      controller.recommendationLocationStatus,
                                  locationDenied: false,
                                ),
                            actionLabel: controller.discoveryRecommendationCanRetry
                                ? 'Try again'
                                : controller.discoveryRecommendationNeedsLocation
                                    ? 'Use my location'
                                    : null,
                            onAction: controller.discoveryRecommendationCanRetry ||
                                    controller.discoveryRecommendationNeedsLocation
                                ? controller.onDiscoveryRecommendationAction
                                : null,
                          )
                        : noData(context: context, theme: theme)
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: DynamicColor.darkGrayClr),
                          child: ListView.builder(
                              itemCount: controller
                                  .recommendedEventData!.data!.data!.length,
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, index) {
                                EventData singleEventData = controller
                                    .recommendedEventData!.data!.data![index];
                                final cardCopy =
                                    DiscoveryCardCopy.fromEvent(singleEventData);
                                final start = singleEventData.startDateTime;
                                return userCustomEvent(
                                    isDelete:
                                        singleEventData.user?.isDelete == null
                                            ? false
                                            : true,
                                    dayy: start == null
                                        ? ''
                                        : DateFormat.MMM().format(start),
                                    datee: start == null
                                        ? ''
                                        : "${start.day}\n",
                                    networkImg:
                                        singleEventData.bannerImage == null
                                            ? false
                                            : true,
                                    img: singleEventData.bannerImage?.mediaPath
                                        .toString(),
                                    title:
                                        singleEventData.eventTitle.toString(),
                                    location: singleEventData.location,
                                    subtitle:
                                        singleEventData.venue?.venueName ?? '',
                                    recommendationText: cardCopy.reasons ??
                                        singleEventData
                                            .recommendation?.displayReason,
                                    badgeText: cardCopy.badge,
                                    distanceText: cardCopy.distance,
                                    onTap: () {
                                      if (API().sp.read("role") == "User") {
                                        Get.toNamed(
                                            Routes.userEventDetailsScreen,
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
                      ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class ViewAllNearByScreen extends StatelessWidget {
  const ViewAllNearByScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ViewAllTopRatingScreen extends StatelessWidget {
  const ViewAllTopRatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
