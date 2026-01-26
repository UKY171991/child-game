import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:child_game/services/tts_service.dart';
import 'package:child_game/theme/app_theme.dart';
import 'package:child_game/widgets/ad_banner.dart';

class ShadowMatchScreen extends StatefulWidget {
  const ShadowMatchScreen({super.key});

  @override
  State<ShadowMatchScreen> createState() => _ShadowMatchScreenState();
}

class _ShadowMatchScreenState extends State<ShadowMatchScreen> {
  final Random _random = Random();
  late ShadowItem _targetItem;
  late List<ShadowItem> _options;
  bool _isSolved = false;
  int _score = 0;

  final List<ShadowItem> _allItems = [
    ShadowItem(Icons.pets, Colors.brown, "Animal"),
    ShadowItem(Icons.wb_sunny, Colors.orange, "Sun"),
    ShadowItem(Icons.ac_unit, Colors.cyan, "Snowflake"),
    ShadowItem(Icons.rocket_launch, Colors.red, "Rocket"),
    ShadowItem(Icons.star, Colors.amber, "Star"),
    ShadowItem(Icons.favorite, Colors.pink, "Heart"),
    ShadowItem(Icons.cake, Colors.purple, "Cake"),
    ShadowItem(Icons.directions_car, Colors.blue, "Car"),
    ShadowItem(Icons.two_wheeler, Colors.green, "Bike"),
    ShadowItem(Icons.flight, Colors.indigo, "Airplane"),
    ShadowItem(Icons.emoji_events, Colors.amber, "Trophy"),
    ShadowItem(Icons.bug_report, Colors.redAccent, "Ladybug"),
    ShadowItem(Icons.music_note, Colors.deepPurple, "Music"),
    ShadowItem(Icons.beach_access, Colors.blue, "Umbrella"),
    ShadowItem(Icons.home, Colors.brown, "House"),
    ShadowItem(Icons.school, Colors.orange, "School"),
    ShadowItem(Icons.menu_book, Colors.blueGrey, "Book"),
    ShadowItem(Icons.sports_soccer, Colors.black, "Ball"),
    ShadowItem(Icons.brush, Colors.green, "Paint Brush"),
    ShadowItem(Icons.camera_alt, Colors.grey, "Camera"),
  ];

  @override
  void initState() {
    super.initState();
    _startNewLevel();
  }

  void _startNewLevel() {
    setState(() {
      _isSolved = false;
      _targetItem = _allItems[_random.nextInt(_allItems.length)];
      
      // Pick 2 other distinct items
      var others = List<ShadowItem>.from(_allItems)
        ..removeWhere((item) => item.name == _targetItem.name)
        ..shuffle();
      
      _options = [
        _targetItem,
        others[0],
        others[1],
      ]..shuffle();
    });
    
    TtsService().speak("Who is this?");
  }

  void _handleTap(ShadowItem item) {
    if (_isSolved) return;

    if (item.name == _targetItem.name) {
      // Correct
      setState(() {
        _isSolved = true;
        _score++;
      });
      TtsService().speak("Correct! It is a ${item.name}");
      
      // Next level after delay
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) _startNewLevel();
      });
    } else {
      // Wrong
      TtsService().speak("Try again!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9C4), // Light Yellow
      appBar: AppBar(
        title: const Text("Shadow Guess"),
        backgroundColor: Colors.orange,
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Who is hiding?",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.orange),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(begin: 0, end: -5, duration: 1000.ms),
          
          const SizedBox(height: 40),
          
          // Shadow Area
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                 BoxShadow(color: Colors.orange.withOpacity(0.3), blurRadius: 15, spreadRadius: 5)
              ],
            ),
            child: Center(
              child: AnimatedSwitcher(
                 duration: const Duration(milliseconds: 500),
                 child: Icon(
                   _targetItem.icon,
                   key: ValueKey(_isSolved ? "solved" : "shadow"),
                   size: 120,
                   // If solved, show real color. If not, show black shadow.
                   color: _isSolved ? _targetItem.color : Colors.black,
                 ).animate(target: _isSolved ? 1 : 0).shake().scale(begin: const Offset(1,1), end: const Offset(1.2, 1.2)),
              ),
            ),
          ),
          
          const SizedBox(height: 60),
          
          // Options
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _options.map((item) {
              return GestureDetector(
                onTap: () => _handleTap(item),
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.orange.withOpacity(0.5), width: 2),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2,2))],
                  ),
                  child: Center(
                    child: Icon(
                      item.icon,
                      size: 50,
                      color: item.color,
                    ),
                  ),
                ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 40),
        ],
      ),
       bottomNavigationBar: const AdBanner(),
    );
  }
}

class ShadowItem {
  final IconData icon;
  final Color color;
  final String name;

  ShadowItem(this.icon, this.color, this.name);
}
