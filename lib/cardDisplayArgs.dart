import 'package:flutter/material.dart';
import 'package:markdown_notes_flutter/CardItemModel.dart';
import 'editor-widget/mdDocument.dart';

class CardDisplayArgs {
  // Color color;
  // String title;
  // List<MdDocument> documents;
  List<CardItemModel> cardsList;
  CardItemModel openCard;

  CardDisplayArgs(List<CardItemModel> cardsList, CardItemModel openCard) {
    this.cardsList = cardsList;
    this.openCard = openCard;
    // this.color = color;
    // this.title = title;
    // this.documents = documents;
  }
}
