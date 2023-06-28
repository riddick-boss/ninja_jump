import 'package:flutter/material.dart';
import 'package:ninja_jump/constants.dart';

class Counter extends StatelessWidget {
  const Counter({required this.score, super.key});

  final int score;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Positioned(
      left: screenSize.width / 2,
      top: screenSize.height * Constants.boundArea,
      width: 150,
      height: 150,
      child: Text(
        "$score",
        style: const TextStyle(
          fontSize: 25,
          color: Colors.yellowAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
