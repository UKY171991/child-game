import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:child_game/services/tts_service.dart';
import 'package:child_game/theme/app_theme.dart';
import 'package:child_game/widgets/ad_banner.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  // Game Configuration
  final List<GameItem> _allGameItems = [
    // --- Alphabet (26) ---
    GameItem(text: "A", icon: "🍎", name: "Apple", color: Colors.red),
    GameItem(text: "B", icon: "⚽", name: "Ball", color: Colors.blue),
    GameItem(text: "C", icon: "🚗", name: "Car", color: Colors.orange),
    GameItem(text: "D", icon: "🦆", name: "Duck", color: Colors.green),
    GameItem(text: "E", icon: "🐘", name: "Elephant", color: Colors.grey),
    GameItem(text: "F", icon: "🐟", name: "Fish", color: Colors.blueAccent),
    GameItem(text: "G", icon: "🍇", name: "Grapes", color: Colors.purple),
    GameItem(text: "H", icon: "🏠", name: "House", color: Colors.brown),
    GameItem(text: "I", icon: "🍦", name: "Ice Cream", color: Colors.pink),
    GameItem(text: "J", icon: "🥤", name: "Juice", color: Colors.orangeAccent),
    GameItem(text: "K", icon: "🪁", name: "Kite", color: Colors.teal),
    GameItem(text: "L", icon: "🦁", name: "Lion", color: Colors.orange),
    GameItem(text: "M", icon: "🐵", name: "Monkey", color: Colors.brown),
    GameItem(text: "N", icon: "👃", name: "Nose", color: Colors.deepOrange),
    GameItem(text: "O", icon: "🐙", name: "Octopus", color: Colors.deepPurple),
    GameItem(text: "P", icon: "🐧", name: "Penguin", color: Colors.black),
    GameItem(text: "Q", icon: "👑", name: "Queen", color: Colors.amber),
    GameItem(text: "R", icon: "🐰", name: "Rabbit", color: Colors.grey),
    GameItem(text: "S", icon: "☀️", name: "Sun", color: Colors.orange),
    GameItem(text: "T", icon: "🐯", name: "Tiger", color: Colors.orangeAccent),
    GameItem(text: "U", icon: "☂️", name: "Umbrella", color: Colors.blue),
    GameItem(text: "V", icon: "🎻", name: "Violin", color: Colors.brown),
    GameItem(text: "W", icon: "🐳", name: "Whale", color: Colors.blue),
    GameItem(text: "X", icon: "🎹", name: "Xylophone", color: Colors.red), // Approx
    GameItem(text: "Y", icon: "🛥️", name: "Yacht", color: Colors.blueGrey),
    GameItem(text: "Z", icon: "🦓", name: "Zebra", color: Colors.black),

    // --- Numbers (20) ---
    GameItem(text: "1", icon: "🥇", name: "One Medal", color: Colors.amber),
    GameItem(text: "2", icon: "✌️", name: "Two Fingers", color: Colors.orange),
    GameItem(text: "3", icon: "☘️", name: "Three Leafs", color: Colors.green),
    GameItem(text: "4", icon: "🍀", name: "Four Leaf Clover", color: Colors.greenAccent),
    GameItem(text: "5", icon: "🖐️", name: "Five Fingers", color: Colors.brown),
    GameItem(text: "6", icon: "🎲", name: "Dice Six", color: Colors.red),
    GameItem(text: "7", icon: "🌈", name: "Seven Colors", color: Colors.purple),
    GameItem(text: "8", icon: "🎱", name: "Eight Ball", color: Colors.black),
    GameItem(text: "9", icon: "☁️", name: "Cloud Nine", color: Colors.blue),
    GameItem(text: "10", icon: "🔟", name: "Ten", color: Colors.blue),
    GameItem(text: "11", icon: "🕚", name: "Eleven O'Clock", color: Colors.orange),
    GameItem(text: "12", icon: "🕛", name: "Twelve O'Clock", color: Colors.blue),
    GameItem(text: "13", icon: "🕵️", name: "Agent 13", color: Colors.black), // Fun
    GameItem(text: "14", icon: "💝", name: "Valentine", color: Colors.pink),
    GameItem(text: "15", icon: "🌕", name: "Full Moon", color: Colors.amber),
    GameItem(text: "16", icon: "🕯️", name: "Sweet 16", color: Colors.purple),
    GameItem(text: "17", icon: "🕺", name: "Dancing 17", color: Colors.blue),
    GameItem(text: "18", icon: "🔞", name: "Adult 18", color: Colors.red), // Maybe replace?
    GameItem(text: "19", icon: "⛳", name: "19th Hole", color: Colors.green),
    GameItem(text: "20", icon: "👓", name: "20/20 Vision", color: Colors.black),

    // --- Animals (20) ---
    GameItem(text: "🐶", icon: "🐕", name: "Dog", color: Colors.brown),
    GameItem(text: "🐱", icon: "🐈", name: "Cat", color: Colors.orange),
    GameItem(text: "🐭", icon: "🧀", name: "Mouse", color: Colors.grey),
    GameItem(text: "🐹", icon: "🌻", name: "Hamster", color: Colors.orangeAccent),
    GameItem(text: "🐰", icon: "🥕", name: "Bunny", color: Colors.pink),
    GameItem(text: "🦊", icon: "🌲", name: "Fox", color: Colors.deepOrange),
    GameItem(text: "🐻", icon: "🍯", name: "Bear", color: Colors.brown),
    GameItem(text: "🐼", icon: "🎋", name: "Panda", color: Colors.black),
    GameItem(text: "🐻‍❄️", icon: "❄️", name: "Polar Bear", color: Colors.cyan),
    GameItem(text: "🐨", icon: "🐨", name: "Koala", color: Colors.grey), // Icon matching itself if needed, or stick
    GameItem(text: "🐮", icon: "🥛", name: "Cow", color: Colors.black),
    GameItem(text: "🐷", icon: "🐽", name: "Pig", color: Colors.pinkAccent),
    GameItem(text: "🐸", icon: "💧", name: "Frog", color: Colors.green),
    GameItem(text: "🐔", icon: "🥚", name: "Chicken", color: Colors.red),
    GameItem(text: "🐦", icon: "🐛", name: "Bird", color: Colors.blue),
    GameItem(text: "🐝", icon: "🍯", name: "Bee", color: Colors.amber),
    GameItem(text: "🐛", icon: "🦋", name: "Caterpillar", color: Colors.green),
    GameItem(text: "🐢", icon: "🏁", name: "Turtle", color: Colors.green),
    GameItem(text: "🦀", icon: "🏖️", name: "Crab", color: Colors.red),
    GameItem(text: "🐙", icon: "🌊", name: "Octopus", color: Colors.purple),

    // --- Fruits (15) ---
    GameItem(text: "🍎", icon: "🥧", name: "Apple Pie", color: Colors.red),
    GameItem(text: "🍌", icon: "🐒", name: "Banana", color: Colors.yellow),
    GameItem(text: "🍇", icon: "🍷", name: "Grape Juice", color: Colors.purple),
    GameItem(text: "🍉", icon: "🏖️", name: "Watermelon", color: Colors.red),
    GameItem(text: "🍊", icon: "🍹", name: "Orange Juice", color: Colors.orange),
    GameItem(text: "🍋", icon: "🧊", name: "Lemonade", color: Colors.yellow),
    GameItem(text: "🍍", icon: "🍕", name: "Pineapple Pizza", color: Colors.amber), // Controversial but distinct!
    GameItem(text: "🥭", icon: "🏝️", name: "Mango", color: Colors.orangeAccent),
    GameItem(text: "🍓", icon: "🍰", name: "Strawberry Cake", color: Colors.redAccent),
    GameItem(text: "🍑", icon: "🍑", name: "Peach", color: Colors.pink),
    GameItem(text: "🍒", icon: "🍨", name: "Cherry Sundae", color: Colors.red),
    GameItem(text: "🥝", icon: "🥗", name: "Kiwi", color: Colors.green),
    GameItem(text: "🍅", icon: "🍝", name: "Tomato Sauce", color: Colors.red),
    GameItem(text: "🥥", icon: "🌴", name: "Coconut", color: Colors.brown),
    GameItem(text: "🥑", icon: "🍞", name: "Avocado Toast", color: Colors.green),

    // --- Vehicles (10) ---
    GameItem(text: "🚗", icon: "🛣️", name: "Car", color: Colors.red),
    GameItem(text: "🚕", icon: "🏙️", name: "Taxi", color: Colors.yellow),
    GameItem(text: "🚌", icon: "🚏", name: "Bus", color: Colors.blue),
    GameItem(text: "🚓", icon: "👮", name: "Police", color: Colors.blueAccent),
    GameItem(text: "🚑", icon: "🏥", name: "Ambulance", color: Colors.red),
    GameItem(text: "🚒", icon: "🔥", name: "Fire Truck", color: Colors.red),
    GameItem(text: "🚲", icon: "🚴", name: "Bicycle", color: Colors.green),
    GameItem(text: "🚀", icon: "🪐", name: "Rocket", color: Colors.grey),
    GameItem(text: "✈️", icon: "☁️", name: "Airplane", color: Colors.blue),
    GameItem(text: "🚢", icon: "⚓", name: "Ship", color: Colors.blue),

    // --- Misc (9) ---
    GameItem(text: "⚽", icon: "🥅", name: "Goal", color: Colors.white),
    GameItem(text: "🏀", icon: "🗑️", name: "Basket", color: Colors.orange),
    GameItem(text: "🏈", icon: "🏟️", name: "Football", color: Colors.brown),
    GameItem(text: "⚾", icon: "🧤", name: "Baseball", color: Colors.white),
    GameItem(text: "🎾", icon: "🎾", name: "Tennis", color: Colors.green), // Icon to self
    GameItem(text: "🎱", icon: "🎱", name: "Pool", color: Colors.black),
    GameItem(text: "🎳", icon: "🎳", name: "Bowling", color: Colors.white),
    GameItem(text: "⛳", icon: "⛳", name: "Golf", color: Colors.green),
    GameItem(text: "🎮", icon: "📺", name: "Video Game", color: Colors.purple),
  ];

  late List<GameItem> _currentLevelItems;
  late List<String> _rightSideItems;
  
  // State
  final Map<String, String> _matches = {}; // Left Text -> Right Icon
  String? _selectedLeft;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _startNewGame();
  }

  void _startNewGame() {
    setState(() {
      var shuffled = List<GameItem>.from(_allGameItems)..shuffle();
      _currentLevelItems = shuffled.take(4).toList();
      
      // Right side is just the icons, shuffled differently
      _rightSideItems = _currentLevelItems.map((e) => e.icon).toList()..shuffle();
      
      _matches.clear();
      _selectedLeft = null;
      _score = 0;
    });
    TtsService().speak("Match the pictures!");
  }

  void _handleLeftTap(String text) {
    if (_matches.containsKey(text)) return; 
    
    setState(() {
      _selectedLeft = text;
    });
    
    // Find the item name to speak
    var item = _currentLevelItems.firstWhere((e) => e.text == text);
    TtsService().speak(item.text); 
  }

  void _handleRightTap(String icon) {
    if (_selectedLeft == null) return;
    
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
              _startNewGame();
            },
            child: const Text("Play Again", style: TextStyle(fontSize: 20)),
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
        title: const Text("Matching Fun"),
        backgroundColor: Colors.pinkAccent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _startNewGame,
          )
        ],
      ),
      body: LayoutBuilder(
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
                  selectedLeft: _selectedLeft,
                ),
              ),
              
              // Items Row
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left Column (A, B, C...)
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: _currentLevelItems.map((item) {
                          bool isSelected = _selectedLeft == item.text;
                          bool isMatched = _matches.containsKey(item.text);
                          
                          return GestureDetector(
                            onTap: () => _handleLeftTap(item.text),
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.yellow : Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isMatched ? Colors.green : (isSelected ? Colors.orange : Colors.pinkAccent), 
                                  width: 4
                                ),
                                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2,2))],
                              ),
                              child: Center(
                                child: Text(
                                  item.text,
                                  style: TextStyle(
                                    fontSize: 40, 
                                    fontWeight: FontWeight.bold,
                                    color: item.color
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
      ),
      bottomNavigationBar: const AdBanner(),
    );
  }
}

