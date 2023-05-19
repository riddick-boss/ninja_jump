import 'package:flutter/material.dart';

class GameOverContainer extends StatelessWidget {
  const GameOverContainer({required this.onRestartTap, super.key});

  final void Function() onRestartTap;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Positioned(
      left: 0,
      top: 0,
      width: screenSize.width,
      height: screenSize.height,
      child: GestureDetector(
        onTap: onRestartTap,
        child: const DecoratedBox(
          decoration: BoxDecoration(
            color: Color.fromRGBO(100, 0, 0, 0.6),
          ),
          child: Center(
            child: Text(
              "Ninja kaput \n Tap to replay",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                color: Colors.red,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
