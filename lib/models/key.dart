import 'dart:convert';

List<Key> keyFromJson(String str) =>
    List<Key>.from(json.decode(str).map((x) => Key.fromJson(x)));

String keyToJson(List<Key> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Key {
  Key({
    required this.id,
    required this.userId,
    required this.activeFrom,
    required this.activeTo,
    this.createdAt,
    this.updatedAt,
    required this.pivot,
  });

  int id;
  int userId;
  DateTime activeFrom;
  DateTime activeTo;
  dynamic createdAt;
  dynamic updatedAt;
  Pivot pivot;

  factory Key.fromJson(Map<String, dynamic> json) => Key(
        id: json["id"],
        userId: json["user_id"],
        activeFrom: DateTime.parse(json["active_from"]),
        activeTo: DateTime.parse(json["active_to"]),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        pivot: Pivot.fromJson(json["pivot"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "active_from":
            "${activeFrom.year.toString().padLeft(4, '0')}-${activeFrom.month.toString().padLeft(2, '0')}-${activeFrom.day.toString().padLeft(2, '0')}",
        "active_to":
            "${activeTo.year.toString().padLeft(4, '0')}-${activeTo.month.toString().padLeft(2, '0')}-${activeTo.day.toString().padLeft(2, '0')}",
        "created_at": createdAt,
        "updated_at": updatedAt,
        "pivot": pivot.toJson(),
      };
}

class Pivot {
  Pivot({
    required this.gateId,
    required this.virtualKeyId,
  });

  int gateId;
  int virtualKeyId;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        gateId: json["gate_id"],
        virtualKeyId: json["virtual_key_id"],
      );

  Map<String, dynamic> toJson() => {
        "gate_id": gateId,
        "virtual_key_id": virtualKeyId,
      };
}
