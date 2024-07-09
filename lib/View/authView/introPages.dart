// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/Network/API.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';
import 'package:groovkin/View/authView/autController.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class IntroPages extends StatelessWidget {
  IntroPages({Key? key}) : super(key: key);

  AuthController controller = Get.find();
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                CarouselSlider(
                  carouselController: _controller,
                  options: CarouselOptions(
                    enableInfiniteScroll: false,
                    viewportFraction: 1,
                    height: double.infinity,
                    aspectRatio: 1.0,
                    onPageChanged: (ind, reason) {
                      controller.index = ind;
                      controller.indexValue.value = controller.index;
                      if(ind == 3){
                        API().sp.write("intro", true);
                        Get.offAllNamed(Routes.loginSelection);
                      }
                      },
                    onScrolled: (v) {
                      // controller.indexValue.value = controller.index;
                      // if(v == 2){
                      // API().sp.write("intro", true);
                      //   Get.offAllNamed(Routes.loginSelection);
                      // }
                    },
                  ),
                  items: controller.introduction
                      .map(
                        (item) => Column(

                          children: [
                            SizedBox(
                              height: Get.height/1.9,
                              width: Get.width,
                              child: Image(image: AssetImage(item.image),
                                fit: BoxFit.fill,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            GradientText(
                              item.title,
                              textAlign: TextAlign.start,
                              style: poppinsMediumStyle(context: context, fontSize: 18,fontWeight: FontWeight.w600),
                              colors: [
                                Colors.yellow.withOpacity(0.5),
                                Colors.yellow,
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(        padding: EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text(
                                item.body,
                                textAlign: TextAlign.center,
                                style: poppinsRegularStyle(context: context,
color: DynamicColor.grayClr,
                                fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                  )
                      .toList(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    children: [
                      Spacer(),
                      Obx(
                        ()=> CustomButton(
                          borderClr: Colors.transparent,
                          text: controller.index==2?"Get Started":"Next",
                          onTap:(){
                            print("controller.indexValue.value");
                            print(controller.indexValue.value);
                            _controller.nextPage();
                            if (controller.indexValue.value == 2) {
                              API().sp.write("intro", true);
                              Get.offAllNamed(Routes.loginSelection);
                            }/*else{
        controller.indexValue.value = controller.indexValue.value + 1;
        controller.index = controller.indexValue.value;

      }*/
                          },
                        ),
                      ),
                      Obx(
                        ()=> Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: controller.index==2?SizedBox(
                            height: 21,
                          ):  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  API().sp.write("intro", true);
                                  Get.offAllNamed(Routes.loginSelection);
                                },
                                child: Text('Skip',
                                  style: poppinsRegularStyle(context: context,
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14),
                                ),
                              ),
                              SizedBox(
                                width: 150,
                                child: Obx(
                                      ()=> Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 3,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            color:controller.index==0? DynamicColor.yellowClr:Colors.white
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                        child: Container(
                                          height: 3,
                                          width: 20,
                                          decoration: BoxDecoration(
                                              color:controller.index ==1? DynamicColor.yellowClr:Colors.white
                                          ),
                                        ),
                                      ),Container(
                                        height: 3,
                                        width: 20,
                                        decoration: BoxDecoration(
                                            color:controller.index ==2? DynamicColor.yellowClr:Colors.white
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  if (controller.index == 2) {
                                    API().sp.write("intro", true);
                                    Get.offAllNamed(Routes.loginSelection);
                                  }else{
                                    controller.indexValue.value = controller.indexValue.value + 1;
                                    controller.index = controller.indexValue.value;
                                    _controller.nextPage();
                                  }
                                },
                                child: Text('Next',
                                  style: poppinsRegularStyle(context: context,
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),

              ],
            ),
          ),
    );
  }
}
