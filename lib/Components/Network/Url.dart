class Url {
  static final Url _singleton = Url._internal();

  factory Url() => _singleton;

  Url._internal();

  ///Development Server
  String baseUrl = 'https://groovkin.gologonow.app/api/';
  // String socketUrl = 'http://45.85.146.219:9012';
  String socketUrl = 'http://72.62.79.55:9012';
  String imageUrl = 'https://groovkin.gologonow.app/';
}
