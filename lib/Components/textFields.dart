


import 'package:flutter/material.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';


String pattern =
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
    r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
    r"{0,253}[a-zA-Z0-9])?)*$";

class CustomTextFields extends StatelessWidget {
  CustomTextFields({Key? key,this.labelText,this.textClr,this.maxLine = 1,this.keyBoardType = false,
    this.borderClr,
    this.iconShow= false,
    this.onTap,
    this.readOnly = false,
    this.style,
    this.labelStyling,
    this.suffixIcon,
    this.suffixWidget,
    this.controller,
    this.obscureText = false,
    this.validationError,
    this.isEmail = false,
    this.onChanged,
    this.ignoredValidation = false,
  }) : super(key: key);

  String? labelText;
  Color? textClr;
  int? maxLine=1;
  bool keyBoardType = false;
  Color? borderClr;
  bool iconShow = false;
  final GestureTapCallback? onTap;
  bool readOnly = false;
  TextStyle? style;
  TextStyle? labelStyling;
  final IconData? suffixIcon;
  Widget? suffixWidget;
  TextEditingController? controller = TextEditingController();
  bool obscureText = false;
  String? validationError;
  bool? ignoredValidation = false;
  bool? isEmail = false;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLine!,
      style:style?? poppinsRegularStyle(
          context: context,
          fontSize: 14,
          color: textClr??DynamicColor.grayClr
      ),
      readOnly: readOnly,
      obscureText: obscureText,
      onChanged: onChanged,
      keyboardType:keyBoardType==false? TextInputType.text:TextInputType.number,
      decoration: InputDecoration(

        alignLabelWithHint: true,
        suffixIcon:iconShow==true? GestureDetector(
          onTap: onTap,
          child: suffixWidget ?? Icon(suffixIcon??Icons.edit,
          color: DynamicColor.grayClr,
          ),
        ):SizedBox.shrink(),
        labelText: labelText?? "Email",
        labelStyle:labelStyling?? poppinsRegularStyle(
            context: context,
            fontSize: 14,
          color: textClr??DynamicColor.grayClr
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color:borderClr?? DynamicColor.grayClr.withOpacity(0.6)), //<-- SEE HERE
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color:borderClr?? DynamicColor.grayClr.withOpacity(0.6)), //<-- SEE HERE
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color:borderClr?? DynamicColor.grayClr.withOpacity(0.6)), //<-- SEE HERE
        ),
      ),
        validator: (value) {
        if(ignoredValidation == false){
          if (value!.isEmpty) {
            return 'Please enter $validationError';
          } else {
            if(isEmail == true){
              RegExp regex = RegExp(pattern);
              if (!regex.hasMatch(value)) {
                return "Enter a valid email address";
              }
              return null;
            }
          }
        }else{
          return null;
        }

        }
    );
  }

  validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return "Enter a valid email address";
    } else {
      return null;
    }
  }
}


class CustomTextFieldsHintText extends StatelessWidget {
  CustomTextFieldsHintText({Key? key,this.hintText,this.textClr,this.maxLine = 1,this.keyBoardType = false,
    this.borderClr,
    this.bgClr,
    required this.controller,
    this.validation,
  }) : super(key: key);

  String? hintText;
  Color ? textClr;
  int? maxLine=1;
  bool keyBoardType = false;
  Color? borderClr;
  Color? bgClr;
  TextEditingController controller = TextEditingController();
  String? validation;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgClr,
        borderRadius: BorderRadius.circular(8)
      ),
      child: TextFormField(
        maxLines: maxLine!,
        controller: controller,
        style: poppinsRegularStyle(
            context: context,
            fontSize: 14,
            color: textClr??DynamicColor.grayClr
        ),
        keyboardType:keyBoardType==false? TextInputType.text:TextInputType.number,
        validator: (v){
          if(v!.isNotEmpty){
            return null;
          }else{
            return "Please enter $validation";
          }
        },
        decoration: InputDecoration(
          hintText: hintText?? "Email",
          hintStyle: poppinsRegularStyle(
              context: context,
              fontSize: 14,
            color: textClr??DynamicColor.grayClr
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color:borderClr?? DynamicColor.grayClr), //<-- SEE HERE
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color:borderClr?? DynamicColor.grayClr), //<-- SEE HERE
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color:borderClr?? DynamicColor.grayClr), //<-- SEE HERE
          ),
        ),
      ),
    );
  }
}



///search text fields

class SearchTextFields extends StatelessWidget {
  SearchTextFields({Key? key,this.searchIcon = true,this.hintText,
  this.border= false,
    this.onTap,
    this.readOnly = false,
    this.onChanged,
    required this.controller,
  }) : super(key: key);
  bool searchIcon = true;
  String? hintText;
  bool border = false;
  GestureTapCallback? onTap;
  bool readOnly = false;
  final ValueChanged<String>? onChanged;
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: DynamicColor.grayClr.withOpacity(0.6))
      ),
      child: TextFormField(
        onTap: onTap,
        controller: controller,
        onChanged: onChanged,
        style: poppinsRegularStyle(
            fontSize: 12,
            color: DynamicColor.grayClr
        ),
        readOnly: readOnly,
        decoration: InputDecoration(
          border:border==false? InputBorder.none:OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),//<-- SEE HERE
          ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), //<-- SEE HERE
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10), //<-- SEE HERE
            ),
          hintText:hintText?? "Search",
          contentPadding: EdgeInsets.only(left: 12,top: 12),
          hintStyle: poppinsRegularStyle(
            fontSize: 12,
              color: DynamicColor.grayClr
          ),
          suffixIcon:searchIcon==true? Icon(Icons.search,
              color: DynamicColor.grayClr
          ):SizedBox.shrink()
        ),
      ),
    );
  }
}
