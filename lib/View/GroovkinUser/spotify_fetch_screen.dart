import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/authView/autController.dart';

class SpotifyFetchScreen extends StatefulWidget {
  const SpotifyFetchScreen({super.key});

  @override
  State<SpotifyFetchScreen> createState() => _SpotifyFetchScreenState();
}

class _SpotifyFetchScreenState extends State<SpotifyFetchScreen> {
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
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await _authController.getSpecificArtistGenre();
      });
    }, builder: (controller) {
      return Scaffold(
          appBar: customAppBar(theme: theme, text: "Spotify Genre"),
          body: controller.isSpecificArtistLoading.value == true
              ? const SizedBox()
              : controller.getSpecificArtistGenreModel!.data!.data!.isEmpty
                  ? Center(
                      child: Text(
                        "No Data Found",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    )
                  : NotificationListener(
                      onNotification: (ScrollNotification notification) {
                        if (notification.metrics.pixels ==
                            notification.metrics.maxScrollExtent) {
                          if (controller.getSpecificArtistGenreModel!.data!
                                  .nextPageUrl !=
                              null) {
                            controller.getSpecificArtistGenre(
                                fullUrl: controller.getSpecificArtistGenreModel!
                                    .data!.nextPageUrl);
                            return true;
                          }
                        }
                        return false;
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            final data = controller
                                .getSpecificArtistGenreModel!.data!.data!;
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                // image: DecorationImage(
                                //     image: AssetImage("assets/buttonBg.png"),
                                //     fit: BoxFit.fill
                                // ),
                                color: DynamicColor.secondaryClr,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    data[index].itemName ?? "",
                                    style: poppinsMediumStyle(
                                      fontSize: 16,
                                      context: context,
                                      color: theme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          itemCount: controller
                              .getSpecificArtistGenreModel!.data!.data!.length,
                        ),
                      ),
                    ));
    });
  }
}
