import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
