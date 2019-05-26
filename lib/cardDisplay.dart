import 'package:flutter/material.dart';
import 'CardItemModel.dart';
import 'data-store/DbStore.dart';
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
  List<CardItemModel> cardsList;
  CardItemModel openCard;

  _CardDisplayState(CardDisplayArgs arguments) {
    currentColor = arguments.openCard.color;
    title = arguments.openCard.cardTitle;
    openCard = arguments.openCard;
    cardsList = arguments.cardsList;
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
          new IconButton(
            icon: new Icon(Icons.add),
            onPressed: () async {
              // TODO get new guid and push to db

              var document = new MdDocument();
              document.name = "New markdown document";

              final documentAfterEdit = await Navigator.of(context)
                  .push<MdDocument>(new MaterialPageRoute(
                builder: (context) => MarkdownEditorWidget(document),
              ));

              if (documentAfterEdit != null) {
                setState(() async {
                  openCard.documents.add(documentAfterEdit);

                  await DbStore.saveUserCards(cardsList);
                });
              }
            },
          )
        ],
        elevation: 0.0,
      ),
      body: new Center(
        child: Card(
          child: ListView(
            children: <Widget>[
              ...openCard.documents
                  // TODO: .sort((doc) => doc.editDate)
                  .map(
                (doc) => Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 1.0),
                    child: _buildMarkdownDocumentRow(openCard, doc)),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Text(
                  "${openCard.documents.length} Markdown documents",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    );
  }

  Widget _buildMarkdownDocumentRow(
      CardItemModel cardItem, MdDocument document) {
    // final bool alreadyDone = item.done;

    return new ListTile(
      title: new Text(document.name, style: TextStyle(fontSize: 20.0)
          // style: alreadyDone ? _lineThrough : _biggerFont,
          ),
      trailing: new Icon(
        // Add the lines from here...
        Icons.search,
        color: Colors.orange,
      ),
      onTap: () async {
        await Navigator.of(context).push<MdDocument>(new MaterialPageRoute(
          builder: (context) => MarkdownLookupWidget(document),
        ));
      },
      onLongPress: () async {
        // TODO push changes to db

        final documentAfterEdit =
            await Navigator.of(context).push<MdDocument>(new MaterialPageRoute(
          builder: (context) => MarkdownEditorWidget(document),
        ));
        if (documentAfterEdit != null) {
          setState(() {
            cardItem.documents.remove(document);
            cardItem.documents.add(documentAfterEdit);
          });
          await DbStore.saveUserCards(cardsList);
        }
      },
      contentPadding: EdgeInsets.only(bottom: 0.0),
      dense: true,
    );
  }

  void _lookup(document) async {
    var lookupDoc = new MdDocument();
    lookupDoc.content = document.content == null ? "" : document.content;
    Navigator.of(context).push(new MaterialPageRoute(
      builder: (context) => MarkdownLookupWidget(lookupDoc),
    ));
  }
}
