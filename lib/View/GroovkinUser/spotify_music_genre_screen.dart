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
    return AndroidSpotifyWidget(authController: _authController, theme: theme);
  }
}

class AndroidSpotifyWidget extends StatefulWidget {
  const AndroidSpotifyWidget({
    super.key,
    required AuthController authController,
    required this.theme,
  }) : _authController = authController;

  final AuthController _authController;
  final ThemeData theme;

  @override
  State<AndroidSpotifyWidget> createState() => _AndroidSpotifyWidgetState();
}

class _AndroidSpotifyWidgetState extends State<AndroidSpotifyWidget> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(initState: (state) async {
      await widget._authController.getSpotifyArtistGenre();
    }, builder: (controller) {
      return controller.isArtistLoading.value == true
          ? const SizedBox.shrink()
          : Scaffold(
              appBar: customAppBar(theme: widget.theme, text: "Quick Survey"),
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
                          color: widget.theme.primaryColor,
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
                      child: widget._authController.filteredGenres.isEmpty
                          ? Center(
                              child: Text(
                                "No Data Found",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: ListView.separated(
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 10,
                                  );
                                },
                                itemCount: widget
                                    ._authController.filteredGenres.length,
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              widget._authController
                                                      .filteredGenres[index]
                                                  ["name"]!,
                                              style: poppinsMediumStyle(
                                                fontSize: 16,
                                                context: context,
                                                color:
                                                    widget.theme.primaryColor,
                                              ),
                                            ),
                                            const Spacer(),
                                            // GestureDetector(
                                            //   onTap: () {},
                                            //   child: Icon(
                                            //     Icons.keyboard_arrow_down,
                                            //     size: 30,
                                            //     color:
                                            //         widget.theme.primaryColor,
                                            //   ),
                                            // ),
                                            Checkbox(
                                              activeColor:
                                                  DynamicColor.whiteClr,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              value: widget
                                                  ._authController
                                                  .filteredGenres[index]
                                                      ["selected"]!
                                                  .value,
                                              onChanged: (value) {
                                                widget
                                                    ._authController
                                                    .filteredGenres[index]
                                                        ["selected"]!
                                                    .value = value!;
                                                controller.update();
                                              },
                                            ),
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
                    if (widget._authController.filteredGenres.isNotEmpty) {
                      bool isAnySelected = widget._authController.filteredGenres
                          .any((genre) => genre["selected"]!.value);
                      if (isAnySelected) {
                        controller.addSpotifyArtistGenre();
                      } else {
                        bottomToast(
                            text:
                                "Please select at least one genre before proceeding");
                      }
                    } else {
                      bottomToast(text: "No Data Found!");
                    }
                  },
                  text: "Next",
                ),
              )),
            );
    });
  }
}
