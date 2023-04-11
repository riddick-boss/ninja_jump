import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ninja_jump/ninja.dart';
import 'package:ninja_jump/obstacle.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NinjaJump',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late AnimationController worldController;

  double runDistance = 0;
  double runVelocity = 30;
  Duration lastUpdateCall = Duration.zero;
  List<Obstacle> obstacleList = [
    Obstacle(positionY: 0, location: const Offset(200, 0))
  ];

  final ninja = Ninja();
  final foreverDuration = const Duration(days: 99);

  @override
  void initState() {
    super.initState();
    //duration set to 99days which means basically to state forever
    worldController = AnimationController(
      vsync: this,
      duration: const Duration(days: 99),
    );
    worldController
      ..addListener(_update)
      ..forward();
  }

  void _die() {
    setState(() {
      worldController.stop();
      ninja.die();
    });
  }

  void _update() {
    final worldControllerElapsed = worldController.lastElapsedDuration ?? Duration.zero;

    ninja.update(lastUpdateCall, worldControllerElapsed);

    final elapsedSeconds = (worldControllerElapsed - lastUpdateCall).inMilliseconds / 1000;

    runDistance += runVelocity * elapsedSeconds;

    final screenSize = MediaQuery.of(context).size;
    final ninjaRect = ninja.getRect(screenSize, runDistance);

    for (final obstacle in obstacleList) {
      final obstacleRect = obstacle.getRect(screenSize, runDistance);

      if(ninjaRect.overlaps(obstacleRect)) {
        _die();
      }

      if (obstacleRect.right < 0) {
        setState(() {
          obstacleList
            ..remove(obstacle)
            ..add(
              Obstacle(
                positionY: Random().nextDouble(),
                location: Offset(runDistance + Random().nextInt(100) + 50, 0),
              ),
            );
        });
      }
    }

    lastUpdateCall = worldControllerElapsed;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize =
        MediaQuery.of(context).size; // TODO: can it be moved to top?
    final children = <Widget>[];

    for (final gameObject in [...obstacleList, ninja]) {
      children.add(
        AnimatedBuilder(
          animation: worldController,
          builder: (context, _) {
            final rect = gameObject.getRect(screenSize, runDistance);
            return Positioned(
              left: rect.left,
              top: rect.top,
              width: rect.width,
              height: rect.height,
              child: gameObject.render(),
            );
          },
        ),
      );
    }

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: ninja.jump,
        child: Stack(
          alignment: Alignment.center,
          children: children,
        ),
      ),
    );
  }
}
