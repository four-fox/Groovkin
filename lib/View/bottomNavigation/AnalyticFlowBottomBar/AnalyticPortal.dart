

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class AnalyticPortalScreen extends StatelessWidget {
AnalyticPortalScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme,text: "Groovkin Analytics Portal",backArrow: false),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              SizedBox(
                height: 8,
              ),
Text("Discover your next event",
style: poppinsMediumStyle(fontSize: 16,fontWeight: FontWeight.w600,color: theme.primaryColor,),
),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: DynamicColor.avatarBgClr
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search_rounded,
                      color: theme.primaryColor,
                      ),
                        border: InputBorder.none,
                      hintText: "Search",
                      suffixIcon: GestureDetector(
                        onTap: (){
                          Get.toNamed(Routes.analyticFilterScreen);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: DynamicColor.grayClr.withOpacity(0.6),
                            ),
                            child: Icon(Icons.filter_alt,
                            color: theme.primaryColor,
                              size: 18,
                            ),
                          ),
                        ),
                      )
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Get.height/1.38,
                child: ListView.builder(
                    itemCount: list.length,
                    shrinkWrap: true,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context,index){
                  return GestureDetector(
                    onTap: (){
                      Get.toNamed(Routes.eventDetailsScreen);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        height: kToolbarHeight*2.3,
                        padding: EdgeInsets.only(left: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage(list[index].img.toString()),
                            fit: BoxFit.fill
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(list[index].subtitle.toString(),
                            style: poppinsRegularStyle(
                              fontSize: 14,
                              context: context,
                              color: theme.primaryColor,
                            ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(list[index].title.toString(),
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
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Analytic> list = [
    Analytic(title: "Top Music Genres",subtitle: "Rock",img: "assets/analytic1.png"),
    Analytic(title: "Top Food Trends",subtitle: "Food Name",img: "assets/analytic2.png"),
    Analytic(title: "Top Sports Trends",subtitle: "Football",img: "assets/analytic1.png"),
    Analytic(title: "Top Food Trends",subtitle: "Food Name",img: "assets/analytic2.png"),
    Analytic(title: "Top Music Genres",subtitle: "Rock",img: "assets/analytic1.png"),
    Analytic(title: "Top Food Trends",subtitle: "Food Name",img: "assets/analytic2.png"),
    Analytic(title: "Top Sports Trends",subtitle: "Football",img: "assets/analytic1.png"),
    Analytic(title: "Top Food Trends",subtitle: "Food Name",img: "assets/analytic2.png"),
  ];
}

class Analytic{
  String? title,subtitle,img;

  Analytic({this.title,this.subtitle,this.img});
}
