import 'package:flutter/material.dart';
import '../services/tts_service.dart';

class SpeakableText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const SpeakableText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TtsService().speak(text);
      },
      child: Text(
        text,
        style: style,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
      ),
    );
  }
}
