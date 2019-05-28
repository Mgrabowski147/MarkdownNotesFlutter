import 'package:flutter/material.dart';
import 'package:markdown_notes_flutter/auth/auth.dart';
import 'package:markdown_notes_flutter/cardDisplay.dart';
import 'package:markdown_notes_flutter/editor-widget/lookupWidget.dart';
import 'CardItemModel.dart';
import 'data-store/DbStore.dart';
import 'editor-widget/markdownEditorWidget.dart';
import 'editor-widget/mdDocument.dart';
import 'cardDisplayArgs.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => new _HomePageState();

}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {

  var appColors = [
    Color.fromRGBO(231, 129, 109, 1.0),
    Color.fromRGBO(99, 138, 223, 1.0),
    Color.fromRGBO(111, 194, 173, 1.0),
  ];

  var cardIndex = 0;
  ScrollController scrollController;
  var currentColor = Color.fromRGBO(231, 129, 109, 1.0);

  List<CardItemModel> cardsList = null;

  // [
  //   CardItemModel("Personal", Icons.account_circle, 9, 0.83,
  //       Color.fromRGBO(231, 129, 109, 1.0)),

  // ];

  AnimationController animationController;
  ColorTween colorTween;
  CurvedAnimation curvedAnimation;

  @override
  void initState() {
    super.initState();
    scrollController = new ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    // var signIntoFirebase = Auth.signIntoFirebase();
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
        body: new Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 64.0, vertical: 24.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Icon(
                          Icons.account_circle,
                          size: 45.0,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 12.0),
                        child: Text(
                          "Hello.",
                          style: TextStyle(
                              fontSize: 30.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 64.0, vertical: 8.0),
                    child: Text(
                      "Today : " + DateTime.now().toIso8601String().substring(0, 10),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    height: 280.0,
                    child: new FutureBuilder(
                      future: _getData(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                          case ConnectionState.waiting:
                            return new Text('loading...');
                          default:
                            if (snapshot.hasError)
                              return new Text('Error: ${snapshot.error}');
                            else {
                              // cardsList = snapshot.data;
                              // print(snapshot.data);
                              var cardsWigets =
                                  cardsList.map(_buildCard).toList();
                              cardsWigets.add(_newCardButton());

                              return new ListView(
                                  children: cardsWigets,
                                  controller: scrollController,
                                  // physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.horizontal);

                              return ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: cardsList.length,
                                controller: scrollController,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, position) {
                                  return _buildCard(cardsList[position]);
                                  // cardsList.map((card) => _buildCard(card));
                                },
                              );
                            }
                        }
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  Future<List<CardItemModel>> _getData() async {
    print('Future<List<CardItemModel>> _getData() called');

    if (cardsList != null) {
      return cardsList;
    }

    // var futureCardsList = [
    //   CardItemModel("Personal", Icons.account_circle, 9, 0.83,
    //       Color.fromRGBO(231, 129, 109, 1.0)),
    //   CardItemModel(
    //       "Work", Icons.work, 12, 0.24, Color.fromRGBO(99, 138, 223, 1.0)),
    //   CardItemModel(
    //       "Home", Icons.home, 7, 0.32, Color.fromRGBO(111, 194, 173, 1.0)),
    // ];
    // cardsList = futureCardsList;

    cardsList = await DbStore.getUserCards();

    return cardsList;
  }

  Widget _buildCard(CardItemModel cardItem) {
    return GestureDetector(
      child: new Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Card(
          child: Container(
            width: 250.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        cardItem.icon,
                        color: cardItem.color,
                      ),
                      // new IconButton(
                      //   icon: Icon(
                      //     Icons.more_vert,
                      //     color: Colors.grey,
                      //   ),
                      //   onPressed: () async {
                      //     print('on pressed');
                      //     await _onLongPressCard(cardItem);
                      //   },
                      // )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ...cardItem.documents
                          // TODO: .sort((doc) => doc.editDate)
                          .take(2)
                          .map(
                            (doc) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 1.0),
                                child:
                                    _buildMarkdownDocumentRow(cardItem, doc)),
                          ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Text(
                          "${cardItem.documents.length} Markdown documents",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 8.0),
                        child: new ListTile(
                          trailing: Icon(
                            Icons.add,
                            color: Colors.grey,
                          ),
                          title: Text("${cardItem.cardTitle}",
                              style: TextStyle(fontSize: 28.0)),
                          onTap: () async {
                            // TODO get new guid and push to db

                            var document = new MdDocument();
                            document.name = "New markdown document";

                            final documentAfterEdit =
                                await Navigator.of(context)
                                    .push<MdDocument>(new MaterialPageRoute(
                              builder: (context) =>
                                  MarkdownEditorWidget(document),
                            ));

                            if (documentAfterEdit != null) {
                              setState(() async {
                                cardItem.documents.add(documentAfterEdit);

                                await DbStore.saveUserCards(cardsList);
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
      //   onHorizontalDragEnd: _horizontalDragCard,
      onLongPressStart: (details) async {
        setState(() {
          _onLongPressCard(cardItem, details);
        });
        await DbStore.saveUserCards(cardsList);
      },
      onTap: () async {
        await Navigator.of(context).push(new MaterialPageRoute(
          builder: (context) => CardDisplay(new CardDisplayArgs(
              cardsList, cardItem)),
        ));
      },
    );
  }

  Widget _newCardButton() {
    return
        //  GestureDetector(
        //   child:
        new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Card(
        child: Container(
          width: 250.0,
          child: new IconButton(
            icon: const Icon(Icons.add, size: 80, color: Colors.grey),
            onPressed: () async {
              String newCardTitle = await _addNewCard();
              print(newCardTitle);
              setState(() {
                cardsList.add(new CardItemModel(newCardTitle, Icons.ac_unit, 0,
                    0.32, Color.fromRGBO(111, 194, 173, 1.0)));
              });
              await DbStore.saveUserCards(cardsList);
            },
          ),
          // child: Column(
          //   Padding(
          //     padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
          //   ),
          // ),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
    //   onHorizontalDragEnd: _horizontalDragCard,
    // onLongPressStart: (details) async {
    //   await _onLongPressCard(cardItem, details);
    // },
    // onTap: () async {
    //   await Navigator.of(context).push(new MaterialPageRoute(
    //     builder: (context) => CardDisplay(new CardDisplayArgs(
    //         cardItem.color, cardItem.cardTitle, cardItem.documents)),
    //   ));
    // },
    // );
  }

  final popupButtonKey = GlobalKey<
      State>(); // We use `State` because Flutter libs do not export `PopupMenuButton` state specifically.

  final List<PopupMenuEntry> menuEntries = [
    PopupMenuItem(
      value: 1,
      child: Text('One'),
    ),
    PopupMenuItem(
      value: 2,
      child: Text('Two'),
    ),
  ];

  _onLongPressCard(cardItem, details) {
    List<String> choices = ["Delete", "Edit"];
    showMenu(
      position: RelativeRect.fromLTRB(details.globalPosition.dx,
          details.globalPosition.dy, details.globalPosition.dx, 0),
      items: <PopupMenuEntry>[
        PopupMenuItem(
          value: 0,
          child: Row(
            children: <Widget>[
              Icon(Icons.delete),
              Text("Delete"),
            ],
          ),
        ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: <Widget>[
              Icon(Icons.edit),
              Text("Edit"),
            ],
          ),
        )
      ],
      context: context,
    ).then((onValue) {
      switch (onValue) {
        case 0:
          _deleteCard(cardItem);
          break;
        case 1:
          _editCard(cardItem);
          break;
      }
    });
  }

  _horizontalDragCard(details) {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    curvedAnimation = CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn);
    animationController.addListener(() {
      setState(() {
        currentColor = colorTween.evaluate(curvedAnimation);
      });
    });
    bool animate = false;
    if (details.velocity.pixelsPerSecond.dx > 0) {
      if (cardIndex > 0) {
        animate = true;
        cardIndex--;
        colorTween =
            ColorTween(begin: currentColor, end: appColors[cardIndex % 3]);
      }
    } else {
      if (cardIndex < cardsList.length - 1) {
        animate = true;
        cardIndex++;
        colorTween =
            ColorTween(begin: currentColor, end: appColors[cardIndex % 3]);
      }
    }

    if (animate) {
      setState(() {
        scrollController.animateTo((cardIndex) * 256.0,
            duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
      });
      colorTween.animate(curvedAnimation);
      animationController.forward();
    }
  }

  Future _deleteCard(card) {
    setState(() {
      cardsList.remove(card);
      if (cardIndex > cardsList.length) cardIndex--;
    });
  }

  Future _editCard(CardItemModel card) async {
    final myController = TextEditingController();
    myController.text = card.cardTitle;
    await showDialog<String>(
      context: context,
      builder: (context) => new AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                    autofocus: true,
                    decoration: new InputDecoration(labelText: 'Title'),
                    controller: myController,
                  ),
                )
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('Save'),
                  onPressed: () {
                    setState(() {
                      if (myController.text.length > 0)
                        card.cardTitle = myController.text;
                    });
                    Navigator.pop(context);
                  })
            ],
          ),
    );
  }

  Future<String> _addNewCard() async {
    final myController = TextEditingController();
    return await showDialog<String>(
      context: context,
      builder: (context) => new AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: new Row(
              children: <Widget>[
                new Expanded(
                  child: new TextField(
                    autofocus: true,
                    decoration: new InputDecoration(labelText: 'Product'),
                    controller: myController,
                  ),
                )
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop<String>(context, null);
                  }),
              new FlatButton(
                  child: const Text('ADD'),
                  onPressed: () {
                    Navigator.pop<String>(context, myController.text);
                  })
            ],
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

  // LOGGING IN
  var mUser;
  var mUserName;
  var isLoggingIn = false;

  Future clickLogin() async {
    //Set isLoggingIn to true at the start of clicking Login
    setState(() {
      isLoggingIn = true;
    });

    mUser = await loginWithGoogle().catchError((e) => setState(() {
          isLoggingIn = false;
        }));
    assert(mUser != null);

    setState(() {
      isLoggingIn = false;
      mUserName = mUser.displayName;
    });
  }
}
