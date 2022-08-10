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
    required this.teamCode,
  });

  int id;
  int userId;
  String name;
  bool personalTeam;
  DateTime createdAt;
  DateTime updatedAt;
  String teamCode;

  @override
  bool operator ==(Object other) => other is Team && other.name == name;

  @override
  int get hashCode => name.hashCode;

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        personalTeam: json["personal_team"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        teamCode: json["team_code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "name": name,
        "personal_team": personalTeam,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "team_code": teamCode,
      };
}
