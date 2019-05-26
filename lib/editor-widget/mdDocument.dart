class MdDocument {
  String uuid = "2488f0cc-3cec-4a95-ae40-aed475c48e2e";
  String content = "";
  String name;

  MdDocument();

  factory MdDocument.fromJson(dynamic json) {
    var document = MdDocument();
    document.content = json['content'];
    document.name = json['name'];
    document.uuid = json['uuid'];

    return document;
  }

  Map<String, dynamic> toStore() => {
        'content': content,
        'name': name,
        'uuid': uuid,
      };
}
