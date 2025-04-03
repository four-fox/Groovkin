import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/switchWidget.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/GroovkinUser/spotify_music_genre_screen.dart';

class LinkYourAccountSurveyScreen extends StatelessWidget {
  LinkYourAccountSurveyScreen({super.key});

  RxBool iTuneVal = false.obs;
  RxBool spotifyVal = false.obs;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme, text: "Lifestyle Survey"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 15,
              ),
              Text(
                "Music Preferences",
                style: poppinsRegularStyle(
                  fontSize: 16,
                  context: context,
                  color: theme.primaryColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Groovkin wants to know more about the\ntype of music you enjoy!',
                  textAlign: TextAlign.center,
                  style: poppinsRegularStyle(
                    fontSize: 12,
                    context: context,
                    color: DynamicColor.lightRedClr,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              if (Platform.isIOS && API().sp.read("socialType") == "apple")
                SwitchWiget(
                  text: "Link your iTunes account",
                  theme: theme,
                  context: context,
                  showCheckBox: false,
                  bgClr: true,
                ),
              const SizedBox(
                height: 23,
              ),
              if (Platform.isAndroid &&
                  API().sp.read("socialType") == "spotify")
                SwitchWiget(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const SpotifyMusicGenreScreen();
                    }));
                  },
                  text: "Link your Spotify account",
                  theme: theme,
                  context: context,
                  img: "assets/spotifyIcon.png",
                  showCheckBox: false,
                  bgClr: true,
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                borderClr: Colors.transparent,
                onTap: () {
                  Get.toNamed(Routes.quickSurveyScreen, arguments: {
                    'addMoreService': 1,
                    "createEvent": false,
                    "title": "Quick Survey"
                  });
                },
                // text: "Enter manually",
                text: "Enter manually",
              ),

              // CustomButton(
              //   borderClr: Colors.transparent,
              //   onTap: () {
              //     Get.offAllNamed(
              //       Routes.userBottomNavigationNav,
              //       // arguments: {
              //       //   "indexValue": 0
              //       // }
              //     );
              //   },
              //   text: "Next",
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
