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

  double _calculateTop(Size screenSize) {
    const boundArea = 0.05;
    final topBound = screenSize.height * boundArea;
    final usableArea = screenSize.height * (1 - boundArea * 2) - height;

    return topBound + usableArea * positionY;
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
        _calculateTop(screenSize),
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
    final isMoving = velocityY != 0;
    if (isMoving) {
      _changeMovementDirection();
      return;
    }

    final isOnBottom = positionY <= 0;
    if (isOnBottom) {
      _moveUp();
      return;
    }

    _moveDown();
  }

  void die() {
    color = Colors.green;
  }

  void _changeMovementDirection() {
    velocityY = -velocityY;
  }

  void _moveUp() {
    velocityY = movementSpeed;
  }

  void _moveDown() {
    velocityY = -movementSpeed;
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
