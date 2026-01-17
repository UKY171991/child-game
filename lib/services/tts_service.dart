import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  late FlutterTts _flutterTts;

  factory TtsService() {
    return _instance;
  }

  TtsService._internal() {
    _flutterTts = FlutterTts();
    _initTts();
  }

  Future<void> _initTts() async {
    await _flutterTts.setLanguage("en-IN"); // Indian English
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.awaitSpeakCompletion(false); // Ensure we don't wait for speech to finish

    try {
      dynamic voices = await _flutterTts.getVoices;
      if (voices is List) {
        for (var voice in voices) {
          String name = voice['name'].toString().toLowerCase();
          String locale = voice['locale'].toString().toLowerCase();
          
          if (locale.contains('en_in') || 
              name.contains('india') || 
              name.contains('hindi')) {
            await _flutterTts.setVoice(voice);
            break;
          }
        }
      }
    } catch (e) {
      debugPrint("Error setting voice: $e");
    }
  }

  Future<void> speak(String text) async {
    if (text.isNotEmpty) {
      _flutterTts.stop(); 
      _flutterTts.speak(text);
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}
