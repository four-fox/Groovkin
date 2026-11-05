class Url {
  static final Url _singleton = Url._internal();

  factory Url() => _singleton;

  Url._internal();

  ///Development Server
  String baseUrl = 'https://groovkin.gologonow.app/api/';
  String socketUrl = 'https://groovkin.gologonow.app';
  String imageUrl = 'https://groovkin.gologonow.app/';
}
