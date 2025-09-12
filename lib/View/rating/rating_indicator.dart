import 'package:flutter/material.dart';
import 'package:groovkin/Components/colors.dart';

class TRatingIndicator extends StatelessWidget {
  const TRatingIndicator({
    super.key,
    required this.value,
    required this.text,
  });
  final double value;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: Text(text)),
        Expanded(
          flex: 11,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.5,
            child: LinearProgressIndicator(
              minHeight: 10,
              value: value,
              borderRadius: BorderRadius.circular(7),
              valueColor: AlwaysStoppedAnimation(DynamicColor.yellowClr),
            ),
          ),
        ),
      ],
    );
  }
}
