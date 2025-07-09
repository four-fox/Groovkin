import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/utils/constant.dart' as con;
import 'package:http/http.dart' as http;

class SocialSignIn extends StatefulWidget {
  final bool showGoogle, showFacebook, showApple, showSpotify;

  const SocialSignIn({
    super.key,
    this.showApple = true,
    this.showFacebook = true,
    this.showGoogle = true,
    this.showSpotify = false,
  });

  @override
  State<SocialSignIn> createState() => _SocialSignInState();
}

class _SocialSignInState extends State<SocialSignIn> {
  late final AuthController _authController;
  String? _accessToken;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<AuthController>()) {
      _authController = Get.find();
    } else {
      _authController = Get.put(AuthController());
    }
  }

  Future<void> loginWithSpotify() async {
    const clientId = con.clientId;
    const clientSecret = con.clientSecret;
    const redirectUri = "groovkin://callback";

    final authUrl = Uri.parse(
      'https://accounts.spotify.com/authorize'
      '?client_id=$clientId'
      '&response_type=code'
      '&redirect_uri=$redirectUri'
      '&scope=user-read-email user-top-read user-read-private'
      '&show_dialog=true',
    );

    // final authUrl = Uri.parse('https://appleid.apple.com/auth/authorize?'
    //     'response_type=code&'
    //     'client_id=com.your.bundle.id&' // Your Services ID
    //     'redirect_uri=$redirectUri&'
    //     'scope=music');

    try {
      // Open browser for Spotify login
      final result = await FlutterWebAuth2.authenticate(
        url: authUrl.toString(),
        callbackUrlScheme: 'groovkin',
        options: const FlutterWebAuth2Options(
          useWebview: false,
        ),
      );

      final code = Uri.parse(result).queryParameters['code'];
      // Exchange code for access token
      final response = await http.post(
        Uri.parse("https://accounts.spotify.com/api/token"),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
        },
        body: {
          'grant_type': 'authorization_code',
          'code': code!,
          'redirect_uri': redirectUri,
        },
      );
      final data = json.decode(response.body);
      setState(() {
        _accessToken = data['access_token'];
      });
      await API().sp.write("accessToken", _accessToken);
      if (_accessToken != null) {
        await _fetchUserProfile(_accessToken!);
      }
      print("Spotify Access Token: $_accessToken");
    } catch (e) {
      print('Spotify login error: $e');
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
          signUpPlatform: "spotify", platformId: accessToken);
      log("User Email: $email");
    } else {
      print("Error fetching user profile: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: [
        if (widget.showApple)
          if (Platform.isIOS)
            CustomButtonWithIcon(
                onTap: () {
                  _authController.appleSignIn();
                },
                text: "Continue with Apple",
                iconValue: true,
                bgColor: Colors.transparent,
                gradientClr: true,
                color2: DynamicColor.grayClr.withValues(alpha: 0.4),
                color1: DynamicColor.grayClr.withValues(alpha: 0.1),
                imageIconn: ImageIcon(
                  const AssetImage("assets/apple.png"),
                  color: theme.primaryColor,
                )),
        if (widget.showApple)
          if (Platform.isIOS)
            const SizedBox(
              height: 20,
            ),
        if (widget.showGoogle)
          // if (Platform.isAndroid)
          CustomButtonWithIcon(
              onTap: () {
                _authController.googleSignIn();
              },
              text: "Continue with Google",
              iconValue: true,
              bgColor: Colors.transparent,
              gradientClr: true,
              color2: DynamicColor.grayClr.withValues(alpha:0.4),
              color1: DynamicColor.grayClr.withValues(alpha:0.1),
              imageIconn: ImageIcon(
                const AssetImage("assets/google.png"),
                color: theme.primaryColor,
              )),
        if (widget.showGoogle)
          // if (Platform.isAndroid)
          const SizedBox(
            height: 20,
          ),
        if (widget.showSpotify)
          if (Platform.isAndroid)
            CustomButtonWithIcon(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => const SpotifyWebView(
                  //               clientId: clientId,
                  //               clientSecret: clientSecret,
                  //               redirectUri: redirectUri,
                  //             )));

                  loginWithSpotify();
                },
                text: "Continue with Spotify",
                iconValue: true,
                bgColor: Colors.transparent,
                gradientClr: true,
                color2: DynamicColor.grayClr.withValues(alpha:0.4),
                color1: DynamicColor.grayClr.withValues(alpha:0.1),
                imageIconn: ImageIcon(
                  const AssetImage("assets/spotify.png"),
                  color: theme.primaryColor,
                )),
      ],
    );
  }

  // void loginWithSpotify() async {
  //   const clientId = '06da827311f44e9bbf405f7c9ec676ef';
  //   const redirectUri = 'https://groovkin.gologonow.app';

  //   final authUrl = Uri.parse(
  //     'https://accounts.spotify.com/authorize'
  //     '?client_id=$clientId'
  //     '&response_type=code'
  //     '&redirect_uri=$redirectUri'
  //     '&scope=user-read-email%20user-read-private',
  //   );

  //   // Launch system browser and wait for callback
  //   final result = await FlutterWebAuth2.authenticate(
  //     url: authUrl.toString(),
  //     callbackUrlScheme: "yourapp",
  //   );

  //   final code = Uri.parse(result).queryParameters['code'];
  //   if (code != null) {
  //     Get.back(); // Close WebView after successful login
  //     // Get.toNamed(Routes.createProfile,
  //     //     arguments: {"socialType": "spotify", "accessToken": accessToken});
  //   }
  //   // Exchange code for access token
  //   final response = await http.post(
  //     Uri.parse("https://accounts.spotify.com/api/token"),
  //     headers: {
  //       'Content-Type': 'application/x-www-form-urlencoded',
  //     },
  //     body: {
  //       'grant_type': 'authorization_code',
  //       'code': code!,
  //       'redirect_uri': redirectUri,
  //       'client_id': clientId,
  //       'client_secret': '0c8d111be9174e3f8f74533c14d269cd',
  //     },
  //   );

  //   final data = json.decode(response.body);
  //   final accessToken = data['access_token'];

  //   // Fetch user info
  //   final userInfo = await http.get(
  //     Uri.parse("https://api.spotify.com/v1/me"),
  //     headers: {
  //       'Authorization': 'Bearer $accessToken',
  //     },
  //   );

  //   print(userInfo.body); // Contains email, name, etc.
  // }
}
