import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:child_game/services/tts_service.dart';
import 'package:child_game/widgets/ad_banner.dart';
import 'package:child_game/data/game_data.dart'; // Import the data

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  // Navigation State
  String? _selectedCategory; // 'alphabet', 'animals', 'fruits'
  
  // Game State
  List<GameItem> _currentLevelItems = [];
  List<String> _rightSideItems = [];
  final Map<String, String> _matches = {}; // Left Text -> Right Icon
  String? _selectedLeft;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    // We start at category selection, so no game starts immediately
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _startNewGame();
  }

  void _returnToMenu() {
    setState(() {
      _selectedCategory = null;
      _matches.clear();
      _currentLevelItems.clear();
      _rightSideItems.clear();
    });
  }

  void _startNewGame() {
    if (_selectedCategory == null) return;

    List<GameItem> sourceList = [];
    String speechText = "";

    switch (_selectedCategory) {
      case 'alphabet':
        sourceList = GameData.alphabet;
        speechText = "Match the letters!";
        break;
      case 'animals':
        sourceList = GameData.animals;
        speechText = "Match the animals!";
        break;
      case 'fruits':
        sourceList = GameData.fruits;
        speechText = "Match the food!";
        break;
      default:
        sourceList = GameData.alphabet;
    }

    setState(() {
      var shuffled = List<GameItem>.from(sourceList)..shuffle();
      // Take 4 items for the level
      var pickedItems = shuffled.take(4).toList();
      
      // Sort alphbetically or logically to make it easier to find
      pickedItems.sort((a, b) => a.text.compareTo(b.text));
      
      _currentLevelItems = pickedItems;
      
      // Right side is just the icons, shuffled differently
      _rightSideItems = _currentLevelItems.map((e) => e.icon).toList()..shuffle();
      
      _matches.clear();
      _selectedLeft = null;
      _score = 0;
    });
    TtsService().speak(speechText);
  }

  void _handleLeftTap(String text) {
    if (_matches.containsKey(text)) return; 
    
    setState(() {
      _selectedLeft = text;
    });
    
    // Find the item name to speak
    var item = _currentLevelItems.firstWhere((e) => e.text == text);
    TtsService().speak(item.name); 
  }

  void _handleRightTap(String icon) {
    if (_selectedLeft == null) {
      TtsService().speak("Pick a name first!");
      return;
    }
    
    // Check match
    var correctItem = _currentLevelItems.firstWhere((e) => e.text == _selectedLeft);
    
    if (correctItem.icon == icon) {
      // Correct!
      setState(() {
        _matches[_selectedLeft!] = icon;
        _selectedLeft = null;
        _score++;
      });
      TtsService().speak("Good job! ${correctItem.name}");
      
      if (_matches.length == _currentLevelItems.length) {
        Future.delayed(const Duration(seconds: 1), _showWinDialog);
      }
    } else {
      // Wrong
      TtsService().speak("Try again!");
      setState(() {
        _selectedLeft = null;
      });
    }
  }
  
  void _showWinDialog() {
    TtsService().speak("You won! Amazing!");
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Awesome!"),
        content: const Text("You matched everything correctly!"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startNewGame(); // proper restart with same category
            },
            child: const Text("Play Again", style: TextStyle(fontSize: 20)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _returnToMenu();
            },
            child: const Text("Menu", style: TextStyle(fontSize: 20, color: Colors.grey)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4C3), // Light Lime background
      appBar: AppBar(
        title: Text(_selectedCategory == null ? "Select Game" : "Matching Fun"),
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
        leading: _selectedCategory != null 
          ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: _returnToMenu)
          : IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        actions: [
          if (_selectedCategory != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _startNewGame,
            )
        ],
      ),
      body: _selectedCategory == null ? _buildCategorySelection() : _buildGameLayout(),
      bottomNavigationBar: const AdBanner(),
    );
  }

  Widget _buildCategorySelection() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Choose a Category",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.purple),
            ),
            const SizedBox(height: 30),
            _buildCategoryButton("Alphabet", "🅰️", Colors.redAccent, "alphabet"),
            const SizedBox(height: 20),
            _buildCategoryButton("Animals", "🦁", Colors.orange, "animals"),
            const SizedBox(height: 20),
            _buildCategoryButton("Fruits & Food", "🍎", Colors.green, "fruits"),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String label, String icon, Color color, String categoryId) {
    return InkWell(
      onTap: () => _selectCategory(categoryId),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
          border: Border.all(color: color.withOpacity(0.5), width: 2),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 40)),
            const SizedBox(width: 20),
            Text(
              label,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, color: color),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 600.ms).slideX(begin: 0.1);
  }

  Widget _buildGameLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Line Painter
            CustomPaint(
              size: Size(constraints.maxWidth, constraints.maxHeight),
              painter: LinePainter(
                matches: _matches,
                leftItems: _currentLevelItems,
                rightItems: _rightSideItems,
              ),
            ),
            
            // Items Row
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left Column
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch items to fill width
                      children: _currentLevelItems.map((item) {
                        bool isSelected = _selectedLeft == item.text;
                        bool isMatched = _matches.containsKey(item.text);
                        
                        return GestureDetector(
                          onTap: () => _handleLeftTap(item.text),
                          child: Container(
                            height: 80,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.yellow : Colors.white,
                              borderRadius: BorderRadius.circular(20), // Box for text
                              border: Border.all(
                                color: isMatched ? Colors.green : (isSelected ? Colors.orange : Colors.pinkAccent), 
                                width: 4
                              ),
                              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2,2))],
                            ),
                            child: Center(
                              child: FittedBox(
                                child: Text(
                                  item.text,
                                  style: TextStyle(
                                    fontSize: 24, 
                                    fontWeight: FontWeight.bold,
                                    color: item.color
                                  ),
                                ),
                              ),
                            ),
                          ).animate(target: isSelected ? 1 : 0).scale(end: const Offset(1.1, 1.1)),
                        );
                      }).toList(),
                    ),
                  ),
                  
                  const SizedBox(width: 50), // Spacing for lines
                  
                  // Right Column (Icons)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _rightSideItems.map((icon) {
                        bool isMatched = _matches.containsValue(icon);
                        
                        return GestureDetector(
                          onTap: () => _handleRightTap(icon),
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: isMatched ? Colors.green : Colors.blueAccent,
                                width: 4
                              ),
                              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2,2))],
                            ),
                            child: Center(
                              child: Text(
                                icon,
                                style: const TextStyle(fontSize: 45),
                              ),
                            ),
                          )
                          .animate(target: isMatched ? 1 : 0)
                          .shimmer(duration: 500.ms, color: Colors.greenAccent)
                          .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1)),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class LinePainter extends CustomPainter {
  final Map<String, String> matches;
  final List<GameItem> leftItems;
  final List<String> rightItems;

  LinePainter({
    required this.matches, 
    required this.leftItems, 
    required this.rightItems,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
      
    double itemHeightSpace = (size.height - 40) / 4; 
    double colWidth = (size.width - 40 - 50) / 2;
    double startX = 20 + colWidth; // Right edge of left box (approx)
    double endX = size.width - 20 - colWidth; // Left edge of right box (approx)
    
    // We can adjust startX/endX slightly to connect better to the boxes
    // Left Box is width expanded, but let's assume it takes most of the half.
    // The previous implementation used circles, now left is a rounded box.
    // Let's connect from center-ish of the gaps.
    
    // Actually, to make lines look good, we should connect inner edges.
    startX = (size.width / 2) - 40; 
    endX = (size.width / 2) + 40;

    matches.forEach((leftKey, rightIcon) {
      int leftIndex = leftItems.indexWhere((e) => e.text == leftKey);
      int rightIndex = rightItems.indexOf(rightIcon);
      
      if (leftIndex != -1 && rightIndex != -1) {
        double startY = 20 + itemHeightSpace * leftIndex + itemHeightSpace / 2;
        double endY = 20 + itemHeightSpace * rightIndex + itemHeightSpace / 2;
        
        paint.color = Colors.green;
        
        // Accurate X positions
        // Start: Right edge of Left Column (assuming stretch)
        // End: Left edge of Right Item (centered 80px box in column)
        double realStartX = 20 + colWidth; 
        double rightColCenter = size.width - 20 - (colWidth / 2);
        double realEndX = rightColCenter - 40; // 40 is half of 80px width
        
        canvas.drawLine(Offset(realStartX, startY), Offset(realEndX, endY), paint);
      }
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
