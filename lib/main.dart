import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _target_word =
      'target-word'; //initial load -> pull random word from database
  String? _synonym_1 =
      "synonym 1"; //  target word strongest correlation synonym
  String? _synonym_2 =
      "synonym 2"; //  target word second strongest correlation synonym
  String? _synonym_3 = "synonym 3"; //  etc.
  String? _synonym_4 = "synonym 4"; //  etc.
  String? _synonym_5 = "synonym 5"; //  etc.
  String? _synonym_6 = "synonym 6";
  String? _synonym_7 = "synonym 7";

  void _target_changed(String new_target) {
    setState(() {
      _target_word = new_target;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      //as per Lindsay's rec, use the Stack() Widget..
      //..with positioned child widgets
      body: Stack(children: <Widget>[
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              '$_target_word',
              style: GoogleFonts.didactGothic(
                fontSize: 39,
              ),
            ),
          ),
        ),
        buildSynonym('$_synonym_1', 100, 10),
        buildSynonym('$_synonym_2', 100, 30),
        buildSynonym('$_synonym_3', 200, 350),
        buildSynonym('$_synonym_4', 350, 350),
        buildSynonym('$_synonym_5', 550, 250),
        buildSynonym('$_synonym_6', 400, 100),
        buildSynonym('$_synonym_7', 600, 100),
      ]),
    );
  }

  Positioned buildSynonym(String synonym, double top, double left) {
    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: () {
          _target_changed(synonym);
        },
        child: Container(
          padding: EdgeInsets.all(12.0), // Padding inside the border
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Text(
            synonym,
            style: GoogleFonts.didactGothic(
              fontSize:
                  33, //font size can varry based on correlation level between target word and synonym
            ),
          ),
        ),
      ),
    );
  }
}
