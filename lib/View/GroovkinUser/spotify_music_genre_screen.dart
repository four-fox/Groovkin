import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

import '../authView/autController.dart';

class SpotifyMusicGenreScreen extends StatefulWidget {
  const SpotifyMusicGenreScreen({super.key});

  @override
  State<SpotifyMusicGenreScreen> createState() =>
      _SpotifyMusicGenreScreenState();
}

class _SpotifyMusicGenreScreenState extends State<SpotifyMusicGenreScreen> {
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<AuthController>()) {
      _authController = Get.find<AuthController>();
    } else {
      _authController = Get.put(AuthController());
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return GetBuilder<AuthController>(initState: (state) async {
      await _authController.getSpotifyMusicGenreAPI();
    }, builder: (controller) {
      final Set<String> uniqueGenres = {};
      final filteredGenres = controller.spotifyMusicGenre!.results!.where(
        (genre) {
          return uniqueGenres.add(
            genre.primaryGenreName!,
          );
        },
      ).toList();

      return controller.isSpotify.value == true
          ? const SizedBox.shrink()
          : Scaffold(
              appBar: customAppBar(theme: theme, text: "Quick Survey"),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Text(
                        'Music Genre',
                        textAlign: TextAlign.center,
                        style: poppinsRegularStyle(
                          fontSize: 16,
                          context: context,
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                    Text(
                      'Please select from given option.',
                      style: poppinsRegularStyle(
                        fontSize: 12,
                        context: context,
                        color: DynamicColor.lightRedClr,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                        child: SizedBox(
                      height: Get.height / 1.41,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ListView.separated(
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 4.0,
                          ),
                          itemCount: filteredGenres.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                      // image: DecorationImage(
                                      //     image: AssetImage("assets/buttonBg.png"),
                                      //     fit: BoxFit.fill
                                      // ),
                                      color: DynamicColor.secondaryClr,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Text(
                                        filteredGenres[index].primaryGenreName!,
                                        style: poppinsMediumStyle(
                                          fontSize: 16,
                                          context: context,
                                          color: theme.primaryColor,
                                        ),
                                      ),
                                      const Spacer(),
                                      // GestureDetector(
                                      //   onTap: () {},
                                      //   child: Icon(
                                      //     Icons.keyboard_arrow_down,
                                      //     size: 30,
                                      //     color: theme.primaryColor,
                                      //   ),
                                      // )
                                      Checkbox(
                                        activeColor: DynamicColor.whiteClr,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        value: filteredGenres[index]
                                            .selectedItem!
                                            .value,
                                        onChanged: (value) {
                                          filteredGenres[index]
                                              .selectedItem!
                                              .value = value!;
                                          controller.update();
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    )),
                  ],
                ),
              ),
              bottomNavigationBar: SafeArea(
                  child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: CustomButton(
                  borderClr: Colors.transparent,
                  onTap: () {
                    bool isAnySelected = controller.spotifyMusicGenre!.results!
                        .any((genre) => genre.selectedItem!.value);
                    if (isAnySelected) {
                      Get.offAllNamed(
                        Routes.userBottomNavigationNav,
                        // arguments: {
                        //   "indexValue": 0
                        // }
                      );
                    } else {
                      bottomToast(
                          text:
                              "Please select at least one genre before proceeding");
                    }
                  },
                  text: "Next",
                ),
              )),
            );
    });
  }
}
