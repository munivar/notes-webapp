class NotesList {
  String id;
  String title;
  String text;
  String date;
  bool isDeleted;
  String noteColor;

  NotesList({
    required this.id,
    required this.title,
    required this.text,
    required this.date,
    required this.isDeleted,
    required this.noteColor,
  });

  factory NotesList.fromJson(Map<String, dynamic> json) => NotesList(
      id: json["id"],
      title: json["title"],
      text: json["text"],
      date: json["date"],
      isDeleted: json["isDeleted"],
      noteColor: json["noteColor"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "text": text,
        "date": date,
        "isDeleted": isDeleted,
        "noteColor": noteColor,
      };
}
