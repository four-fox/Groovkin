import 'package:flutter/material.dart';

class PayWalls extends StatefulWidget {
  const PayWalls({super.key});

  @override
  State<PayWalls> createState() => _PayWallsState();
}

class _PayWallsState extends State<PayWalls> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paywalls"),
      ),
      
    );
  }
}
