import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:child_game/theme/app_theme.dart';
import 'package:child_game/services/tts_service.dart';
import 'package:child_game/widgets/ad_banner.dart';
import 'package:child_game/utils/number_helper.dart';

class FallingTextGame extends StatefulWidget {
  const FallingTextGame({super.key});

  @override
  State<FallingTextGame> createState() => _FallingTextGameState();
}

class _FallingTextGameState extends State<FallingTextGame> {
  final List<String> _words = [
    "SAFE", "HELP", "LOVE", "KIND", "GOOD", "CALM", "CARE", "NICE", "PLAY", "READ",
    "WALK", "JUMP", "SING", "BLUE", "RED", "CAT", "DOG", "SUN", "MOON", "STAR"
  ];
  
  final List<FallingWord> _activeWords = [];
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  
  Timer? _gameLoopTimer;
  Timer? _spawnTimer;
  int _score = 0;
  int _lives = 5;
  bool _isPlaying = false;
  double _spawnRate = 2000; // ms

  @override
  void initState() {
    super.initState();
    // Start game automatically or wait for user? Let's show a start screen overlay
  }

  @override
  void dispose() {
    _gameLoopTimer?.cancel();
    _spawnTimer?.cancel();
    _inputController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      _isPlaying = true;
      _score = 0;
      _lives = 5;
      _activeWords.clear();
      _spawnRate = 2000;
      _inputController.clear();
    });
    
    // Focus keyboard
    FocusScope.of(context).requestFocus(_focusNode);

    // Main Loop
    _gameLoopTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      _updateGame();
    });

    // Spawn Loop
    _spawnTimer = Timer.periodic(Duration(milliseconds: _spawnRate.toInt()), (timer) {
      _spawnWord();
    });
  }

  void _spawnWord() {
    if (!_isPlaying) return;
    
    final random = Random();
    String word = _words[random.nextInt(_words.length)];
    
    // Avoid duplicates on screen
    if (_activeWords.any((w) => w.text == word)) return;

    double startX = random.nextDouble() * (MediaQuery.of(context).size.width - 100);
    
    setState(() {
      _activeWords.add(FallingWord(
        text: word,
        x: startX,
        y: -50,
        speed: 2.0 + (_score / 50), // Increase speed with score
      ));
    });
  }

  void _updateGame() {
    if (!_isPlaying) return;

    setState(() {
      final height = MediaQuery.of(context).size.height;

      // Move words
      for (var word in _activeWords) {
        word.y += word.speed;
      }

      // Check bounds
      for (int i = _activeWords.length - 1; i >= 0; i--) {
        if (_activeWords[i].y > height) {
          _activeWords.removeAt(i);
          _takeDamage();
        }
      }
    });
  }

  void _takeDamage() {
    setState(() {
      _lives--;
    });
    HapticFeedback.heavyImpact();
    if (_lives <= 0) {
      _gameOver();
    }
  }

  void _gameOver() {
    _isPlaying = false;
    _gameLoopTimer?.cancel();
    _spawnTimer?.cancel();
    TtsService().speak("Game Over. Your score is ${intToWords(_score)}");
  }

  void _checkInput(String value) {
    if (value.isEmpty) return;
    
    String typed = value.toUpperCase().trim();
    
    // Check if any word matches
    int matchIndex = -1;
    for (int i = 0; i < _activeWords.length; i++) {
      if (_activeWords[i].text == typed) {
        matchIndex = i;
        break;
      }
    }

    if (matchIndex != -1) {
      // Match found
      final word = _activeWords[matchIndex];
      setState(() {
        _activeWords.removeAt(matchIndex);
        _score += 10;
        _inputController.clear();
      });
      TtsService().speak("Safe!"); // "Safety" theme
      HapticFeedback.lightImpact();
      
      // Ramp up difficulty
      if (_score % 50 == 0) {
        _increaseDifficulty();
      }
      
    } else {
      // No match yet, user keeps typing. 
      // Optional: Clear input if it doesn't match prefix of any word? 
      // For now, let them type. But standard behavior is usually check invalid input.
      // Let's modify: Check if any current word STARTS with what they typed.
      bool isPrefix = _activeWords.any((w) => w.text.startsWith(typed));
      if (!isPrefix) {
        // Wrong typing, clear
         // _inputController.clear(); // Too frustrating?
         // Maybe just visually indicate error?
      }
    }
  }

  void _increaseDifficulty() {
    _spawnRate = (_spawnRate * 0.9).clamp(500, 2000);
    _spawnTimer?.cancel();
    _spawnTimer = Timer.periodic(Duration(milliseconds: _spawnRate.toInt()), (timer) {
      _spawnWord();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text("Falling Words"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      ),
      body: Stack(
        children: [
          // Input Field (Hidden or Visible?)
          // For mobile, we generally need a visible keyboard.
          Positioned(
            bottom: 60, // Above ad banner
            left: 20,
            right: 20,
            child: TextField(
              controller: _inputController,
              focusNode: _focusNode,
              onChanged: _checkInput,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) {
                // Keep focus
                _focusNode.requestFocus();
              },
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: "Type text here...",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.white),
                  onPressed: () => _inputController.clear(),
                ),
              ),
              autofocus: true,
            ),
          ),
          
          // Words
          ..._activeWords.map((w) => Positioned(
            left: w.x,
            top: w.y,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
              ),
              child: Text(
                w.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          )),
          
          // Score & Lives
          Positioned(
            top: 10,
            left: 20,
            child: Text("Score: $_score", style: const TextStyle(color: Colors.white, fontSize: 20)),
          ),
          Positioned(
            top: 10,
            right: 20,
            child: Row(
              children: List.generate(5, (index) => Icon(
                index < _lives ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              )),
            ),
          ),

          // Start / Game Over Overlay
          if (!_isPlaying)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _score > 0 ? "Game Over" : "Ready?",
                      style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _startGame,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        backgroundColor: AppTheme.accentColor,
                      ),
                      child: const Text("START GAME", style: TextStyle(fontSize: 24)),
                    ),
                  ],
                ),
              ),
            ),
            
        ],
      ),
      bottomNavigationBar: const AdBanner(),
    );
  }
}

class FallingWord {
  String text;
  double x;
  double y;
  double speed;

  FallingWord({
    required this.text,
    required this.x,
    required this.y,
    required this.speed,
  });
}
