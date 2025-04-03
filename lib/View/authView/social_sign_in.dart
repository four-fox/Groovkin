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
                color2: DynamicColor.grayClr.withOpacity(0.4),
                color1: DynamicColor.grayClr.withOpacity(0.1),
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
}
