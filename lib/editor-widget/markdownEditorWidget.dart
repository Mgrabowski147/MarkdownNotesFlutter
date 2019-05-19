import 'package:flutter/material.dart';

import 'lookupWidget.dart';
import 'mdDocument.dart';

class MarkdownEditorWidget extends StatefulWidget {
  final MdDocument mdDocument;

  MarkdownEditorWidget(this.mdDocument);

  @override
  MarkdownEditorState createState() => new MarkdownEditorState();
}

class MarkdownEditorState extends State<MarkdownEditorWidget> {
  TextEditingController _documentNameController = TextEditingController();
  TextEditingController _documentContentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _documentNameController.text = widget.mdDocument.name;
    _documentContentController.text = widget.mdDocument.content;

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Editor'),
        actions: <Widget>[
          new IconButton(
              icon: const Icon(Icons.pageview), onPressed: _lookup),
          new IconButton(icon: const Icon(Icons.save), onPressed: _saveItem),
        ],
      ),
      body: new ListView(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        children: [
          new Form(
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'My new markdown document',
                labelText: 'Document\'s name',
              ),
              keyboardType: TextInputType.text,
              controller: _documentNameController,
            ),
          ),
          new Form(
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: '# Markdown title',
                labelText: 'Markdown text',
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: _documentContentController,
            ),
          ),
        ],
      ),
    );
  }

  void _deleteItem() {
    // final _deleteTodoItem = new TodoItem("deleteItem", false, -1);

    Navigator.of(context).pop();

    // Navigator.of(context).pop(_deleteTodoItem);
  }

  void _lookup() async{
    var lookupDoc = new MdDocument();
    lookupDoc.content = _documentContentController.text;
    await Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => MarkdownLookupWidget(lookupDoc),
          ));
  }

  void _saveItem() {
    // final String _content = _todoItemContentController.text;

    print(_documentContentController.text);
    // final _todoItem =
    //     new TodoItem(_content, widget.editItem.done, widget.editItem.id);

    // Navigator.of(context).pop(_todoItem);
    Navigator.of(context).pop();
  }
}
