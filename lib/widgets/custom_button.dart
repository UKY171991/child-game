import 'package:flutter/material.dart';
import '../services/tts_service.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;
  final IconData icon;

  const CustomButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TtsService().speak(label);
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(4, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      )
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .scale(
            duration: 2000.ms,
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.05, 1.05),
            curve: Curves.easeInOut,
          ),
    );
  }
}
