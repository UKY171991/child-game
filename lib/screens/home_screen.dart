import 'package:flutter/material.dart';
import 'package:child_game/widgets/custom_button.dart';
import 'package:child_game/widgets/speakable_text.dart';
import 'package:child_game/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SpeakableText('Fun Kids App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.star,
              size: 100,
              color: AppTheme.primaryColor,
            ),
            const SizedBox(height: 40),
            CustomButton(
              label: 'LEARN',
              icon: Icons.school,
              color: AppTheme.secondaryColor,
              onTap: () {
                Navigator.pushNamed(context, '/learn');
              },
            ),
            const SizedBox(height: 30),
            CustomButton(
              label: 'PLAY',
              icon: Icons.games,
              color: AppTheme.accentColor,
              onTap: () {
                Navigator.pushNamed(context, '/play');
              },
            ),
          ],
        ),
      ),
    );
  }
}
