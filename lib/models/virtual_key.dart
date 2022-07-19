import 'dart:convert';

List<VirtualKey> virtualKeyFromJson(String str) =>
    List<VirtualKey>.from(json.decode(str).map((x) => VirtualKey.fromJson(x)));

String virtualKeyToJson(List<VirtualKey> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VirtualKey {
  VirtualKey({
    required this.id,
    required this.userId,
    required this.activeFrom,
    required this.activeTo,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  int userId;
  DateTime activeFrom;
  DateTime activeTo;
  dynamic? createdAt;
  dynamic? updatedAt;

  factory VirtualKey.fromJson(Map<String, dynamic> json) => VirtualKey(
        id: json["id"],
        userId: json["user_id"],
        activeFrom: DateTime.parse(json["active_from"]),
        activeTo: DateTime.parse(json["active_to"]),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
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
      };
}
