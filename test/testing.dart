import "package:flutter/material.dart";
import "package:flutter/gestures.dart";

class MultiTouchGestureRecognizer extends MultiTapGestureRecognizer {
  late MultiTouchGestureRecognizerCallback onMultiTap;
  var numberOfTouches = 0;
  int minNumberOfTouches = 0;

  MultiTouchGestureRecognizer() {
    super.onTapDown = (pointer, details) => addTouch(pointer, details);
    super.onTapUp = (pointer, details) => removeTouch(pointer, details);
    super.onTapCancel = (pointer) => cancelTouch(pointer);
    super.onTap = (pointer) => captureDefaultTap(pointer);
  }

  void addTouch(int pointer, TapDownDetails details) {
    numberOfTouches++;
  }

  void removeTouch(int pointer, TapUpDetails details) {
    if (numberOfTouches == minNumberOfTouches) {
      onMultiTap(true);
    } else if (numberOfTouches != 0) {
      onMultiTap(false);
    }
    numberOfTouches = 0;
  }

  void cancelTouch(int pointer) {
    numberOfTouches = 0;
  }

  void captureDefaultTap(int pointer) {}

  @override
  set onTapDown(onTapDown) {}

  @override
  set onTapUp(onTapUp) {}

  @override
  set onTapCancel(onTapCancel) {}

  @override
  set onTap(onTap) {}
}

class MultiTapButton extends StatelessWidget {
  final MultiTapButtonCallback onTapCallback;
  final int minTouches;
  final Widget? widget;

  const MultiTapButton({super.key, 
    required this.minTouches,
    required this.onTapCallback,
    this.widget,
  });

  void onTap(bool correctNumberOfTouches) {
    print("${"Tapped with $correctNumberOfTouches"} finger(s)");
    onTapCallback(correctNumberOfTouches);
  }

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(gestures: {
      MultiTouchGestureRecognizer:
          GestureRecognizerFactoryWithHandlers<MultiTouchGestureRecognizer>(
        () => MultiTouchGestureRecognizer(),
        (MultiTouchGestureRecognizer instance) {
          instance.minNumberOfTouches = minTouches;
          instance.onMultiTap =
              (correctNumberOfTouches) => onTap(correctNumberOfTouches);
        },
      ),
    }, child: widget);
  }
}

typedef MultiTapButtonCallback = void Function(bool correctNumberOfTouches);

typedef MultiTouchGestureRecognizerCallback = void Function(
    bool correctNumberOfTouches);
