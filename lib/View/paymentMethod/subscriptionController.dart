import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/model/subscription_model.dart';

class SubscriptionController extends GetxController {
  SubscriptionModel? subscriptionModel;

  // Get Subscription
  Future<void> getSubscription() async {
    final response = await API().getApi(url: "subscription-list");
    if (response.statusCode == 200) {
      subscriptionModel = SubscriptionModel.fromJson(response.data);
    }
    update();
  }
}
