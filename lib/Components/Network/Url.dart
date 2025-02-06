class Url {
  static final Url _singleton = Url._internal();

  factory Url() => _singleton;

  Url._internal();

  /// Live Server URL
  // String baseUrl = 'http://192.168.5.251/just_like_me/api/';
  // String socketUrl = 'ws://192.168.5.251:8071/safetypoint';
  // String imageUrl = 'http://192.168.5.251/safety-point/public/';

  ///Development Server
  String baseUrl = 'https://groovkin.gologonow.app/api/';
  String socketUrl = 'http://45.85.146.219:9012';
  String imageUrl = 'https://groovkin.gologonow.app/';
}
