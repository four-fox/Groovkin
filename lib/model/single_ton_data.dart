class AppData {
  bool entitlementIsActive = false;

  static final AppData _appData = AppData._interval();
  factory AppData() {
    return _appData;
  }

  AppData._interval();
}

final appData = AppData();
