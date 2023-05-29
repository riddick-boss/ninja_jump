import 'package:flutter/material.dart';
import 'package:ninja_jump/constants.dart';

class HighScoreCounter extends StatelessWidget {
  const HighScoreCounter({required this.highScore, super.key});

  final int highScore;

  double get _width => 200;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Positioned(
      left: screenSize.width - _width - 20, //20 added for curved screens
      top: screenSize.height * Constants.boundArea,
      width: _width,
      height: 150,
      child: Text(
        "High score: $highScore",
        textAlign: TextAlign.right,
        style: const TextStyle(
          fontSize: 25,
          color: Colors.orangeAccent,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
