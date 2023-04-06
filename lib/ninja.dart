import 'package:flutter/material.dart';
import 'package:ninja_jump/game_object.dart';

enum NinjaState { running, jumping }

class Ninja extends GameObject {
  final double width = 88;
  final double height = 94;

  double positionY = 0;
  double velocityY = 0;

  Color color = Colors.blue;

  @override
  Widget render() => Container(
        width: width,
        height: height,
        color: color,
      );

  @override
  Rect getRect(Size screenSize, double runDistance) => Rect.fromLTWH(
        screenSize.width / 10,
        screenSize.height / 2 + height - positionY,
        width,
        height,
      );

  @override
  void update(Duration lastUpdate, Duration elapsedTime) {
    _updateColor(elapsedTime);

    // final elapsedSeconds = (elapsedTime.inMilliseconds / lastUpdate.inMilliseconds) / 1000;
    // positionY += velocityY * elapsedSeconds;
    // if(positionY <= -1) {
    //   positionY = -1;
    //   velocityY = 0;
    // } else {
    //   velocityY -= 2000 * elapsedSeconds;
    // }
  }

  void jump() {
    velocityY = 650;
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
