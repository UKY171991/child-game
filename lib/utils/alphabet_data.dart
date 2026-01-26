
import 'package:flutter/material.dart';

class AlphabetItem {
  final String letter;
  final String word;
  final String icon;
  final Color color;
  final String? audioText;

  AlphabetItem({
    required this.letter, 
    required this.word, 
    required this.icon,
    required this.color,
    this.audioText,
  });
}

final List<AlphabetItem> alphabetData = [
  AlphabetItem(letter: "A", word: "Apple", icon: "🍎", color: Colors.red),
  AlphabetItem(letter: "B", word: "Ball", icon: "⚽", color: Colors.blue),
  AlphabetItem(letter: "C", word: "Cat", icon: "🐱", color: Colors.orange),
  AlphabetItem(letter: "D", word: "Dog", icon: "🐶", color: Colors.brown),
  AlphabetItem(letter: "E", word: "Elephant", icon: "🐘", color: Colors.grey),
  AlphabetItem(letter: "F", word: "Fish", icon: "🐟", color: Colors.blueAccent),
  AlphabetItem(letter: "G", word: "Grapes", icon: "🍇", color: Colors.purple),
  AlphabetItem(letter: "H", word: "Hen", icon: "🐔", color: Colors.brown),
  AlphabetItem(letter: "I", word: "Ice Cream", icon: "🍦", color: Colors.pink),
  AlphabetItem(letter: "J", word: "Jug", icon: "🏺", color: Colors.orangeAccent),
  AlphabetItem(letter: "K", word: "Kite", icon: "🪁", color: Colors.teal),
  AlphabetItem(letter: "L", word: "Lion", icon: "🦁", color: Colors.orange),
  AlphabetItem(letter: "M", word: "Monkey", icon: "🐵", color: Colors.brown),
  AlphabetItem(letter: "N", word: "Nest", icon: "🪺", color: Colors.green),
  AlphabetItem(letter: "O", word: "Orange", icon: "🍊", color: Colors.orange),
  AlphabetItem(letter: "P", word: "Parrot", icon: "🦜", color: Colors.lightGreen),
  AlphabetItem(letter: "Q", word: "Queen", icon: "👑", color: Colors.purpleAccent),
  AlphabetItem(letter: "R", word: "Rabbit", icon: "🐰", color: Colors.grey),
  AlphabetItem(letter: "S", word: "Sun", icon: "☀️", color: Colors.orange),
  AlphabetItem(letter: "T", word: "Tiger", icon: "🐯", color: Colors.orangeAccent),
  AlphabetItem(letter: "U", word: "Umbrella", icon: "☂️", color: Colors.blue),
  AlphabetItem(letter: "V", word: "Van", icon: "🚐", color: Colors.indigo),
  AlphabetItem(letter: "W", word: "Watch", icon: "⌚", color: Colors.blueGrey),
  AlphabetItem(letter: "X", word: "Xylophone", icon: "🎹", color: Colors.pink),
  AlphabetItem(letter: "Y", word: "Yak", icon: "🐂", color: Colors.brown),
  AlphabetItem(letter: "Z", word: "Zebra", icon: "🦓", color: Colors.black),
];
