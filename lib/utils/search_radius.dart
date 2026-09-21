import 'json_parsers.dart';

const List<int> kDefaultSearchRadiiMiles = [10, 25, 50, 100, 300];
const String kNearbyThisWeekLabel = 'Nearby This Week';

List<int> parseAllowedSearchRadii(dynamic value) {
  final parsed =
      parseIntList(value).where((miles) => miles > 0).toSet().toList()..sort();
  if (parsed.isEmpty) return List<int>.from(kDefaultSearchRadiiMiles);
  return parsed;
}

int sanitizeSearchRadius(dynamic value, {List<int>? allowed}) {
  final options =
      (allowed == null || allowed.isEmpty) ? kDefaultSearchRadiiMiles : allowed;
  final parsed = parseInt(value);
  if (parsed != null && options.contains(parsed)) return parsed;
  if (options.contains(25)) return 25;
  return options.first;
}
