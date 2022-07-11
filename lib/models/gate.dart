import 'dart:convert';

List<Gate> gateFromJson(String str) =>
    List<Gate>.from(json.decode(str).map((x) => Gate.fromJson(x)));

String gateToJson(List<Gate> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Gate {
  Gate({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  int userId;
  int id;
  String title;
  String? body;

  factory Gate.fromJson(Map<String, dynamic> json) => Gate(
        userId: json["userId"],
        id: json["id"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "id": id,
        "title": title,
        "body": body,
      };
}
