import 'package:flutter/material.dart';
import 'package:child_game/theme/app_theme.dart';
import 'package:child_game/screens/home_screen.dart';
import 'package:child_game/screens/learn_screen.dart';
import 'package:child_game/screens/play_screen.dart';
import 'package:child_game/screens/falling_text_game.dart';
import 'package:child_game/screens/balloon_pop_screen.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const ChildGameApp());
}

class ChildGameApp extends StatelessWidget {
  const ChildGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeuroTeen Learning',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/learn': (context) => LearnScreen(),
        '/play': (context) => const PlayScreen(),
        '/falling_text': (context) => const FallingTextGame(),
        '/balloon_pop': (context) => const BalloonPopScreen(),
      },
    );
  }
}
