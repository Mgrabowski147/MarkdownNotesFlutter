import 'package:flutter/material.dart';

import 'editor-widget/mdDocument.dart';

class CardItemModel {
  String cardTitle;
  IconData icon;
  int tasksRemaining;
  double taskCompletion;
  List<MdDocument> documents;
  Color color;

  CardItemModel(
      this.cardTitle, this.icon, this.tasksRemaining, this.taskCompletion, this.color) {
    this.documents = new List();
    var mockDocument = new MdDocument();
    mockDocument.name = "doc name";
    this.documents.add(mockDocument);

    var mockDocument2 = new MdDocument();
    mockDocument2.name = "doc name";
    this.documents.add(mockDocument2);
  }
}
