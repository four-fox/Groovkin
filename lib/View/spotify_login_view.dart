import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// 🔹 Separate WebView Screen for Authentication
class SpotifyWebView extends StatefulWidget {
  final String clientId;
  final String clientSecret;
  final String redirectUri;

  const SpotifyWebView({
    super.key,
    required this.clientId,
    required this.clientSecret,
    required this.redirectUri,
  });

  @override
  _SpotifyWebViewState createState() => _SpotifyWebViewState();
}

class _SpotifyWebViewState extends State<SpotifyWebView> {
  late final AuthController _authController;

  late final WebViewController _controller;
  bool _isLoading = true;
  String? accessToken;
  bool _isHandlingRedirect = false;

  Future<bool> _clearCookies() async {
    final cookieManager = WebViewCookieManager();
    return await cookieManager.clearCookies();
  }

  @override
  void initState() {
    super.initState();
    _clearCookies();
    if (Get.isRegistered<AuthController>()) {
      _authController = Get.find();
    } else {
      _authController = Get.put(AuthController());
    }
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) async {
            await _controller.runJavaScript(_hideSocialButtonsScript());
            setState(() => _isLoading = true);
            // Handle social login redirections
          },
          onPageFinished: (url) async {
            setState(() => _isLoading = false);
            await _controller.runJavaScript(_hideSocialButtonsScript());
          },
          onNavigationRequest: (request) {
            if (request.url.startsWith(widget.redirectUri)) {
              if (!_isHandlingRedirect) {
                _isHandlingRedirect = true;
                Future.delayed(const Duration(milliseconds: 300), () {
                  _handleRedirect(request.url);
                });
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    // Load Spotify Login URL
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.loadRequest(
        Uri.parse(
          "https://accounts.spotify.com/authorize?"
          "client_id=${widget.clientId}&"
          "response_type=code&"
          "redirect_uri=${widget.redirectUri}&"
          "scope=user-read-email,user-library-read,user-top-read",
        ),
      );
    });
  }

  String _hideSocialButtonsScript() {
    return """
    (function() {
      // Hide all social login buttons
      let google = document.querySelector('[data-testid="google-login"]');
      let facebook = document.querySelector('[data-testid="facebook-login"]');
      let apple = document.querySelector('[data-testid="apple-login"]');
      let others = document.querySelectorAll('[data-testid="signup-section"]');

      if (google) google.style.display = 'none';
      if (facebook) facebook.style.display = 'none';
      if (apple) apple.style.display = 'none';

      others.forEach(el => el.style.display = 'none');

      // Hide divider text (e.g., "or")
      let orDiv = document.querySelector('[data-testid="or-separator"]');
      if (orDiv) orDiv.style.display = 'none';
    })();
  """;
  }

  void _handleRedirect(String url) async {
    final Uri uri = Uri.parse(url);
    final String? code = uri.queryParameters["code"];

    if (code != null) {
      String? accessToken = await _exchangeCodeForToken(code);
      await _fetchUserProfile(accessToken!);
      Get.back(); // Close WebView after successful login
      // Get.toNamed(Routes.createProfile,
      //     arguments: {"socialType": "spotify", "accessToken": accessToken});
    }
  }

  Future<String?> _exchangeCodeForToken(String code) async {
    final response = await http.post(
      Uri.parse("https://accounts.spotify.com/api/token"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization":
            "Basic ${base64Encode(utf8.encode('${widget.clientId}:${widget.clientSecret}'))}",
      },
      body: {
        "grant_type": "authorization_code",
        "code": code,
        "redirect_uri": widget.redirectUri,
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String accessToken = data["access_token"];
      _authController.accessToken = accessToken;
      API().sp.write("accessToken", accessToken);
      _authController.update();
      setState(() {
        this.accessToken = accessToken;
      });
      log("Access Token: $accessToken");
      return accessToken;

      // 🔹 Fetch User Profile (to get email)
    } else {
      print("Error getting access token: ${response.body}");
      return null;
    }
  }

  Future<void> _fetchUserProfile(String accessToken) async {
    final response = await http.get(
      Uri.parse("https://api.spotify.com/v1/me"),
      headers: {
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200) {
      final userData = jsonDecode(response.body);
      print(userData);
      String email = userData["email"];
      String name = userData["display_name"];
      _authController.emailController.text = email;
      API().sp.write("nameSocial", name);
      API().sp.write("emailSocial", email);
      _authController.sigUp(context,
          signUpPlatform: "spotify", platformId: this.accessToken);

      log("User Email: $email");
    } else {
      print("Error fetching user profile: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Spotify Login",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xff121212),
        // elevation: 0.0,
        // scrolledUnderElevation: 0.0,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
