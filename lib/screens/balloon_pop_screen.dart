import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:child_game/services/tts_service.dart';
import 'package:child_game/theme/app_theme.dart';
import 'package:child_game/widgets/ad_banner.dart';

class BalloonPopScreen extends StatefulWidget {
  const BalloonPopScreen({super.key});

  @override
  State<BalloonPopScreen> createState() => _BalloonPopScreenState();
}

class _BalloonPopScreenState extends State<BalloonPopScreen> {
  final List<Balloon> _balloons = [];
  final Random _random = Random();
  Timer? _spawnTimer;
  Timer? _gameLoopTimer;
  int _score = 0;
  bool _isPlaying = true;

  // Colors for balloons
  final List<Color> _colors = [
    Colors.red, Colors.blue, Colors.green, Colors.orange, 
    Colors.purple, Colors.pink, Colors.teal, Colors.yellow[700]!
  ];

  // Letters and Numbers
  final List<String> _content = [
    ...'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split(''),
    ...'0123456789'.split('')
  ];

  @override
  void initState() {
    super.initState();
    _startGame();
  }

  @override
  void dispose() {
    _spawnTimer?.cancel();
    _gameLoopTimer?.cancel();
    super.dispose();
  }

  void _startGame() {
    TtsService().speak("Pop the balloons!");
    _spawnTimer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (_isPlaying) _spawnBalloon();
    });

    _gameLoopTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (_isPlaying) _updateBalloons();
    });
  }

  void _spawnBalloon() {
    setState(() {
      _balloons.add(Balloon(
        id: DateTime.now().millisecondsSinceEpoch.toString() + _random.nextInt(1000).toString(),
        x: _random.nextDouble() * (MediaQuery.of(context).size.width - 80), // Keep within bounds
        y: MediaQuery.of(context).size.height,
        color: _colors[_random.nextInt(_colors.length)],
        text: _content[_random.nextInt(_content.length)],
        speed: 2.0 + _random.nextDouble() * 2.0, // Random speed 2-4
      ));
    });
  }

  void _updateBalloons() {
    setState(() {
      // Move up
      for (var b in _balloons) {
        b.y -= b.speed;
      }
      // Remove off-screen
      _balloons.removeWhere((b) => b.y < -100);
    });
  }

  void _popBalloon(Balloon balloon) {
    if (balloon.isPopped) return;

    setState(() {
      balloon.isPopped = true;
      _score++;
    });

    TtsService().speak(balloon.text); // Say the letter/number
    
    // Remove after short delay for animation
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _balloons.remove(balloon);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100], // Sky blue
      appBar: AppBar(
        title: const Text("Pop the Balloons!"),
        backgroundColor: Colors.pink,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text("Score: $_score", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          // Background Clouds (Static for now, could be animated)
          const Positioned(top: 50, left: 50, child: Icon(Icons.cloud, size: 80, color: Colors.white)),
          const Positioned(top: 100, right: 80, child: Icon(Icons.cloud, size: 60, color: Colors.white)),
          const Positioned(top: 200, left: 150, child: Icon(Icons.cloud, size: 100, color: Colors.white)),

          // Balloons
          ..._balloons.map((balloon) => Positioned(
            left: balloon.x,
            top: balloon.y,
            child: GestureDetector(
              onTap: () => _popBalloon(balloon),
              child: balloon.isPopped 
                  ? _buildPopped(balloon) 
                  : _buildBalloon(balloon),
            ),
          )),
        ],
      ),
      bottomNavigationBar: const AdBanner(),
    );
  }

  Widget _buildBalloon(Balloon balloon) {
    return Container(
      width: 80,
      height: 100,
      decoration: BoxDecoration(
        color: balloon.color,
        borderRadius: const BorderRadius.all(Radius.elliptical(80, 100)),
        boxShadow: const [
          BoxShadow(color: Colors.black26, offset: Offset(2, 4), blurRadius: 4)
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            balloon.color.withOpacity(0.5),
            balloon.color,
          ],
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            balloon.text,
            style: const TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          // String
          Transform.translate(
            offset: const Offset(0, 45),
            child: Container(
              width: 2,
              height: 40,
              color: Colors.white,
            ),
          )
        ],
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true))
     .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 1000.ms); // Breathing effect
  }

  Widget _buildPopped(Balloon balloon) {
    return const Icon(Icons.star, color: Colors.yellow, size: 80)
        .animate()
        .scale(duration: 200.ms, curve: Curves.easeOut)
        .fadeOut(duration: 200.ms);
  }
}

class Balloon {
  final String id;
  double x;
  double y;
  final Color color;
  final String text;
  final double speed;
  bool isPopped = false;

  Balloon({
    required this.id,
    required this.x,
    required this.y,
    required this.color,
    required this.text,
    required this.speed,
  });
}
