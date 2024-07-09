


// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groovkin/Components/button.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/grayClrBgAppBar.dart';
import 'package:groovkin/Components/textFields.dart';
import 'package:groovkin/Components/textStyle.dart';
import 'package:groovkin/Routes/app_pages.dart';

class AnalyticFilterScreen extends StatelessWidget {
  const AnalyticFilterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme,text: "Groovkin Analytics Portal"),
    body: Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 12,
            ),
            Text('Music genre',
              style: poppinsMediumStyle(
                  fontSize: 16,
                  context: context,
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w600
              ),
            ),
            Wrap(
              spacing:10,
              children: <Widget>[
                Chip(
                  backgroundColor: DynamicColor.darkGrayClr,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  avatar:
                  Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: theme.primaryColor,
                      ),child: Checkbox(value: false, onChanged: (v){})),
                  label: Text('Rock',
                    style: poppinsRegularStyle(
                        fontSize: 14,
                        context: context,
                        color: DynamicColor.lightWhite
                    ),
                  ),
                ),
                Chip(
                  backgroundColor: DynamicColor.darkGrayClr,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  avatar:
                  Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: theme.primaryColor,
                      ),child: Checkbox(value: false, onChanged: (v){})),
                  label: Text('Pop music',
                    style: poppinsRegularStyle(
                        fontSize: 14,
                        context: context,
                        color: DynamicColor.lightWhite
                    ),),
                ),
                Chip(
                  backgroundColor: DynamicColor.darkGrayClr,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  avatar:
                  Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: theme.primaryColor,
                      ),child: Checkbox(value: false, onChanged: (v){})),
                  label: Text('Popular music',
                    style: poppinsRegularStyle(
                        fontSize: 14,
                        context: context,
                        color: DynamicColor.lightWhite
                    ),),
                ),
              ],
            ),
            Text('Food Type',
              style: poppinsMediumStyle(
                  fontSize: 16,
                  context: context,
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w600
              ),
            ),
            Wrap(
              spacing:10,
              children: <Widget>[
                Chip(
                  backgroundColor: DynamicColor.darkGrayClr,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  avatar:
                  Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: theme.primaryColor,
                      ),child: Checkbox(value: false, onChanged: (v){})),
                  label: Text('Hamilton',
                  style: poppinsRegularStyle(
                    fontSize: 14,
                    context: context,
                      color: DynamicColor.lightWhite
                  ),
                  ),
                ),
                Chip(
                  backgroundColor: DynamicColor.darkGrayClr,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  avatar:
                  Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: theme.primaryColor,
                      ),child: Checkbox(value: false, onChanged: (v){})),
                  label: Text('Pop music',
                    style: poppinsRegularStyle(
                        fontSize: 14,
                        context: context,
                        color: DynamicColor.lightWhite
                    ),),
                ),
                Chip(
                  backgroundColor: DynamicColor.darkGrayClr,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  avatar:
                  Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: theme.primaryColor,
                      ),child: Checkbox(value: false, onChanged: (v){})),
                  label: Text('Popular music',
                    style: poppinsRegularStyle(
                        fontSize: 14,
                        context: context,
                        color: DynamicColor.lightWhite
                    ),),
                ),
                Chip(
                  backgroundColor: DynamicColor.darkGrayClr,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  avatar:
                  Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: theme.primaryColor,
                      ),child: Checkbox(value: false, onChanged: (v){})),
                  label: Text('Hip hop music',
                    style: poppinsRegularStyle(
                        fontSize: 14,
                        context: context,
                        color: DynamicColor.lightWhite
                    ),),
                ),
                Chip(
                  backgroundColor: DynamicColor.darkGrayClr,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  avatar:
                  Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: theme.primaryColor,
                      ),child: Checkbox(value: false, onChanged: (v){})),
                  label: Text('Rhythm and blues',
                    style: poppinsRegularStyle(
                        fontSize: 14,
                        context: context,
                        color: DynamicColor.lightWhite
                    ),),
                ),
              ],
            ),
            Chip(
              backgroundColor: DynamicColor.darkGrayClr,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              label: Text('See more',
                style: poppinsRegularStyle(
                    fontSize: 14,
                    context: context,
                    color: DynamicColor.lightWhite
                ),),
            ),

            SizedBox(
              height: 12,
            ),
            Text('Sport types',
              style: poppinsMediumStyle(
                  fontSize: 16,
                  context: context,
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w600
              ),
            ),
            Wrap(
              spacing:10,
              children: <Widget>[
                Chip(
                  backgroundColor: DynamicColor.darkGrayClr,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  avatar:
                  Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: theme.primaryColor,
                      ),child: Checkbox(value: false, onChanged: (v){})),
                  label: Text('Hockey',
                    style: poppinsRegularStyle(
                        fontSize: 14,
                        context: context,
                        color: DynamicColor.lightWhite
                    ),
                  ),
                ),
                Chip(
                  backgroundColor: DynamicColor.darkGrayClr,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  avatar:
                  Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: theme.primaryColor,
                      ),child: Checkbox(value: false, onChanged: (v){})),
                  label: Text('Golf',
                    style: poppinsRegularStyle(
                        fontSize: 14,
                        context: context,
                        color: DynamicColor.lightWhite
                    ),),
                ),
                Chip(
                  backgroundColor: DynamicColor.darkGrayClr,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  avatar:
                  Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: theme.primaryColor,
                      ),child: Checkbox(value: false, onChanged: (v){})),
                  label: Text('Basket ball',
                    style: poppinsRegularStyle(
                        fontSize: 14,
                        context: context,
                        color: DynamicColor.lightWhite
                    ),),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Text('1-Mile Radius of Selected Zip Codes',
            style: poppinsMediumStyle(
              fontSize: 16,
              context: context,
              color: theme.primaryColor,
              fontWeight: FontWeight.w600
            ),
            ),
            Wrap(
              spacing:10,
              children: <Widget>[
                Chip(
                  backgroundColor: DynamicColor.darkGrayClr,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  avatar:
                  Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: theme.primaryColor,
                      ),child: Checkbox(value: false, onChanged: (v){})),
                  label: Text('#12345',
                    style: poppinsRegularStyle(
                        fontSize: 14,
                        context: context,
                        color: DynamicColor.lightWhite
                    ),
                  ),
                ),
                Chip(
                  backgroundColor: DynamicColor.darkGrayClr,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  avatar:
                  Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: theme.primaryColor,
                      ),child: Checkbox(value: false, onChanged: (v){})),
                  label: Text('#12345',
                    style: poppinsRegularStyle(
                        fontSize: 14,
                        context: context,
                        color: DynamicColor.lightWhite
                    ),),
                ),
                Chip(
                  backgroundColor: DynamicColor.darkGrayClr,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  avatar:
                  Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: theme.primaryColor,
                      ),child: Checkbox(value: false, onChanged: (v){})),
                  label: Text('#12345',
                    style: poppinsRegularStyle(
                        fontSize: 14,
                        context: context,
                        color: DynamicColor.lightWhite
                    ),),
                ),
                Chip(
                  backgroundColor: DynamicColor.darkGrayClr,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  avatar:
                  Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: theme.primaryColor,
                      ),child: Checkbox(value: false, onChanged: (v){})),
                  label: Text('#12345',
                    style: poppinsRegularStyle(
                        fontSize: 14,
                        context: context,
                        color: DynamicColor.lightWhite
                    ),),
                ),
                Chip(
                  backgroundColor: DynamicColor.darkGrayClr,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  avatar:
                  Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor: theme.primaryColor,
                      ),child: Checkbox(value: false, onChanged: (v){})),
                  label: Text('#12345',
                    style: poppinsRegularStyle(
                        fontSize: 14,
                        context: context,
                        color: DynamicColor.lightWhite
                    ),),
                ),
              ],
            ),

            SizedBox(
              height: 12,
            ),
            Text('Zip code',
              style: poppinsMediumStyle(
                  fontSize: 16,
                  context: context,
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w600
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: Get.width/2.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: DynamicColor.lightBlackClr.withOpacity(0.5),
              ),
child: TextField(
  decoration: InputDecoration(
    isDense: true,
    prefixIcon:Padding(
      padding: EdgeInsets.symmetric(horizontal: 7.0),
      child: Text("#",
        style: poppinsRegularStyle(
            fontSize: 16,
            context: context,
            color: theme.primaryColor,
        ),
      ),
    ),
    hintText: "000000",
    prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
  ),
),
            ),
            SizedBox(
              height: 10,
            ),
            Text('Age range',
            style: poppinsMediumStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: theme.primaryColor,
              context: context
            ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: Get.width/2.3,
                  child: CustomTextFields(
                    labelText: "Start range",
                  ),
                ),
                SizedBox(
                  width: Get.width/2.3,
                  child:
                  CustomTextFields(
                    labelText: "End range",
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                color: DynamicColor.lightBlackClr.withOpacity(0.5),
              ),
              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 8),
            child: Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text("Radius in mile",
                        style: poppinsRegularStyle(
                            fontSize: 14,
                            color: theme.primaryColor,
                            context: context
                        ),
                      ),
                      Text("Select Radius",
                        style: poppinsRegularStyle(
                            fontSize: 14,
                            color: theme.primaryColor,
                            context: context
                        ),
                      ),
                    ],
                  ),
