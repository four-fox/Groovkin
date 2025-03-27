


import 'package:flutter/material.dart';
import 'package:groovkin/Components/colors.dart';
import 'package:groovkin/Components/textStyle.dart';

class DropDownClass extends StatelessWidget {
  final bool customIcon;
  final String _hint;
  final String? _initialValue;
  final List? _list;
  final InputDecoration? _inputDecoration;
  final Widget? _prefixIcon;
  final Color? _dropDownColor;
  final double? _radius;
  final double? _borderWidth;
  final Color? _borderColor;
  final bool _isPrefixIcon;
  final bool _objectDropDown;
  List get list => _list!;
  final dynamic Function(dynamic)? _listener;

  const DropDownClass({super.key, 
    this.customIcon = false,
    List? list,
    var hint,
    String? initialValue,
    Color? dropDownColor,
    double? radius,
    double? borderWidth,
    Color? borderColor,
    Widget? prefixIcon,
    InputDecoration? inputDecoration,
    bool isPrefixIcon = true,
    bool border = true,
    bool objectDropDown = true,
    dynamic Function(dynamic)? listener,
    dynamic Function(dynamic)? objectListener,
  })  : _list = list,
        _hint = hint,
        _initialValue = initialValue,
        _borderWidth = borderWidth,
        _radius = radius,
        _borderColor = borderColor,
        _inputDecoration = inputDecoration,
        _isPrefixIcon = isPrefixIcon,
        _prefixIcon = prefixIcon,
        _dropDownColor = dropDownColor,
        _listener = listener,
        _objectDropDown = objectDropDown;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: const DecorationImage(
            image: AssetImage("assets/grayClor.png"),
            fit: BoxFit.fill
        ),
      ),
      child: InkWell(
        child: DropdownButtonHideUnderline(
          child: _objectDropDown
              ? DropdownButtonFormField<String>(
            value: _initialValue,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please select any value";
              }
              return null;
            },
            dropdownColor: _dropDownColor ?? DynamicColor.lightBlackClr,
            decoration: _isPrefixIcon == false
                ? _inputDecoration ??
                InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                    border: buildOutlineInputBorder(),
                    enabledBorder: buildOutlineInputBorder(),
                    focusedBorder: buildOutlineInputBorder(),
                    fillColor: Colors.transparent,
                    filled: true)
                : _inputDecoration ??
                InputDecoration(
                    border: buildOutlineInputBorder(),
                    enabledBorder: buildOutlineInputBorder(),
                    focusedBorder: buildOutlineInputBorder(),
                    prefixIcon: _prefixIcon,
                    fillColor: Colors.transparent,
                    filled: true),
            style: poppinsRegularStyle(
              color: const Color(0xff272727),
              fontWeight: FontWeight.w300,
            ),
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: theme.primaryColor,
            ),
            hint: Text(
              _hint,
              style: poppinsRegularStyle(
                  color: DynamicColor.grayClr, fontSize: 15),
            ),
            items: list.map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item,
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w300,
                    )),
              );
            }).toList(),
            onChanged: (value) {
              if (_listener != null) _listener!.call(value);
            },
          )
              : DropdownButtonFormField<dynamic>(
            dropdownColor: _dropDownColor ?? Colors.transparent,
            decoration: _isPrefixIcon == false
                ? const InputDecoration(
                border: InputBorder.none,
                fillColor: Colors.transparent,
                filled: true)
                : InputDecoration(
                border: InputBorder.none,
                prefixIcon: _prefixIcon,
                fillColor: Colors.transparent,
                filled: true),
            style: TextStyle(
              color: theme.primaryColor,
              fontWeight: FontWeight.w300,
            ),
            isExpanded: true,
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black87,
            ),
            hint: Text(
              _hint,
              style:
              TextStyle(color: DynamicColor.yellowClr, fontSize: 15),
            ),
            items: list.map((item) {
              return DropdownMenuItem<dynamic>(
                value: item,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(item.thumbnail),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(item.title,
                        style: TextStyle(
                          color:theme.primaryColor,
                          fontWeight: FontWeight.w300,
                        )),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (_listener != null) _listener!.call(value);
            },
          ),
        ),
      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide(
          color: _borderColor ?? Colors.transparent,
          width: _borderWidth ?? 2),
      borderRadius: BorderRadius.circular(_radius ?? 5),
    );
  }
}