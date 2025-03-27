import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isHandlingRedirect = false;
  Future<bool> _clearCookies() async {
    final cookieManager = WebViewCookieManager();
    return await cookieManager.clearCookies();
  }

  @override
  void initState() {
    super.initState();
    _clearCookies();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        // NavigationDelegate(
        //   onPageStarted: (String url) {
        //     if (url.startsWith(widget.redirectUri)) {
        //       _handleRedirect(url);
        //     }
        //   },
        // ),
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() => _isLoading = true);
            if (url.startsWith(widget.redirectUri)) {
              _handleRedirect(url);
            }
          },
          onPageFinished: (url) {
            setState(() => _isLoading = false);
          },
          onNavigationRequest: (request) {
            if (request.url.startsWith(widget.redirectUri)) {
              if (!_isHandlingRedirect) {
                _isHandlingRedirect = true;
                // Small delay to ensure proper handling on iOS
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
          "scope=user-read-email,user-library-read",
        ),
      );
    });
  }

  void _handleRedirect(String url) async {
    final Uri uri = Uri.parse(url);
    final String? code = uri.queryParameters["code"];

    if (code != null) {
      await _exchangeCodeForToken(code);
      Get.back(); // Close WebView after successful login
    }
  }

  Future<void> _exchangeCodeForToken(String code) async {
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
      log("Access Token: $accessToken");
      // 🔹 Fetch User Profile (to get email)
      await _fetchUserProfile(accessToken);
    } else {
      print("Error getting access token: ${response.body}");
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
      String email = userData["email"];

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
