import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Synonym Network',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String _targetWord = "happy";
  final List<String> _words = [
    "happy",
    "joyful",
    "content",
    "cheerful",
    "pleased",
    "glad",
    "delighted",
    "upbeat"
  ];

  final List<List<int>> _associationMatrix = [
    [0, 7, 5, 6, 4, 6, 3, 4], // happy
    [7, 0, 4, 6, 3, 5, 4, 5], // joyful
    [5, 4, 0, 5, 4, 3, 2, 3], // content
    [6, 6, 5, 0, 5, 6, 4, 5], // cheerful
    [4, 3, 4, 5, 0, 4, 3, 3], // pleased
    [6, 5, 3, 6, 4, 0, 3, 4], // glad
    [3, 4, 2, 4, 3, 3, 0, 2], // delighted
    [4, 5, 3, 5, 3, 4, 2, 0], // upbeat
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Synonym Network"),
        centerTitle: true,
      ),
      body: Stack(
        children: _generateSynonymNodes(),
      ),
    );
  }

  List<Widget> _generateSynonymNodes() {
    final positionedWords = calculateWordPositions(_words, _associationMatrix);

    return positionedWords.map((p) {
      return AlignedNode(
        word: p.word,
        top: p.y,
        left: p.x,
      );
    }).toList();
  }
}

class AlignedNode extends StatelessWidget {
  final String word;
  final double top;
  final double left;

  const AlignedNode({
    super.key,
    required this.word,
    required this.top,
    required this.left,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset(left, top),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black87, width: 2),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: Text(
          word,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class PositionedWord {
  final String word;
  final double x;
  final double y;

  PositionedWord(this.word, this.x, this.y);
}

List<PositionedWord> calculateWordPositions(
    List<String> words, List<List<int>> associationMatrix,
    {double paddingFraction = 0.1}) {
  final int n = words.length;
  final double padding = paddingFraction; // 10% padding around edges
  final double scale = 1 - (2 * padding); // remaining usable area

  final List<Offset> positions = List.generate(n, (_) => Offset.zero);
  final double angleStep = 2 * pi / (n - 1); // circular layout for synonyms

  positions[0] = const Offset(0.5, 0.5); // Center the main word

  for (int i = 1; i < n; i++) {
    double strength = associationMatrix[0][i].toDouble();
    double distance = 0.2 + (1 - (strength / 7)) * 0.3; // distance from center
    double angle = angleStep * (i - 1);

    double x = 0.5 + distance * cos(angle);
    double y = 0.5 + distance * sin(angle);

    // Clamp to avoid overflow
    x = x.clamp(0.0 + padding, 1.0 - padding);
    y = y.clamp(0.0 + padding, 1.0 - padding);

    positions[i] = Offset(x, y);
  }

  return List.generate(n, (i) {
    return PositionedWord(
      words[i],
      positions[i].dx,
      positions[i].dy,
    );
  });
}
