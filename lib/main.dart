import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ninja_jump/ninja.dart';

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

  Duration lastUpdateCall = Duration.zero;

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

  void _update() {
    final controllerLastElapsed =
        worldController.lastElapsedDuration ?? lastUpdateCall;
    ninja.update(lastUpdateCall, controllerLastElapsed);

    lastUpdateCall = controllerLastElapsed;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize =
        MediaQuery.of(context).size; // TODO: can it be moved to top?
    final children = <Widget>[];

    for (final gameObject in [ninja]) {
      children.add(
        AnimatedBuilder(
          animation: worldController,
          builder: (context, _) {
            final rect = gameObject.getRect(screenSize, 0);
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
