import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'mdDocument.dart';

class MarkdownLookupWidget extends StatefulWidget {
  final MdDocument mdDocument;
  final Color bgColor;
  MarkdownLookupWidget(this.mdDocument, this.bgColor);

  @override
  MarkdownLookupState createState() => new MarkdownLookupState(bgColor);
}

class MarkdownLookupState extends State<MarkdownLookupWidget> {

  MarkdownLookupState(this.bgColor);
  Color bgColor;

  @override
  Widget build(BuildContext context) {
    // _documentNameController.text = widget.mdDocument.name;
    // _documentContentController.text = widget.mdDocument.content;
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: bgColor,
        title: const Text('Editor'),
        // actions: <Widget>[
        //   new IconButton(
        //       icon: const Icon(Icons.pageview), onPressed: _lookup),
        //   new IconButton(icon: const Icon(Icons.save), onPressed: _saveItem),
        // ],
      ),
      body: new Markdown(data: widget.mdDocument.content)
    );
  }
}