class GameItem {
  final String text;
  final String icon;
  final String name;
  final Color color;
  
  GameItem({required this.text, required this.icon, required this.name, required this.color});
}

class LinePainter extends CustomPainter {
  final Map<String, String> matches;
  final List<GameItem> leftItems;
  final List<String> rightItems;
  final String? selectedLeft;

  LinePainter({
    required this.matches, 
    required this.leftItems, 
    required this.rightItems,
    this.selectedLeft
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    // We assume the items are distributed evenly in the available height
    // inside the Padding(20). 
    // Total available height for items = size.height - 40 (padding).
    // But LayoutBuilder gives full size including padding space? 
    // No, LayoutBuilder gives size of the Body. Our Item Column has padding 20.
    
    // Let's approximate center points.
    // There are 4 items. Centers are at (1/(2*4)), (3/(2*4)), etc. of the HEIGHT.
    
    double itemHeightSpace = (size.height - 40) / 4; 
    double leftX = 80; // Approximate center of left item (20 padding + ~40 half width) - rough guess
    double rightX = size.width - 80;

    // Better calculation:
    // With Padding(20), the Column starts at Y=20.
    // The items are spaced evenly 'spaceAround'.
    // Center Y of item i = 20 + itemHeightSpace * i + itemHeightSpace / 2.
    
    // Let's refine X positions based on typical layout
    // Left Column center X is roughly: Padding(20) + (Width of column / 2)?
    // The Row has 2 Expanded columns + SizedBox(50).
    // Total Width = W. 
    // Left Col Width = (W - 40 - 50) / 2.
    // Center Left = 20 + LeftColWidth / 2.
    // Center Right = W - 20 - LeftColWidth / 2.
    
    double colWidth = (size.width - 40 - 50) / 2;
    double startX = 20 + colWidth / 2 + 30; // Edge of the circle
    double endX = size.width - 20 - colWidth / 2 - 30; // Edge of the box
    
    // Draw Matched Lines
    matches.forEach((leftKey, rightIcon) {
      int leftIndex = leftItems.indexWhere((e) => e.text == leftKey);
      int rightIndex = rightItems.indexOf(rightIcon);
      
      if (leftIndex != -1 && rightIndex != -1) {
        double startY = 20 + itemHeightSpace * leftIndex + itemHeightSpace / 2;
        double endY = 20 + itemHeightSpace * rightIndex + itemHeightSpace / 2;
        
        paint.color = Colors.green;
        canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
      }
    });

    // Draw Currently Selected Line (Searching)
    // We can't easily track finger here without Drag info, but we can highlight the starting point?
    // Or just don't draw anything until matched. The prompt image shows lines.
    // Let's skip drawing the "active" line for now as we don't have pointer coordinates from the columns.
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
