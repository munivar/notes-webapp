import 'dart:convert';

List<NotesList> languageListFromJson(String str) =>
    List<NotesList>.from(json.decode(str).map((x) => NotesList.fromJson(x)));

String languageListToJson(List<NotesList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NotesList {
  String id;
  String title;
  String text;
  String date;

  NotesList({
    required this.id,
    required this.title,
    required this.text,
    required this.date,
  });

  factory NotesList.fromJson(Map<String, dynamic> json) => NotesList(
        id: json["id"],
        title: json["title"],
        text: json["text"],
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "text": text,
        "date": date,
      };
}
