class MdDocument{
  String uuid;
  String content = "";
  String name;

  MdDocument();

  factory MdDocument.fromJson(dynamic json){
    var document = MdDocument();
    document.content = json['content'];
    document.name = json['name'];
    document.uuid = json['uuid'];

    return document;
  }
}