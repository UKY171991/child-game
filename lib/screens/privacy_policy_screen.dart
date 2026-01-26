import 'package:flutter/material.dart';
import 'package:child_game/theme/app_theme.dart';
import 'package:child_game/widgets/custom_button.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // background from html
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(50)),
                ),
                child: Column(
                  children: [
                    Text(
                      'Privacy Policy',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'How we protect our little explorers.',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 18,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Content Box
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Effective Date: January 19, 2026',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      _buildSectionTitle(context, '1. Introduction'),
                      _buildParagraph(
                          'Welcome to Leo\'s Learn & Play. We are committed to protecting the privacy of our users, especially children. This Privacy Policy explains how we handle information in our application.'),
                      _buildSectionTitle(context, '2. Children\'s Privacy (COPPA)'),
                      _buildParagraph(
                          'Our app is designed for children under the age of 13. We do not knowingly collect, store, or share any personal information from children. Our app is a static learning environment and does not require registration.'),
                      _buildSectionTitle(context, '3. Information Collection'),
                      _buildParagraph(
                          'Leo\'s Learn & Play does not collect any personal data. We do not collect:'),
                      _buildBulletPoint('Names, email addresses, or phone numbers.'),
                      _buildBulletPoint('Location data.'),
                      _buildBulletPoint('Device identifiers or IP addresses.'),
                      _buildBulletPoint(
                          'Photos or voice recordings (Voice support is processed locally on your device).'),
                      _buildSectionTitle(context, '4. Third-Party Services'),
                      _buildParagraph(
                          'Our application is self-contained. We do not use third-party analytics, advertising networks, or social media plugins that could track user behavior.'),
                      _buildSectionTitle(context, '5. Local Storage'),
                      _buildParagraph(
                          'The app may use your browser\'s local storage only to remember your game progress (like high scores). This data stays strictly on your device and is never sent to our servers.'),
                      _buildSectionTitle(context, '6. Security'),
                      _buildParagraph(
                          'Since we do not collect any personal information, there is no risk of your data being compromised from our side. We recommend parents supervise children while using any digital device.'),
                      _buildSectionTitle(context, '7. Changes to This Policy'),
                      _buildParagraph(
                          'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.'),
                      _buildSectionTitle(context, '8. Contact Us'),
                      _buildParagraph(
                          'If you have any questions about this Privacy Policy, please contact us at: support@childgame.example.com'),
                      const SizedBox(height: 40),
                      Center(
                        child: CustomButton(
                          label: 'Back to Home',
                          icon: Icons.home,
                          color: AppTheme.accentColor,
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '© 2026 Child Game. All rights reserved.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, bottom: 10),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.secondaryColor,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          height: 1.5,
          color: Color(0xFF555555),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Color(0xFF555555),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
