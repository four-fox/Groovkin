import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

class ChartData2 {
  final int x;
  final int y;

  ChartData2(this.x, this.y);
}

class AnalyticPortalScreen extends StatefulWidget {
  AnalyticPortalScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticPortalScreen> createState() => _AnalyticPortalScreenState();
}

class _AnalyticPortalScreenState extends State<AnalyticPortalScreen> {
  late HomeController _homeController;
  List<ChartData> data = [];

  List<Map<String, dynamic>> genreData = [];

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<HomeController>()) {
      _homeController = Get.find<HomeController>();
    } else {
      _homeController = Get.put(HomeController());
    }
    _homeController.getAllAnalyticsData().then(
      (value) {
        setState(() {
          data =
              _homeController.analyticsModel!.data!.asMap().entries.map((item) {
            int index = item.key;
            var data = item.value;
            return ChartData(index, data.count!);
          }).toList();
          genreData = _homeController.analyticsModel!.data!.map((data) {
            return {
              "decade": data.genre,
              "count": data.count,
            };
          }).toList();
        });
      },
    );
  }

  List<FlSpot> getChartData() {
    return genreData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value["count"].toDouble());
    }).toList();
  }

  List<BarChartGroupData> getChartData2() {
    return genreData.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value["count"].toDouble(),
            color: Colors.blue,
            width: 20,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  final ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(
    enablePanning: true, // Enable scrolling
    enablePinching: true, // Optional: Allow pinch zoom
    zoomMode: ZoomMode.x, // Scroll only horizontally
  );

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(
          theme: theme, text: "Groovkin Analytics Portal", backArrow: false),
      //   body: Padding(
      //     padding: EdgeInsets.symmetric(horizontal: 12.0),
      //     child: SingleChildScrollView(
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         // ignore: prefer_const_literals_to_create_immutables
      //         children: [
      //           SizedBox(
      //             height: 8,
      //           ),
      //           Text(
      //             "Discover your next event",
      //             style: poppinsMediumStyle(
      //               fontSize: 16,
      //               fontWeight: FontWeight.w600,
      //               color: theme.primaryColor,
      //             ),
      //           ),
      //           Padding(
      //             padding: EdgeInsets.symmetric(vertical: 6.0),
      //             child: Container(
      //               decoration: BoxDecoration(
      //                   borderRadius: BorderRadius.circular(9),
      //                   color: DynamicColor.avatarBgClr),
      //               child: TextField(
      //                 decoration: InputDecoration(
      //                     prefixIcon: Icon(
      //                       Icons.search_rounded,
      //                       color: theme.primaryColor,
      //                     ),
      //                     border: InputBorder.none,
      //                     hintText: "Search",
      //                     suffixIcon: GestureDetector(
      //                       onTap: () {
      //                         Get.toNamed(Routes.analyticFilterScreen);
      //                       },
      //                       child: Padding(
      //                         padding: EdgeInsets.all(10.0),
      //                         child: Container(
      //                           decoration: BoxDecoration(
      //                             borderRadius: BorderRadius.circular(6),
      //                             color: DynamicColor.grayClr.withOpacity(0.6),
      //                           ),
      //                           child: Icon(
      //                             Icons.filter_alt,
      //                             color: theme.primaryColor,
      //                             size: 18,
      //                           ),
      //                         ),
      //                       ),
      //                     )),
      //               ),
      //             ),
      //           ),
      //           SizedBox(
      //             height: Get.height / 1.38,
      //             child: ListView.builder(
      //                 itemCount: list.length,
      //                 shrinkWrap: true,
      //                 physics: AlwaysScrollableScrollPhysics(),
      //                 itemBuilder: (BuildContext context, index) {
      //                   return GestureDetector(
      //                     onTap: () {
      //                       Get.toNamed(Routes.eventDetailsScreen);
      //                     },
      //                     child: Padding(
      //                       padding: EdgeInsets.symmetric(vertical: 8.0),
      //                       child: Container(
      //                         height: kToolbarHeight * 2.3,
      //                         padding: EdgeInsets.only(left: 15),
      //                         decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(10),
      //                           image: DecorationImage(
      //                               image: AssetImage(list[index].img.toString()),
      //                               fit: BoxFit.fill),
      //                         ),
      //                         child: Column(
      //                           mainAxisAlignment: MainAxisAlignment.center,
      //                           crossAxisAlignment: CrossAxisAlignment.start,
      //                           children: [
      //                             Text(
      //                               list[index].subtitle.toString(),
      //                               style: poppinsRegularStyle(
      //                                 fontSize: 14,
      //                                 context: context,
      //                                 color: theme.primaryColor,
      //                               ),
      //                             ),
      //                             SizedBox(
      //                               height: 8,
      //                             ),
      //                             Text(
      //                               list[index].title.toString(),
      //                               style: poppinsRegularStyle(
      //                                 fontSize: 16,
      //                                 context: context,
      //                                 color: theme.primaryColor,
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                     ),
      //                   );
      //                 }),
      //           )
      //         ],
      //       ),
      //     ),
      //   ),
      // );
      // body: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     /// Line Chart (Scrollable)
      //     // SfCartesianChart(
      //     //   title: ChartTitle(text: 'Sales Data'),
      //     //   legend: Legend(isVisible: true),
      //     //   tooltipBehavior: TooltipBehavior(enable: true),
      //     //   primaryXAxis: NumericAxis(title: AxisTitle(text: 'Time (months)')),
      //     //   primaryYAxis:
      //     //       NumericAxis(title: AxisTitle(text: 'Sales (in units)')),
      //     //   series: <LineSeries<ChartData, int>>[
      //     //     LineSeries<ChartData, int>(
      //     //       name: 'Sales',
      //     //       dataSource: data,
      //     //       xValueMapper: (ChartData sales, _) => data.indexOf(sales),
      //     //       yValueMapper: (ChartData sales, _) => sales.y,
      //     //       markerSettings: MarkerSettings(isVisible: true),
      //     //       dataLabelSettings: DataLabelSettings(isVisible: true),
      //     //     ),
      //     //   ],
      //     // ),

      //     // SizedBox(height: 16),

      //     /// Curved Line Chart (Scrollable)
      //     // SizedBox(
      //     //   height: 300,
      //     //   child: Padding(
      //     //     padding: const EdgeInsets.all(16.0),
      //     //     child: LineChart(
      //     //       LineChartData(
      //     //         gridData: FlGridData(show: false),
      //     //         titlesData: FlTitlesData(
      //     //           leftTitles:
      //     //               AxisTitles(sideTitles: SideTitles(showTitles: true)),
      //     //           bottomTitles: AxisTitles(
      //     //             sideTitles: SideTitles(
      //     //               showTitles: true,
      //     //               getTitlesWidget: (value, meta) {
      //     //                 int index = value.toInt();
      //     //                 if (index >= 0 && index < data.length) {
      //     //                   return Text(data[index].x,
      //     //                       style: TextStyle(fontSize: 12));
      //     //                 }
      //     //                 return Container();
      //     //               },
      //     //             ),
      //     //           ),
      //     //         ),
      //     //         borderData: FlBorderData(
      //     //             border: Border.all(color: Colors.black, width: 1)),
      //     //         lineBarsData: [
      //     //           LineChartBarData(
      //     //             spots: getChartData(),
      //     //             isCurved: true,
      //     //             color: Colors.blue,
      //     //             barWidth: 4,
      //     //             belowBarData: BarAreaData(
      //     //                 show: true, color: Colors.blue.withOpacity(0.3)),
      //     //           ),
      //     //         ],
      //     //       ),
      //     //     ),
      //     //   ),
      //     // ),

      //     // SizedBox(height: 16),

      //     /// Horizontal Scrollable Bar Chart

      //     // SizedBox(height: 16),

      //     /// Bar Chart (Scrollable)
      //     // SizedBox(
      //     //   height: 300,
      //     //   child: Padding(
      //     //     padding: const EdgeInsets.all(16.0),
      //     //     child: BarChart(
      //     //       BarChartData(
      //     //         gridData: FlGridData(show: false),
      //     //         titlesData: FlTitlesData(
      //     //           leftTitles:
      //     //               AxisTitles(sideTitles: SideTitles(showTitles: true)),
      //     //           bottomTitles: AxisTitles(
      //     //             sideTitles: SideTitles(
      //     //               showTitles: true,
      //     //               getTitlesWidget: (value, meta) {
      //     //                 int index = value.toInt();
      //     //                 if (index >= 0 && index < data.length) {
      //     //                   return Text(data[index].x,
      //     //                       style: TextStyle(fontSize: 12));
      //     //                 }
      //     //                 return Container();
      //     //               },
      //     //             ),
      //     //           ),
      //     //         ),
      //     //         borderData: FlBorderData(show: true),
      //     //         barGroups: getChartData2(),
      //     //       ),
      //     //     ),
      //     //   ),
      //     // ),
      //   ],
      // ),

      body: Column(
        children: [
          SfCartesianChart(
              borderWidth: 3,
              palette: [DynamicColor.yellowClr],
              zoomPanBehavior: ZoomPanBehavior(
                enablePinching: true,
                enablePanning: true,
                zoomMode: ZoomMode.xy,
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
          Expanded(
            child: SizedBox(
                height: Get.height / 1.38,
                child: ListView.builder(
                    itemCount: list.length,
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, index) {
                      return GestureDetector(
                        onTap: () {
                          // Get.toNamed(Routes.eventDetailsScreen);
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            height: kToolbarHeight * 2.3,
                            padding: EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: AssetImage(list[index].img.toString()),
                                  fit: BoxFit.fill),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  list[index].subtitle.toString(),
                                  style: poppinsRegularStyle(
                                    fontSize: 14,
                                    context: context,
                                    color: theme.primaryColor,
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  list[index].title.toString(),
                                  style: poppinsRegularStyle(
                                    fontSize: 16,
                                    context: context,
                                    color: theme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })),
          ),
        ],
      ),
      // body: SfCartesianChart(
      //     primaryXAxis: NumericAxis(),
      //     zoomPanBehavior: _zoomPanBehavior,
      //     series: <CartesianSeries>[
      //       SplineSeries<ChartData, int>(
      //           dataSource: data,
      //           xValueMapper: (ChartData data, _) => data.x,
      //           yValueMapper: (ChartData data, _) => data.y)
      //     ]),
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

  List<Analytic> list = [
    Analytic(
        title: "Top Music Genres",
        subtitle: "Rock",
        img: "assets/analytic1.png"),
    Analytic(
        title: "Top Food Trends",
        subtitle: "Food Name",
        img: "assets/analytic2.png"),
    Analytic(
        title: "Top Sports Trends",
        subtitle: "Football",
        img: "assets/analytic1.png"),
    Analytic(
        title: "Top Food Trends",
        subtitle: "Food Name",
        img: "assets/analytic2.png"),
    Analytic(
        title: "Top Music Genres",
        subtitle: "Rock",
        img: "assets/analytic1.png"),
    Analytic(
        title: "Top Food Trends",
        subtitle: "Food Name",
        img: "assets/analytic2.png"),
    Analytic(
        title: "Top Sports Trends",
        subtitle: "Football",
        img: "assets/analytic1.png"),
    Analytic(
        title: "Top Food Trends",
        subtitle: "Food Name",
        img: "assets/analytic2.png"),
  ];
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