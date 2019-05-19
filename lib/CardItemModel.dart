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
  }
}
