import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
  @override
  String _target_word = 'target word';
  String _synonym_1 = 'synonym 1';
  String _synonym_2 = 'synonym 2';
  String _synonym_3 = 'synonym 3';
  String _synonym_4 = 'synonym 4';
  String _synonym_5 = 'synonym 5';
  String _synonym_6 = 'synonym 6';
  String _synonym_7 = 'synonym 7';

  Widget build(BuildContext context) {
    // Retrieve the size of the screen
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
//TODO : find a way to turn correlation between two synonyms into a 2Dimensional scale ( show correlation by spacing between words! )
//impossible to do on 2D between ALL words, however can be computed when simply iterating thru list of synonomyms compared to target word!
//we want to make the positioning to take up the whole screen, and be unique
    return Scaffold(
        body: Stack(
      children: <Widget>[
        StackChildAligned(
            word: '$_target_word', top: 0.5, left: 0.5), //target word centered
        StackChildAligned(
          word: '$_synonym_1',
          top: 0.7,
          left: 0.7,
        ), //
        StackChildAligned(
          word: '$_synonym_2',
          top: 0.3,
          left: 0.3,
        ),
        StackChildAligned(
          word: '$_synonym_3',
          top: 0.8,
          left: 0.2,
        ), //
        StackChildAligned(
          word: '$_synonym_4',
          top: 0.2,
          left: 0.8,
        ), //
        StackChildAligned(
          word: '$_synonym_5',
          top: 0.9,
          left: 0.4,
        ),
        StackChildAligned(
          word: '$_synonym_6',
          top: 0.1,
          left: 0.6,
        ), //
        StackChildAligned(
          word: '$_synonym_7',
          top: 0.9,
          left: 0.9,
        ),
      ],
    ));
  }
}

//TODO: convert Align widget to AnimatedAlign as will be needed when user selects synonym
class StackChildAligned extends StatelessWidget {
  const StackChildAligned({
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