Spacer(),
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text("Type here",
                    style: poppinsRegularStyle(
                        fontSize: 11,
                        color: DynamicColor.grayClr.withOpacity(0.9),
                        context: context
                    ),
                  ),
                ),
                Container(
                  width: Get.width/7,
                  // height: 30,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: DynamicColor.whiteClr)
                  ),
                  child: TextField(
                    textAlign: TextAlign.center,
                    style: poppinsRegularStyle(
                        fontSize: 12,
                        color: theme.primaryColor,
                        context: context
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "00",
                      hintStyle: poppinsRegularStyle(
                        fontSize: 12,
                        color: theme.primaryColor,
                        context: context
                    ),
                    ),
                  ),
                )
              ],
            ),
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
        child: CustomButton(
          borderClr: Colors.transparent,
          onTap: (){
            Get.back();
          },
          text: "Apply Filters",
        ),
      ),
    );
  }
}



class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: customAppBar(theme: theme,text: "Groovkin Analytics Portal"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
           Padding(
               padding: const EdgeInsets.symmetric(horizontal: 4.0),
               child: Text("Filter",
                 style: poppinsRegularStyle(
                     fontSize: 14,
                     context: context,
                     color: theme.primaryColor,
                 ),
               ),
           ),
                  GestureDetector(
                    onTap: (){
                      Get.toNamed(Routes.analyticFilterScreen);
                    },
                    child: Container(
                      padding: EdgeInsets.all(3.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: DynamicColor.grayClr.withOpacity(0.6),
                      ),
                      child: Icon(Icons.filter_alt,
                        color: theme.primaryColor,
                        size: 23,
                      ),
                    ),
                  ),
                ],
              ),
            ),SizedBox(height: 10,),
            Container(
              width: Get.width,
              padding: EdgeInsets.symmetric(horizontal: 14,vertical: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: DynamicColor.lightBlackClr.withOpacity(0.6),
              ),
              child: Column(
                children: [
                  Text("Top trend in (5 Zip code/Location)",
                    style: poppinsRegularStyle(
                      fontSize: 16,
                      color: theme.primaryColor,
                      context: context,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  customRow(
                    context: context,
                    theme: theme,
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  Divider(
                    height: 5,
                    color: theme.primaryColor.withOpacity(0.7),
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  customRow(
                    context: context,
                    theme: theme,
                    text: "Rock",
                    value: "60%",
                    textClr: theme.primaryColor.withOpacity(0.6),
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  customRow(
                    context: context,
                    theme: theme,
                    text: "Classical music",
                    value: "30%",
                    textClr: theme.primaryColor.withOpacity(0.6),
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  customRow(
                    context: context,
                    theme: theme,
                    text: "Disco",
                    value: "10%",
                    textClr: theme.primaryColor.withOpacity(0.6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customRow({theme,context,text,value,double? fontSize,Color? textClr}){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text??"Music name",
          style: poppinsMediumStyle(
            fontSize: fontSize??13,
            color:textClr?? theme.primaryColor,
            context: context,
          ),
        ),
        Text(value??"People in percent",
          style: poppinsMediumStyle(
            fontSize: 13,
            color:textClr?? theme.primaryColor,
            context: context,
          ),
        ),
      ],
    );
  }
}
