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
  int _counter = 0;
  String? _target_word; //initial load -> pull random word from database
  String? _synonym_1; //  target word strongest correlation synonym
  String? _synonym_2; //  target word second strongest correlation synonym
  String? _synonym_3; //  etc.
  String? _synonym_4; //  etc.
  String? _synonym_5; //  etc.
  String? _synonym_6;
  String? _synonym_7;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
        buildSynonym('$_synonym_1')
      ]),
      /*
      body: Center(
        child: Container(
          padding: EdgeInsets.all(12.0), // Padding inside the border
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.black,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(35),
          ),
          child: Text(
            'vocabulary',
            style: GoogleFonts.didactGothic(
              fontSize: 42,
            ),
          ),
        ),
      ),*/

      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Positioned buildSynonym(String synonym) {
    return Positioned(
      top: 100,
      left: 100,
      child: GestureDetector(
        onTap: () {
          _target_changed(synonym);
        },
        child: Text(
          synonym,
          style: GoogleFonts.didactGothic(
            fontSize:
                33, //font size can varry based on correlation level between target word and synonym
          ),
        ),
      ),
    );
  }
}
