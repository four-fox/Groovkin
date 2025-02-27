import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/View/bottomNavigation/homeController.dart';
import 'package:material_charts/material_charts.dart' as material;
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  final int x;
  final int y;

  ChartData(this.x, this.y);
}

class AnalyticPortalScreen extends StatefulWidget {
  AnalyticPortalScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticPortalScreen> createState() => _AnalyticPortalScreenState();
}

class _AnalyticPortalScreenState extends State<AnalyticPortalScreen> {
  late HomeController _homeController;
  List<ChartData> data = [];
  bool isSubscribe = false;

  String returnTextAccordingToType(String type) {
    switch (type) {
      case "music_genre":
        return "Music";
      case "life_style":
        return "Life Style";
      default:
        return "NAN";
    }
  }

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<HomeController>()) {
      _homeController = Get.find<HomeController>();
    } else {
      _homeController = Get.put(HomeController());
    }
    _homeController.getAllAnalyticsListData();
    _homeController.getAllAnalyticsData().then(
      (value) {
        data.clear();
        setState(() {
          data =
              _homeController.analyticsModel!.data!.asMap().entries.map((item) {
            int index = item.key;
            var data = item.value;
            return ChartData(index, data.count!);
          }).toList();
        });
      },
    );
  }

  List<String> list = [
    "assets/analytic1.png",
    "assets/analytic2.png",
  ];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(
          theme: theme, text: "Groovkin Analytics Portal", backArrow: false),
      body: Stack(
        children: [
          Column(
            children: [
              // Chart
              SfCartesianChart(
                  borderWidth: 3,
                  palette: [DynamicColor.yellowClr],
                  zoomPanBehavior: ZoomPanBehavior(
                    enablePinching: true,
                    enablePanning: true,
                    zoomMode: ZoomMode.xy,
                  ),
                  tooltipBehavior: TooltipBehavior(
                    enable: true,
                    header: "Details",
                    format: "Value: {point.y}", // Customize tooltip text
                  ),
                  primaryXAxis: CategoryAxis(
                    autoScrollingDelta: 8,
                    majorGridLines: MajorGridLines(width: 0),
                    labelIntersectAction: AxisLabelIntersectAction.rotate45,
                    autoScrollingMode: AutoScrollingMode.start,
                    arrangeByIndex:
                        true, // Arrange the categories by index for better scrolling experience
                  ),
                  enableAxisAnimation: true,
                  enableMultiSelection: true,
                  series: <CartesianSeries>[
                    StackedColumnSeries<ChartData, int>(
                      groupName: 'A',
                      dataSource: data,
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        labelAlignment: ChartDataLabelAlignment.top,
                      ),
                      width:
                          0.95, // Increase the width of each bar (default is 0.7)
                      spacing: 0.1,
                    ),
                  ]),

              GetBuilder<HomeController>(builder: (controller) {
                return (controller.analyticsListModel == null ||
                        controller.analyticsListModel!.data == null ||
                        controller.analyticsListModel!.data!.isEmpty)
                    ? Center(
                        child: Text("No Analytic Found!"),
                      )
                    : Expanded(
                        child: SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ListView.builder(
                              itemCount:
                                  controller.analyticsListModel!.data!.length,
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, index) {
                                String randomImage =
                                    (index % 2 == 0) ? list[0] : list[1];

                                final data =
                                    controller.analyticsListModel!.data![index];

                                return GestureDetector(
                                  onTap: () {
                                    // Get.toNamed(Routes.eventDetailsScreen);
                                  },
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: Stack(
                                      children: [
                                        // Background Image with Blur Effect
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 3,
                                                sigmaY: 3), // Blur effect
                                            child: Container(
                                              height: kToolbarHeight * 2.3,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  image:
                                                      AssetImage(randomImage),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        // Content on Top
                                        Container(
                                          height: kToolbarHeight * 2.3,
                                          padding: EdgeInsets.only(left: 15),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.black.withOpacity(
                                                0.4), // Slight dark overlay
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      returnTextAccordingToType(
                                                          data.genre?.type ??
                                                              "NAN"),
                                                      style:
                                                          poppinsRegularStyle(
                                                        fontSize: 14,
                                                        context: context,
                                                        color:
                                                            theme.primaryColor,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      data.genre?.name ??
                                                          "No Name",
                                                      style:
                                                          poppinsRegularStyle(
                                                        fontSize: 16,
                                                        context: context,
                                                        color:
                                                            theme.primaryColor,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    Text(
                                                      "Count ${(data.count ?? 0)}",
                                                      style:
                                                          poppinsRegularStyle(
                                                        fontSize: 16,
                                                        context: context,
                                                        color:
                                                            theme.primaryColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (index == 0 ||
                                                  index == 1 ||
                                                  index == 2)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 15),
                                                  child: Text(
                                                    "# ${index + 1}", // #1, #2, #3
                                                    style: GoogleFonts.bungee(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: DynamicColor
                                                          .yellowClr,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
              }),
            ],
          ),
          if (!isSubscribe) notSubscribeCardWidget(),
        ],
      ),
    );
  }

  final style = material.MultiLineChartStyle(
    backgroundColor: Colors.white,
    colors: [Colors.blue, Colors.green, Colors.red],
    smoothLines: true,
    showPoints: true,
    animation: const material.ChartAnimation(
      duration: Duration(milliseconds: 5000),
    ),
    tooltipStyle: const material.MultiLineTooltipStyle(
      threshold: 20,
    ),
    forceYAxisFromZero: false,
    crosshair: material.CrosshairConfig(
      enabled: true,
      lineColor: Colors.grey.withOpacity(0.5),
    ),
  );

  Widget notSubscribeCardWidget() {
    return PopScope(
      canPop: false,
      child: Stack(
        children: [
          // Blurred Background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.4), // Semi-transparent overlay
            ),
          ),

          // Alert Dialog
          Center(
            child: SizedBox(
              width: context.width * .8,
              child: Card(
                elevation: 15,
                margin: EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "You're not subscribed!",
                        style: GoogleFonts.bungee(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Subscribe to use this feature and unlock premium analytics!",
                        style: GoogleFonts.poppins(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Add subscription logic here
                          setState(() {
                            isSubscribe = true; // Mark as subscribed
                          });
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DynamicColor.yellowClr,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        child: Text(
                          "Subscribe Now",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Analytic {
  String? title, subtitle, img;

  Analytic({this.title, this.subtitle, this.img});
}
    // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   child: Container(
          //     width: Get.width,
          //     child: SfCartesianChart(
          //       primaryXAxis: CategoryAxis(
          //         labelRotation: 45,
          //         arrangeByIndex: true,
          //       ),
          //       primaryYAxis: NumericAxis(),
          //       zoomPanBehavior: _zoomPanBehavior,
          //       series: <CartesianSeries>[
          //         StackedColumnSeries<ChartData, int>(
          //           width: 0.4,
          //           dataSource: data,
          //           xValueMapper: (ChartData data, _) => data.x,
          //           yValueMapper: (ChartData data, _) => data.y,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),