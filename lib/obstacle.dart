import 'package:flutter/material.dart';
import 'package:ninja_jump/constants.dart';
import 'package:ninja_jump/game_object.dart';

class Obstacle extends GameObject {

  Obstacle({required this.positionY, required this.offsetX});

  double positionY;
  double offsetX;

  final double width = 20;
  final double height = 20;
  Color color = Colors.orangeAccent;

  @override
  Widget render() => Container(
    width: width,
    height: height,
    color: color,
  );

  double _calculateTop(Size screenSize) {
    const boundArea = 0.05;
    final topBound = screenSize.height * boundArea;
    final usableArea = screenSize.height * (1 - boundArea * 2) - height;

    return topBound + usableArea * positionY;
  }

  double _calculateX(double runDistance) {
    return (offsetX - runDistance) * Constants.worldToPixelRatio;
  }

  @override
  Rect getRect(Size screenSize, double runDistance) => Rect.fromLTWH(
    _calculateX(runDistance),
    _calculateTop(screenSize),
    width,
    height,
  );
}
