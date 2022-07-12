import 'dart:convert';

List<Team> teamFromJson(String str) =>
    List<Team>.from(json.decode(str).map((x) => Team.fromJson(x)));

String teamToJson(List<Team> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Team {
  Team({
    required this.id,
    required this.userId,
    required this.name,
    required this.personalTeam,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int userId;
  String name;
  bool personalTeam;
  DateTime createdAt;
  DateTime updatedAt;

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        personalTeam: json["personal_team"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "personal_team": personalTeam,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
