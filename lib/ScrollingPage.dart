import 'package:flutter/material.dart';
import 'CardItemModel.dart';
import 'editor-widget/markdownEditorWidget.dart';
import 'editor-widget/mdDocument.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  var appColors = [
    Color.fromRGBO(231, 129, 109, 1.0),
    Color.fromRGBO(99, 138, 223, 1.0),
    Color.fromRGBO(111, 194, 173, 1.0),
    Color.fromRGBO(231, 129, 109, 1.0),
  ];

  var cardIndex = 0;
  ScrollController scrollController;
  var currentColor = Color.fromRGBO(231, 129, 109, 1.0);

  var cardsList = [
    CardItemModel("Personal", Icons.account_circle, 9, 0.83, Color.fromRGBO(231, 129, 109, 1.0)),
    CardItemModel("Work", Icons.work, 12, 0.24, Color.fromRGBO(99, 138, 223, 1.0)),
    CardItemModel("Home", Icons.home, 7, 0.32, Color.fromRGBO(111, 194, 173, 1.0))
  ];

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
    return new Scaffold(
      backgroundColor: currentColor,
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
      drawer: Drawer(),
      body: new Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 64.0, vertical: 24.0),
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
                      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 12.0),
                      child: Text(
                        "Hello, Kate.",
                        style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    Text(
                      "Looks like feel good.",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "You have 3 tasks to do today.",
                      style: TextStyle(
                        color: Colors.white,
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
                    "TODAY : JUL 21, 2018",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  height: 280.0,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: cardsList.length,
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                  itemBuilder: (context, position) {
                return _buildCard(cardsList[position]);
                // cardsList.map((card) => _buildCard(card));
                },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: new IconButton(padding: EdgeInsets.only(bottom: 35), icon: const Icon(Icons.add_circle), onPressed: _showTextField, color: appColors[(cardIndex+1)%appColors.length], iconSize: 48, ),
    );
  }

  Widget _buildCard(CardItemModel cardItem) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
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
                      Icon(
                        Icons.more_vert,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ...cardItem
                          .documents
                      // TODO: .sort((doc) => doc.editDate)
                          .take(2)
                          .map(
                            (doc) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 1.0),
                            child: _buildMarkdownDocumentRow(doc)),
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
                            horizontal: 8.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("${cardItem.cardTitle}",
                                style: TextStyle(fontSize: 28.0)),
                            Icon(
                              Icons.add,
                              color: Colors.grey,
                            ),
                          ],
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
      onHorizontalDragEnd: _horizontalDragCard,
    );
  }

  _horizontalDragCard(details)
  {
    animationController = AnimationController(vsync: this,
        duration: Duration(milliseconds: 500));
    curvedAnimation = CurvedAnimation(
        parent: animationController,
        curve: Curves.fastOutSlowIn);
    animationController.addListener(() {
      setState(() {
        currentColor =
            colorTween.evaluate(curvedAnimation);
      });
    });
    bool animate = false;
    if (details.velocity.pixelsPerSecond.dx > 0) {
      if (cardIndex > 0) {
        animate = true;
        cardIndex--;
        colorTween = ColorTween(begin: currentColor,
            end: appColors[cardIndex%3]);
      }
    } else {
      if (cardIndex < cardsList.length - 1) {
        animate = true;
        cardIndex++;
        colorTween = ColorTween(begin: currentColor,
            end: appColors[cardIndex%3]);
      }
    }

    if(animate)
    {
      setState(() {
        scrollController.animateTo((cardIndex) * 256.0,
            duration: Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn);
      });
      colorTween.animate(curvedAnimation);
      animationController.forward();
    }
  }

  void _deleteCard()
  {
    setState(() {
      cardsList.removeAt(cardIndex);
      if(cardIndex > cardsList.length)
        cardIndex--;
    });
  }

  void _showTextField()
  {
    _showDialog();
  }

  _showDialog() async {
    final myController = TextEditingController();
    await showDialog<String>(
      context: context,
      builder: (context) =>
      new AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Product'),
                controller: myController,
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              }),
          new FlatButton(
              child: const Text('ADD'),
              onPressed: () {
                setState(() {
                  if (myController.text.length > 0)
                    cardsList.add(CardItemModel(myController.text, Icons.account_circle, 9, 0.83, appColors[0]));
                });
                Navigator.pop(context);
              })
        ],
      ),
    );
  }



  Widget _buildMarkdownDocumentRow(MdDocument document) {
    // final bool alreadyDone = item.done;

    return new ListTile(
      title: new Text(document.name, style: TextStyle(fontSize: 20.0)
          // style: alreadyDone ? _lineThrough : _biggerFont,
          ),
      trailing: new Icon(
        // Add the lines from here...
        Icons.edit,
        color: Colors.orange,
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
}
