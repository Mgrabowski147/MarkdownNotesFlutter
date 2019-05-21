import 'package:flutter/material.dart';
import 'editor-widget/mdDocument.dart';

class CardDisplayArgs {
  Color color;
  String title;
  List<MdDocument> documents;

  CardDisplayArgs(color, title, documents)
  {
    this.color = color;
    this.title = title;
    this.documents = documents;
  }
}