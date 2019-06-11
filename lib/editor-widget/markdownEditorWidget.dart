import 'package:flutter/material.dart';
import 'package:markdown_notes_flutter/data-store/DbStore.dart';

import 'lookupWidget.dart';
import 'mdDocument.dart';

class MarkdownEditorWidget extends StatefulWidget {
  final MdDocument mdDocument;
  MdDocument editMdDocument;
  final Color bgColor;

  MarkdownEditorWidget(this.mdDocument, this.bgColor) {
    this.editMdDocument = new MdDocument();
    this.editMdDocument.content = this.mdDocument.content;
    this.editMdDocument.name = this.mdDocument.name;
    this.editMdDocument.uuid = this.mdDocument.uuid;
  }

  @override
  MarkdownEditorState createState() => new MarkdownEditorState(bgColor);
}

class MarkdownEditorState extends State<MarkdownEditorWidget> {
  TextEditingController _documentNameController = TextEditingController();
  TextEditingController _documentContentController = TextEditingController();
  final Color bgColor;

  MarkdownEditorState(this.bgColor);

  @override
  Widget build(BuildContext context) {
    _documentNameController.text = widget.editMdDocument.name;
    _documentContentController.text = widget.editMdDocument.content;

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Editor'),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.pageview), onPressed: _lookup),
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

  void _lookup() async {
    var lookupDoc = this.widget.editMdDocument;
    lookupDoc.content = _documentContentController.text;
    lookupDoc.name = _documentNameController.text;

    // await new DbStore().updateUserData();

    await Navigator.of(context).push(new MaterialPageRoute(
      builder: (context) => MarkdownLookupWidget(lookupDoc, bgColor),
    ));
  }

  void _saveItem() {
    print(_documentContentController.text);

    this.widget.editMdDocument.content = _documentContentController.text;
    this.widget.editMdDocument.name = _documentNameController.text;

    Navigator.of(context).pop(this.widget.editMdDocument);
  }
}
