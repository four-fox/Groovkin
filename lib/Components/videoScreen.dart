


import 'package:better_player_plus/better_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VideoPlayerClass extends StatefulWidget {
  const VideoPlayerClass({super.key});

  @override
  State<VideoPlayerClass> createState() => _VideoPlayerClassState();
}

class _VideoPlayerClassState extends State<VideoPlayerClass> {
  String url = Get.arguments["url"];
  String type = Get.arguments["type"];
  late BetterPlayerController betterPlayerController;

  betterPlayerConfig() {
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        type == "file"
            ? BetterPlayerDataSourceType.file
            : BetterPlayerDataSourceType.network,
        url);
    betterPlayerController = BetterPlayerController(const BetterPlayerConfiguration(
      autoDetectFullscreenDeviceOrientation: true,
    ));

    betterPlayerController.setupDataSource(dataSource);
    betterPlayerController.setOverriddenAspectRatio(0.58);
    betterPlayerController.setOverriddenFit(BoxFit.contain);

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    betterPlayerConfig();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BetterPlayer(
        controller: betterPlayerController,
      ),
    );
  }
}
