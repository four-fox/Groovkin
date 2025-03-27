import 'package:flutter/material.dart';

class ShrinkOnTap extends StatefulWidget {
  final Widget child;
  const ShrinkOnTap({super.key, required this.child});

  @override
  _ShrinkOnTapState createState() => _ShrinkOnTapState();
}

class _ShrinkOnTapState extends State<ShrinkOnTap> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isTapped = true),
      onTapUp: (_) => setState(() => _isTapped = false),
      onTapCancel: () => setState(() => _isTapped = false),
      child: AnimatedScale(
        scale: _isTapped ? 0.90 : 1.0,
        duration: const Duration(milliseconds: 20),
        child: widget.child,
      ),
    );
  }
}
