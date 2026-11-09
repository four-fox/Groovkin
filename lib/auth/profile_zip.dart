import 'package:groovkin/View/profile/profileModel.dart';
import 'package:groovkin/utils/json_parsers.dart';

/// Ignores a profile response that belongs to an older login.
class ProfileLoadGate {
  int epoch = 0;
  String? userId;

  void start(String? userId) {
    this.userId = userId;
  }

  int invalidate() {
    userId = null;
    return ++epoch;
  }

  bool accepts({required int epoch, required String? userId}) {
    return epoch == this.epoch &&
        userId != null &&
        userId.isNotEmpty &&
        userId == this.userId;
  }
}

Map<String, dynamic>? userDetailsMap(dynamic payload) {
  final root = parseMap(payload);
  if (root == null) return null;
  final data = parseMap(root['data']);
  return parseMap(data?['user_details']) ??
      parseMap(root['user_details']) ??
      (parseMap(data?['profile']) != null ? data : null) ??
      (parseMap(root['profile']) != null ? root : null);
}

String? zipFromAuthPayload(dynamic payload) {
  final details = userDetailsMap(payload);
  if (details == null) return null;
  final profile = parseMap(details['profile']);
  return parseString(profile?['zip_code'] ?? profile?['zip'] ?? details['zip_code']);
}

/// Builds the profile model the home ZIP reads, when the auth payload
/// actually includes a ZIP. Callers fetch the profile API otherwise.
ProfileModel? profileModelFromAuthPayload(dynamic payload) {
  final details = userDetailsMap(payload);
  final zip = zipFromAuthPayload(payload);
  if (details == null || zip == null || zip.isEmpty) return null;
  return ProfileModel.fromJson({
    'status': true,
    'data': details,
  });
}
