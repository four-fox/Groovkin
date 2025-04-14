class AppData {
  static final AppData _appData = AppData._interval();

  bool entitlementIsActive = false;
  String appUserID = '';
  
  factory AppData() {
    return _appData;
  }

  AppData._interval();
}

final appData = AppData();
