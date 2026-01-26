import 'package:flutter/material.dart';
import 'package:child_game/widgets/custom_button.dart';
import 'package:child_game/widgets/speakable_text.dart';
import 'package:child_game/theme/app_theme.dart';
import 'package:child_game/widgets/ad_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openPrivacyPolicy(BuildContext context) {
    Navigator.pushNamed(context, '/privacy');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SpeakableText('Fun Kids App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.privacy_tip),
            tooltip: 'Privacy Policy',
            onPressed: () => _openPrivacyPolicy(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

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
              label: 'MATCHING',
              icon: Icons.extension, // Puzzle piece fits matching better than controller
              color: AppTheme.accentColor,
              onTap: () {
                Navigator.pushNamed(context, '/play');
              },
            ),
            const SizedBox(height: 30),
            CustomButton(
              label: 'FALLING TEXT',
              icon: Icons.text_fields,
              color: AppTheme.secondaryColor,
              onTap: () {
                Navigator.pushNamed(context, '/falling_text');
              },
            ),
            const SizedBox(height: 30),
            CustomButton(
              label: 'BALLOON POP',
              icon: Icons.bubble_chart,
              color: AppTheme.primaryColor,
              onTap: () {
                Navigator.pushNamed(context, '/balloon_pop');
              },
            ),
            const SizedBox(height: 30),
            CustomButton(
              label: 'GUESS SHADOW',
              icon: Icons.question_mark,
              color: Colors.orange,
              onTap: () {
                Navigator.pushNamed(context, '/shadow_match');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdBanner(),
    );
  }
}
