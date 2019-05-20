import 'package:flutter/material.dart';
import 'editor-widget/markdownEditorWidget.dart';
import 'editor-widget/mdDocument.dart';
import 'editor-widget/lookupWidget.dart';
import 'cardDisplayArgs.dart';

class CardDisplay extends StatefulWidget {

  final CardDisplayArgs arguments;

  @override
  _CardDisplayState createState() => new _CardDisplayState(arguments);

  CardDisplay(this.arguments);
}


class _CardDisplayState extends State<CardDisplay> {

  Color currentColor;
  String title;
  List<MdDocument> documents;

  _CardDisplayState(CardDisplayArgs arguments)
  {
    currentColor = arguments.color;
    title = arguments.title;
    documents = arguments.documents;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: currentColor,
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text(
          title,
          style: TextStyle(fontSize: 16.0),
        ),
        backgroundColor: currentColor,
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
          ),
        ],
        elevation: 0.0,
      ),
      body: new Center(
        child: Column(
          children: <Widget>[
            Padding(
            padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ...documents
                // TODO: .sort((doc) => doc.editDate)
                    .take(2)
                    .map(
                      (doc) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 1.0),
                      child: _buildMarkdownDocumentRow(doc)),
                ),
              ],
            ),
          )],
        ),
      ),
    );
  }

  Widget _buildMarkdownDocumentRow(MdDocument document) {
    // final bool alreadyDone = item.done;

    return new ListTile(

      title: new Text(document.name, style: TextStyle(fontSize: 20.0)
        // style: alreadyDone ? _lineThrough : _biggerFont,
      ),
      trailing: new IconButton(
        // Add the lines from here...
        icon: new Icon(Icons.pageview),
        onPressed: () { _lookup(document); },
      ),
      onTap: () async {
        await Navigator.of(context).push(new MaterialPageRoute(
          builder: (context) => MarkdownEditorWidget(document),
        ));
      },
      contentPadding: EdgeInsets.only(bottom: 0.0),
      dense: true,
    );
  }

  void _lookup(document) async{
    var lookupDoc = new MdDocument();
    lookupDoc.content = document.content == null ? "" : document.content;
    Navigator.of(context).push(new MaterialPageRoute(
      builder: (context) => MarkdownLookupWidget(lookupDoc),
    ));
  }
}
