import 'package:flutter/material.dart';
import 'CardItemModel.dart';
import 'editor-widget/markdownEditorWidget.dart';
import 'editor-widget/mdDocument.dart';
import 'cardDisplayArgs.dart';

class CardDisplay extends StatefulWidget {

  CardDisplayArgs args;

  @override
  _CardDisplayState createState() => new _CardDisplayState(args);

  CardDisplay(arg)
  {
    args = arg;
  }
}


class _CardDisplayState extends State<CardDisplay> {

  Color currentColor;


  _CardDisplayState(CardDisplayArgs argument)
  {
    currentColor = argument.color;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: currentColor,
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text(
          "Markdown Notes",
          style: TextStyle(fontSize: 16.0),
        ),
        backgroundColor: currentColor,
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(Icons.search),
          ),
        ],
        elevation: 0.0,
      ),
    );
  }
}
