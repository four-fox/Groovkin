import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:groovkin/View/spotify_login_view.dart';
import 'package:groovkin/utils/constant.dart';

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
  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      children: [
        if (widget.showApple)
          if (Platform.isIOS)
            CustomButtonWithIcon(
                onTap: () {
                  controller.appleSignIn();
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
                controller.googleSignIn();
              },
              text: "Continue with Google",
              iconValue: true,
              bgColor: Colors.transparent,
              gradientClr: true,
              color2: DynamicColor.grayClr.withOpacity(0.4),
              color1: DynamicColor.grayClr.withOpacity(0.1),
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
          CustomButtonWithIcon(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SpotifyWebView(
                              clientId: clientId,
                              clientSecret: clientSecret,
                              redirectUri: redirectUri,
                            )));

                // loginWithSpotify();
              },
              text: "Continue with Spotify",
              iconValue: true,
              bgColor: Colors.transparent,
              gradientClr: true,
              color2: DynamicColor.grayClr.withOpacity(0.4),
              color1: DynamicColor.grayClr.withOpacity(0.1),
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
