import 'dart:convert';

List<Gate> gateFromJson(String str) =>
    List<Gate>.from(json.decode(str).map((x) => Gate.fromJson(x)));

String gateToJson(List<Gate> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Gate {
  Gate({
    required this.id,
    required this.name,
    required this.serialNumber,
    required this.magicCode,
    required this.teamId,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String name;
  String serialNumber;
  String magicCode;
  int teamId;
  dynamic createdAt;
  dynamic updatedAt;

  factory Gate.fromJson(Map<String, dynamic> json) => Gate(
        id: json["id"],
        name: json["name"],
        serialNumber: json["serial_number"],
        magicCode: json["magic_code"],
        teamId: json["team_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "serial_number": serialNumber,
        "magic_code": magicCode,
        "team_id": teamId,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
