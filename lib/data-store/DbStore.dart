import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:markdown_notes_flutter/CardItemModel.dart';
import 'package:markdown_notes_flutter/auth/auth.dart';

class DbStore {
  static Future<List<CardItemModel>> getUserCards() async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    var currentUser = await _auth.currentUser();

    print('uid');
    print(currentUser.uid);

    DocumentReference userCardsReference =
        Firestore.instance.collection('cards').document(currentUser.uid);

    var cardsCollection = await userCardsReference.get();

    print(cardsCollection.data);

    var cards = new List<CardItemModel>();
    if (cardsCollection.data['cards'] != null) {
      for (int loop = 0; loop < cardsCollection.data['cards'].length; loop++) {
        cards.add(CardItemModel.fromStore(cardsCollection.data['cards'][loop]));
      }
    }

    return cards;
  }

  static Future saveUserCards(List<CardItemModel> cards) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = await _auth.currentUser();

    DocumentReference userCardsReference =
        Firestore.instance.collection('cards').document(currentUser.uid);

    var serializedCards = {
      'cards': cards.map((c) => c.toStore()).toList(),
    };

    await userCardsReference.setData(serializedCards);
  }

  static Future<String> getUserName() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = await _auth.currentUser();
    return currentUser.email;
  }
}
