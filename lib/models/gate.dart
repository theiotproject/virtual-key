import 'dart:convert';

List<Gate> gateFromJson(String str) =>
    List<Gate>.from(json.decode(str).map((x) => Gate.fromJson(x)));

String gateToJson(List<Gate> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Gate {
  Gate({
    required this.id,
    required this.serialNumber,
    required this.name,
    required this.teamId,
    required this.updatedAt,
    required this.createdAt,
  });

  int id;
  String serialNumber;
  String name;
  int teamId;
  DateTime updatedAt;
  DateTime createdAt;

  factory Gate.fromJson(Map<String, dynamic> json) => Gate(
        id: json["id"],
        serialNumber: json["serial_number"],
        name: json["name"],
        teamId: json["team_id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "serial_number": serialNumber,
        "name": name,
        "team_id": teamId,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
      };
}
