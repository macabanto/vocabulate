import 'dart:ffi';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vocabulate',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _target_word; // Starts as null until fetched
  List<String> _synonyms = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  void toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear(); // Clear input when closing search
      }
    });
  }

  void onSearchSubmitted(String query) {
    fetchTargetWord(query.trim());
    toggleSearch();
  }

  @override
  void initState() {
    super.initState();
    fetchTargetWord('vocabulary'); // Fetch data when the widget is created
  }

  Future<void> fetchTargetWord(String word) async {
    try {
      // Fetch a specific word by ID (change 'exampleWord' to whatever word you need)
      String targetWordId = word; // Change to the word ID you want to fetch
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('wordnet')
          .doc(targetWordId)
          .get();

      if (docSnapshot.exists) {
        List<String> allSynonyms =
            List<String>.from(docSnapshot['synonyms'] ?? []);
        setState(() {
          _target_word = docSnapshot.id;
          _synonyms = allSynonyms.length > 7
              ? allSynonyms.take(7).toList()
              : allSynonyms;
        });

        // Now fetch synonyms for each synonym and compare
        compareSynonyms();
      } else {
        print("Word '$targetWordId' not found in Firestore.");
      }
    } catch (e) {
      print("Error fetching target word: $e");
    }
  }

  Future<void> compareSynonyms() async {
    Set<String> targetSynonymsSet =
        _synonyms.toSet(); // Convert to Set for fast lookup

    for (String synonym in _synonyms) {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('wordnet')
          .doc(synonym)
          .get();

      if (docSnapshot.exists) {
        List<String> synonymList =
            List<String>.from(docSnapshot['synonyms'] ?? []);
        Set<String> synonymSet = synonymList.toSet();

        // Find the intersection (shared words)
        Set<String> sharedSynonyms = targetSynonymsSet.intersection(synonymSet);
        print(
            "Shared synonyms between '$_target_word' and '$synonym': ${sharedSynonyms.length}");
      } else {
        print("No synonyms found for '$synonym'");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("vocabulate"),
        centerTitle: true,
        leadingWidth: _isSearching ? 200.0 : 40.0,
        leading: GestureDetector(
          onTap: () {
            toggleSearch();
            print(_isSearching);
          },
          child: AnimatedContainer(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20),
            ),
            duration: Duration(
              milliseconds: 200,
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          if (_target_word != null) // Only show when the word is fetched
            AlignedNode(
              word: _target_word!,
              top: 0.5,
              left: 0.5,
            ),
          ..._generateSynonymNodes(), // Generate synonym nodes dynamically
        ],
      ),
    );
  }

// Generate AlignedNode widgets for each synonym with unique positions
  List<Widget> _generateSynonymNodes() {
    List<Widget> nodes = [];

    const double phi = 1.618; // Golden Ratio
    const distance = 0.1; //minimum distance between synonyms
    const xcenter = 0.5;
    const ycenter = 0.5;
    var xprev = xcenter;
    var xnext = xcenter;
    var yprev = ycenter;
    var ynext = ycenter;
    var theta = 0.0;
    var offset = 0.0;
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    double x_y_size = sqrt(pow(width, 2) + pow(height, 2));
    for (int i = 0; i < _synonyms.length; i++) {
      //loop thru each synonym
      do {
        theta += (pi / 180);
        xnext = cos(theta) * distance * (1 + ((phi * 2 * theta) / pi));
        ynext = sin(theta) * distance * (1 + ((phi * 2 * theta) / pi));
        offset = sqrt(
            pow(width * (xprev - xnext), 2) + pow(height * (yprev - ynext), 2));
      } while (offset < distance * x_y_size);
      nodes.add(AlignedNode(
        word: _synonyms[i],
        top: ynext + ycenter,
        left: xnext + xcenter,
      ));
      offset = 0.0;
      xprev = xnext;
      yprev = ynext;
    }
    return nodes;
  }
}

//TODO: convert Align widget to AnimatedAlign as will be needed when user selects synonym
class AlignedNode extends StatelessWidget {
  const AlignedNode({
    super.key,
    required this.word,
    required this.top,
    required this.left,
  });

  final String word;
  final double top;
  final double left;
  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: FractionalOffset(top, left),
        child: Container(
            padding: EdgeInsets.all(12.0), // Padding inside the border
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
                width: 3,
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Text(word,
                style: GoogleFonts.didactGothic(
                  fontSize: 24,
                ))));
  }
}

class Word {
  final String? word;
  final List<String>? synonyms;

  Word({
    this.word,
    this.synonyms,
  });

  factory Word.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Word(
      word: snapshot.id, //word is id
      synonyms:
          data?['regions'] is Iterable ? List.from(data?['synonyms']) : null,
    );
  }
}
