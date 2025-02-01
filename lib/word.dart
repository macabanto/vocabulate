import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Word {
  late String id;
  String word;
  int taps;

  Word({required this.word, required this.taps});
  Word.fromJson(Map<String, dynamic> json, this.id)
      : word = json['word'],
        taps = json['taps'];
  Map<String, dynamic> toJson() => {'word': word, 'taps': taps};
}

class WordModel extends ChangeNotifier {
  final List<Word> items = [];
  CollectionReference wordsCollection =
      FirebaseFirestore.instance.collection('movies');
  bool loading = false;

  WordModel() {
    fetch();
  }

  Future fetch() async {
    items.clear();
    loading = true;
    notifyListeners(); //tell children to redraw, and they will see that the loading indicator is on
    var querySnapshot = await wordsCollection.get();
    for (var doc in querySnapshot.docs) {
      var word = Word.fromJson(doc.data()! as Map<String, dynamic>, doc.id);
      items.add(word);
    }
    //artificially increase the load time, so we can see the loading indicator (when we add it in a few steps time)
    await Future.delayed(const Duration(seconds: 2));
    //we're done, no longer loading
    loading = false;
    update();
  }

  // This call tells the widgets that are listening to this model to rebuild.
  void update() {
    notifyListeners();
  }

  Word? get(String? id) {
    if (id == null) return null;
    return items.firstWhere((movie) => movie.id == id);
  }
}
