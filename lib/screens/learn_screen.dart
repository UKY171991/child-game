import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:child_game/services/tts_service.dart';
import 'package:child_game/widgets/speakable_text.dart';
import 'package:child_game/utils/number_helper.dart';

class LearnScreen extends StatelessWidget {
  final List<String> alphabets = List.generate(26, (index) => String.fromCharCode(index + 65));
  final List<String> numberList = List.generate(100, (index) => (index + 1).toString());
  final List<String> tableList = List.generate(20, (index) => (index + 1).toString());

  LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const SpeakableText('Let\'s Learn!'),
          bottom: const TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            tabs: [
              Tab(icon: Icon(Icons.abc), text: 'Alphabet'),
              Tab(icon: Icon(Icons.numbers), text: 'Numbers'),
              Tab(icon: Icon(Icons.grid_view), text: 'Tables'), // Changed icon
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildGrid(alphabets, Colors.orange),
            _buildGrid(numberList, Colors.purple),
            _buildTablesGrid(context, tableList, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(List<String> items, Color color) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          color: color.withAlpha(204),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: InkWell(
            onTap: () {
               // Check if item is a number to speak it as words
               if (int.tryParse(items[index]) != null) {
                 TtsService().speak(intToWords(int.parse(items[index])));
               } else {
                 TtsService().speak(items[index]);
               }
            },
            child: Center(
              child: Text(
                items[index],
                style: const TextStyle(
                  fontSize: 60,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ).animate().scale(delay: (50 * index).ms).fadeIn();
      },
    );
  }

  Widget _buildTablesGrid(BuildContext context, List<String> items, Color color) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          color: color.withAlpha(204),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: InkWell(
            onTap: () {
               _showTableDialog(context, index + 1);
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   const Text("Table", style: TextStyle(color: Colors.white, fontSize: 16)),
                   Text(
                    items[index],
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).animate().scale(delay: (50 * index).ms).fadeIn();
      },
    );
  }

  void _showTableDialog(BuildContext context, int number) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Table of $number",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: 10,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    int multiplier = index + 1;
                    int result = number * multiplier;
                    String text = "$number x $multiplier = $result";
                    String speakText = "$number times $multiplier is $result";

                    return ListTile(
                      title: Text(
                        text, 
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        TtsService().speak(speakText);
                      },
                      trailing: const Icon(Icons.volume_up, color: Colors.grey),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
