import 'package:flutter/material.dart';
import 'package:child_game/theme/app_theme.dart';
import 'package:child_game/screens/home_screen.dart';
import 'package:child_game/screens/learn_screen.dart';
import 'package:child_game/screens/play_screen.dart';

void main() {
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
      },
    );
  }
}
