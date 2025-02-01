import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'word.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:math';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("\n\nConnected to Firebase App ${app.options.projectId}\n\n");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WordModel(),
      child: MaterialApp(
        title: 'Vocabulate',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<WordModel>(builder: buildScaffold);
  }

  Scaffold buildScaffold(BuildContext context, WordModel wordModel, _) {
    //TODO: add AlignedNodes to the Stack widget dynamically using a 4-loop
    // -> take the target word
    // -> take the 7 highest ranked ( in terms of frequency ) words
    // -> for each word, determine the correlation-to-target-word value
    // -> position word accordingly

    Random random = new Random();
    int randomNumber = random.nextInt(100); // from 0 upto 99 included
    var _target_word = wordModel.items[randomNumber];
    return Scaffold(
        body: Stack(
      children: <Widget>[
        AlignedNode(
            word: _target_word.word,
            top: 0.5,
            left: 0.5), //target word centered
      ],
    ));
  }
}

//TODO: convert Align widget to AnimatedAlign as will be needed when user selects synonym
class AlignedNode extends StatelessWidget {
  const AlignedNode({
    super.key,
    required this.word, //string word value
    required this.top, // double value[ 0 : 1 ], determines Y position
    required this.left, // double value[ 0 : 1 ], determines X position
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
