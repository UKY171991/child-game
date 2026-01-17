import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:child_game/theme/app_theme.dart';
import 'package:child_game/services/tts_service.dart';
import 'package:child_game/widgets/speakable_text.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  // Game Configuration
  final int gridRows = 4;
  final int gridCols = 3; // 12 cards -> 6 pairs
  
  // State
  late List<CardItem> cards;
  CardItem? flippedCard;
  bool isProcessing = false;
  int moves = 0;
  int matchesFound = 0;
  Timer? _timer;
  int secondsElapsed = 0;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startNewGame() {
    setState(() {
      moves = 0;
      matchesFound = 0;
      secondsElapsed = 0;
      flippedCard = null;
      isProcessing = false;
      _generateCards();
    });
    
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        secondsElapsed++;
      });
    });

    TtsService().speak("Memory Match. Find the pairs!");
  }

  void _generateCards() {
    List<IconData> icons = [
      Icons.rocket,
      Icons.sports_esports,
      Icons.headset,
      Icons.palette,
      Icons.science,
      Icons.music_note,
    ];

    List<CardItem> generated = [];
    for (var icon in icons) {
      generated.add(CardItem(icon: icon, id: "${icon.codePoint}_1"));
      generated.add(CardItem(icon: icon, id: "${icon.codePoint}_2"));
    }
    
    generated.shuffle();
    cards = generated;
  }

  void _onCardTap(CardItem card) {
    if (isProcessing || card.isFlipped || card.isMatched) return;

    setState(() {
      card.isFlipped = true;
    });

    TtsService().speak("Flip");

    if (flippedCard == null) {
      // First card of pair
      flippedCard = card;
    } else {
      // Second card
      isProcessing = true;
      moves++;

      if (flippedCard!.icon == card.icon) {
        // Match
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            card.isMatched = true;
            flippedCard!.isMatched = true;
            flippedCard = null;
            isProcessing = false;
            matchesFound++;
          });
          TtsService().speak("Match Found!");

          if (matchesFound == (gridRows * gridCols) ~/ 2) {
             _onGameOver();
          }
        });
      } else {
        // No Match
        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            card.isFlipped = false;
            flippedCard!.isFlipped = false;
            flippedCard = null;
            isProcessing = false;
          });
          // Optional: TtsService().speak("Try again");
        });
      }
    }
  }

  void _onGameOver() {
    _timer?.cancel();
    TtsService().speak("Game Over! You finished in $secondsElapsed seconds.");
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Level Complete!"),
        content: Text("Time: ${secondsElapsed}s\nMoves: $moves"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startNewGame();
            },
            child: const Text("Replay"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C), // Dark theme for teens
      appBar: AppBar(
        title: const SpeakableText("Memory Match"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh), 
            onPressed: _startNewGame,
            tooltip: "Restart",
          )
        ],
      ),
      body: Column(
        children: [
          // Stats Header
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatBadge("Moves", "$moves", Icons.touch_app),
                _buildStatBadge("Time", "${secondsElapsed}s", Icons.timer),
              ],
            ),
          ),
          
          // Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridCols,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                return _buildCard(cards[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.accentColor),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCard(CardItem card) {
    return GestureDetector(
      onTap: () => _onCardTap(card),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: card.isFlipped || card.isMatched 
              ? AppTheme.accentColor 
              : const Color(0xFF2D2D44),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(2, 4),
            )
          ],
          border: card.isMatched 
              ? Border.all(color: Colors.green, width: 3) 
              : Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: card.isFlipped || card.isMatched
            ? Center(
                child: Icon(
                  card.icon, 
                  size: 40, 
                  color: Colors.white
                ).animate().scale(duration: 200.ms, curve: Curves.elasticOut),
              )
            : const Center(
                child: Icon(
                  Icons.question_mark, 
                  color: Colors.grey, 
                  size: 30
                ),
              ),
      ),
    );
  }
}

class CardItem {
  final String id;
  final IconData icon;
  bool isFlipped;
  bool isMatched;

  CardItem({
    required this.id,
    required this.icon,
    this.isFlipped = false,
    this.isMatched = false,
  });
}
