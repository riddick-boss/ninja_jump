import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ninja_jump/constants.dart';
import 'package:ninja_jump/counter.dart';
import 'package:ninja_jump/game_over_container.dart';
import 'package:ninja_jump/high_score_counter.dart';
import 'package:ninja_jump/ninja.dart';
import 'package:ninja_jump/obstacle.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<dynamic> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs,));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.prefs, super.key});

  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NinjaJump',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(prefs: prefs,),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({required this.prefs, super.key});

  final SharedPreferences prefs;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {

  late AnimationController worldController;

  int score = 0;
  double runDistance = 0;
  double runVelocity = 30;
  Duration lastUpdateCall = Duration.zero;
  List<Obstacle> obstacleList = [
    Obstacle(positionY: Random().nextDouble(), offsetX: 200)
  ];
  bool showRestart = false;

  final ninja = Ninja();
  final foreverDuration = const Duration(days: 99);

  SharedPreferences get _prefs => widget.prefs;

  Future<void> _setHighScoreIfNecessary(int value) async {
    if(value > highScore) {
      await _prefs.setInt(Constants.highScoreKey, value);
    }
  }

  int get highScore => _prefs.getInt(Constants.highScoreKey) ?? 0;

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
      showRestart = true;
      worldController.stop();
    });
  }

  void _update() {
    final worldControllerElapsed = worldController.lastElapsedDuration ?? Duration.zero;

    ninja.update(lastUpdateCall, worldControllerElapsed);

    final elapsedSeconds = (worldControllerElapsed - lastUpdateCall).inMilliseconds / 1000; //TODO: check why using inSeconds is not working here

    runDistance += runVelocity * elapsedSeconds;

    final screenSize = MediaQuery.of(context).size;
    final ninjaRect = ninja.getRect(screenSize, runDistance);

    var shouldAdd = false;
    final toRemove = <Obstacle>[];

    for (final obstacle in obstacleList) {
      final obstacleRect = obstacle.getRect(screenSize, runDistance);

      if (ninjaRect.overlaps(obstacleRect)) {
        _die();
      }

      final leftThreshold = Random().nextInt(50);
      final rightThreshold = Random().nextInt(100) + 50;

      if (obstacleRect.right > leftThreshold && obstacleRect.right < rightThreshold) {
        shouldAdd = true;
      }

      if (obstacleRect.right < 0) {
        score += 1;
        _setHighScoreIfNecessary(score);
        toRemove.add(obstacle);
      }
    }

    //max 5 items
    if (obstacleList.length < Constants.maxObstaclesAtOnce && shouldAdd) {
      setState(() {
        obstacleList.add(
          Obstacle(
            positionY: Random().nextDouble(),
            offsetX: runDistance + Random().nextInt(150) + 50,
          ),
        );
      });
    }

    setState(() {
      obstacleList.removeWhere(toRemove.contains);
    });

    lastUpdateCall = worldControllerElapsed;
    if (elapsedSeconds != 0 && elapsedSeconds % 10 == 0) {
      runVelocity += 30;
    }
  }

  void _restart() {
    showRestart = false;
    score = 0;
    ninja.restart();
    obstacleList
      ..clear()
      ..add(Obstacle(positionY: Random().nextDouble(), offsetX: 200));
    worldController
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final children = <Widget>[
      Container(
        color: Colors.blueAccent,
      ),
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/graphics/Mountains-Transparent.png"),
            fit: BoxFit.cover,
          ),
        ),
      )
    ];

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

    children
      ..add(Counter(score: score))
      ..add(
        HighScoreCounter(highScore: highScore),
      );

    if (showRestart) {
      children.add(
        GameOverContainer(
          onRestartTap: _restart,
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
