import 'package:flutter/material.dart';

import 'editor-widget/mdDocument.dart';

class CardItemModel {
  String cardTitle;
  IconData icon;
  int tasksRemaining;
  double taskCompletion;
  List<MdDocument> documents;
  Color color;

  CardItemModel(this.cardTitle, this.icon, this.tasksRemaining,
      this.taskCompletion, this.color) {
    this.documents = new List();
  }

  static CardItemModel fromStore(dynamic card) {
    var cardItemModel = new CardItemModel(card['name'], Icons.account_circle, 9,
        0.0, Color.fromRGBO(231, 129, 109, 1.0));

    for (int loop = 0; loop < card['documents'].length; loop++) {
      cardItemModel.documents.add(MdDocument.fromJson(card['documents'][loop]));
    }

    return cardItemModel;
  }
}
