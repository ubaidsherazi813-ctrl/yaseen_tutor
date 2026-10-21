import 'package:flutter/material.dart';

/// Grammar ki qism ke rang aur naam. DB mein kind: ism | fil | harf | zameer
const kindColors = <String, Color>{
  'ism': Color(0xFF1E6FD9),
  'fil': Color(0xFF1E9E5A),
  'harf': Color(0xFFD64545),
  'zameer': Color(0xFFE58A1F),
};

const kindLabels = <String, String>{
  'ism': 'Ism',
  'fil': 'Fe’l',
  'harf': 'Harf',
  'zameer': 'Zameer',
};

Color kindColor(String kind) => kindColors[kind] ?? Colors.grey;
String kindLabel(String kind) => kindLabels[kind] ?? kind;

const avatars = ['🧕', '👳', '🧑‍🎓', '👦', '👧', '🌙', '📖', '🕌'];
