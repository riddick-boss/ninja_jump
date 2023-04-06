import 'package:flutter/material.dart';
import 'package:ninja_jump/game_object.dart';

enum NinjaState { running, jumping }

class Ninja extends GameObject {
  final double width = 20;
  final double height = 20;
  final movementSpeed = 1.5;

  double positionY = 0;
  double velocityY = 0;

  Color color = Colors.blue;

  double _calculateTop(Size screenSize, double runDistance) {
    const boundArea = 0.05;
    final topBound = screenSize.height * boundArea;
    final usableArea = screenSize.height * (1 - boundArea * 2) - height;

    return topBound + usableArea * positionY;

    // if(positionY == 0) {
    //   calculatedY = screenSize.height / 2;
    // } else if(positionY > 0) {
    //   calculatedY = (screenSize.height /2) - (screenSize.height / 2) * positionY;
    // } else {
    //   calculatedY = (screenSize.height /2) - (screenSize.height / 2) * positionY - height;
    // }
    // return calculatedY;
  }

  @override
  Widget render() => Container(
        width: width,
        height: height,
        color: color,
      );

  @override
  Rect getRect(Size screenSize, double runDistance) => Rect.fromLTWH(
        screenSize.width / 10,
        _calculateTop(screenSize, runDistance),
        width,
        height,
      );

  @override
  void update(Duration lastUpdate, Duration elapsedTime) {
    _updateColor(elapsedTime);

    final elapsedSeconds = (elapsedTime - lastUpdate).inMilliseconds / 1000;
    positionY += velocityY * elapsedSeconds;
    if (positionY <= 0) {
      positionY = 0;
      velocityY = 0;
    } else if (positionY >= 1) {
      positionY = 1;
      velocityY = 0;
    }
  }

  void jump() {
    if (velocityY != 0) {
      velocityY = -velocityY;
      return;
    }

    if (positionY > 0) {
      velocityY = -movementSpeed;
      return;
    }

    velocityY = movementSpeed;
  }

  void _updateColor(Duration elapsedTime) {
    final colorCode = (elapsedTime.inMilliseconds / 500).floor() % 2;
    switch (colorCode) {
      case 0:
        {
          color = Colors.blue;
          break;
        }
      case 1:
        {
          color = Colors.red;
          break;
        }
      default:
        {
          color = Colors.black;
          break;
        }
    }
  }
}
