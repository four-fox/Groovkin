import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/RecommendedForUserModel.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/eventsNearByMeUserModel.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/topRatedEventUserModel.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/userHistory/userPastEventHistory.dart';
import 'package:groovkin/View/GroovkinUser/UserBottomView/userOngoingEventsModel.dart';
import 'package:groovkin/View/bottomNavigation/homeTabs/eventHistoryModel.dart';
import 'package:dio/dio.dart' as form;
import 'package:groovkin/model/analytic_list_model.dart';
import 'package:groovkin/model/analytic_model.dart';
import 'package:groovkin/model/transaction_history_model.dart'
    as transaction_history_model;
import 'package:groovkin/utils/utils.dart';

import '../../model/my_groovkin_model.dart';

class HomeController extends GetxController {
  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> home functionality
  RxBool showFilter = false.obs;
  RxInt selectedFilter = 0.obs;
  RxInt? showIndexValue = 0.obs;
  RxString? eventStatus = "Completed".obs;

  ///history have selection of cancel & complete
  historyStatus() async {
    switch (selectedFilter.value) {
      case 3:
        eventStatus!.value = "Completed";
        break;
      case 4:
        eventStatus!.value = "Cancelled";
        break;
    }
    update();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> git completed events
  RxBool completedEventLoader = true.obs;
  EventHistoryModel? eventHistory;
  completedEvent() async {
    completedEventLoader(false);
    var response = await API().getApi(url: "history-events", queryParameters: {
      "filter": (showIndexValue == 1 && (selectedFilter == 0))
          ? "recent"
          : (showIndexValue == 1 && (selectedFilter == 1))
              ? "past_week"
              : "older_than_1_month",
    });
    if (response.statusCode == 200) {
      eventHistory = EventHistoryModel.fromJson(response.data);
      completedEventLoader(true);
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>> todo user Home functionality
  ///>>>>>>>>>>>>>>>>>>>> get recommended api for you
  RecommendedEventsModel? recommendedEventData;
  RxBool getRecommendedLoader = true.obs;
  bool newsFeedWait = false;

  getRecommended({fullUrl, String url = 'recommended-for-you-events'}) async {
    getRecommendedLoader(false);
    var response = await API().getApi(url: url, fullUrl: fullUrl);
    if (response.statusCode == 200) {
      if (fullUrl == null) {
        recommendedEventData = RecommendedEventsModel.fromJson(response.data);
      } else {
        recommendedEventData!.data!.data!
            .addAll(RecommendedEventsModel.fromJson(response.data).data!.data!);
        recommendedEventData!.data!.nextPageUrl =
            RecommendedEventsModel.fromJson(response.data).data!.nextPageUrl;
        newsFeedWait = false;
      }
      getRecommendedLoader(true);
      update();
    }
  }

  /// >>>>>>>>>>>>>>>>>>>>> get event near by me
  NearByEventsModel? eventNearByMe;
  RxBool getEventNearByMeLoader = true.obs;
  getEventNearByMe() async {
    getEventNearByMeLoader(false);
    var response = await API().getApi(url: "near-by-events");
    if (response.statusCode == 200) {
      eventNearByMe = NearByEventsModel.fromJson(response.data);
      getEventNearByMeLoader(true);
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>> get top rated events
  TopRatedEventModel? topRatingData;
  RxBool getTopRatedEventLoader = true.obs;
  getTopRatedEvent() async {
    getTopRatedEventLoader(false);
    var response = await API().getApi(url: "top-rated-events");
    if (response.statusCode == 200) {
      topRatingData = TopRatedEventModel.fromJson(response.data);
      getTopRatedEventLoader(true);
      update();
    }
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo get user history functionality
  RxBool getUserHistoryLoader = true.obs;
  UserPastEventHistoryModel? userPastHistory;
  userPastEventHistory({fullUrl}) async {
    getUserHistoryLoader(false);
    recommendedEventData = null;
    var response = await API().getApi(url: "past-events", fullUrl: fullUrl);
    if (response.statusCode == 200) {
      if (fullUrl == null) {
        userPastHistory = UserPastEventHistoryModel.fromJson(response.data);
      }

      getUserHistoryLoader(true);
      update();
    }
  }

  /// cancelled events in user history
  RxBool cancelEventUserHistoryLoader = true.obs;
  cancelEventUserHistory() async {
    cancelEventUserHistoryLoader(false);
    var response = await API().getApi(
      url: "cancelled-events",
    );
    if (response.statusCode == 200) {
      recommendedEventData = RecommendedEventsModel.fromJson(response.data);
      cancelEventUserHistoryLoader(true);
      update();
    }
  }

  ///get all ongoing event user side
  UserOngoingEventModel? userOngoing;
  RxBool userOngoingLoader = true.obs;
  getOngoingEventUser() async {
    userOngoingLoader(false);
    var response = await API().getApi(url: "user-interested-on-going-list");
    if (response.statusCode == 200) {
      userOngoing = UserOngoingEventModel.fromJson(response.data);
      userOngoingLoader(true);
      update();
    }
  }

  /// get my all event

  getMyAllEvent({fullUrl, title}) async {
    getRecommendedLoader(false);
    // recommendedEventData = null;
    print(title);
    var response = title == "drafts"
        ? await API().getApi(url: "save-draft-list", fullUrl: fullUrl)
        : await API().getApi(url: "my-events", fullUrl: fullUrl);
    if (response.statusCode == 200) {
      if (fullUrl == null) {
        recommendedEventData = RecommendedEventsModel.fromJson(response.data);
      } else {
        recommendedEventData!.data!.data!
            .addAll(RecommendedEventsModel.fromJson(response.data).data!.data!);
        recommendedEventData!.data!.nextPageUrl =
            RecommendedEventsModel.fromJson(response.data).data!.nextPageUrl;
      }
      getRecommendedLoader(true);
      update();
    }
  }

  // Todo Get All Cards

  List<transaction_history_model.Data> transactionData = [];

  Future getAllCards() async {
    var response = await API().getApi(url: "cards");
    if (response.statusCode == 200) {
      final responseData =
          transaction_history_model.CardModel.fromJson(response.data);
      transactionData.clear();
      for (var data in responseData.data!) {
        transactionData.add(data);
        update();
      }
    }
  }

  String cardNumber = "";
  String cardHolderName = '';

  String cvvCode = '';
  String expiryDate = '';

  // Todo Add Cards

  addCard(String cardHolderName, String number, String expiryMonth,
      String expiryYear, String cvc) async {
    try {
      final formData = form.FormData.fromMap({
        "cardholder_name": cardHolderName,
        "number": number,
        "exp_month": expiryMonth,
        "exp_year": "20$expiryYear",
        "cvc": cvc,
      });

      var response = await API().postApi(formData, "add-card");
      if (response.statusCode == 200) {
        Utils.showFlutterToast("Your Card Has Been Added!");
        Get.back();
      }
    } catch (e) {
      print("Exception $e");
      rethrow;
    }
  }

  // Todo Delete Card
  Future<void> deleteCard(String cardId) async {
    try {
      final formData = form.FormData.fromMap({
        "card_id": cardId,
      });

      var response = await API().postApi(formData, "delete-card");
      if (response.statusCode == 200) {
        Utils.showFlutterToast("Your Card Has Been Deleted!");
      }
    } catch (e) {
      rethrow;
    }
  }

  // Todo Get Transaction History

  RxBool isGetTransactionHistory = false.obs;
  bool notificationWait = false;

  Future<void> getTransactionHistory({fullUrl, url}) async {
    isGetTransactionHistory.value = true;
    final reponse = await API().getApi(fullUrl: fullUrl, url: url);
    if (reponse.statusCode == 200) {
      if (fullUrl == null) {
      } else {}
    }
    isGetTransactionHistory.value = true;
    update();
  }

  MyGroovkinModel? myGroovkinModel;

  Future<void> getMyGroovkinData() async {
    final response = await API().getApi(url: "my-groovkin");
    if (response.statusCode == 200) {
      myGroovkinModel = MyGroovkinModel.fromJson(response.data);
    }
    update();
  }

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> todo user Home functionality

  ///>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Analytics

  AnalyticsModel? analyticsModel;
  RxInt? pointIndex = 0.obs;

  Future<void> getAllAnalyticsData() async {
    final response = await API().getApi(url: "show-analytics-chart");
    if (response.statusCode == 200) {
      analyticsModel = AnalyticsModel.fromJson(response.data);
    }
    update();
  }

  AnalyticsListModel? analyticsListModel;

  Future<void> getAllAnalyticsListData() async {
    final response = await API().getApi(url: "show-analytics-list");
    if (response.statusCode == 200) {
      analyticsListModel = AnalyticsListModel.fromJson(response.data);
    }
    update();
  }
}

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
