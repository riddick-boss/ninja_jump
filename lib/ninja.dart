import 'package:flutter/material.dart';
import 'package:ninja_jump/constants.dart';
import 'package:ninja_jump/game_object.dart';

enum NinjaState { running, jumping }

class Ninja extends GameObject {
  static const double _initialPositionY = 0;
  static const double _initialVelocityY = 0;

  final double width = 60;
  final double height = 50;
  final movementSpeed = 1.15;

  double positionY = _initialPositionY;
  double velocityY = _initialVelocityY;

  double _calculateTop(Size screenSize) {
    final boundArea = Constants.boundArea;
    final topBound = screenSize.height * boundArea;
    final usableArea = screenSize.height * (1 - boundArea * 2) - height;

    return topBound + usableArea * positionY;
  }

  @override
  Widget render() => Image.asset(
        "assets/graphics/ninja.png",
        fit: BoxFit.fill,
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

  void restart() {
    positionY = _initialPositionY;
    velocityY = _initialVelocityY;
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
}
