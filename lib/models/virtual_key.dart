import 'dart:convert';

List<VirtualKey> virtualKeyFromJson(String str) =>
    List<VirtualKey>.from(json.decode(str).map((x) => VirtualKey.fromJson(x)));

String virtualKeyToJson(List<VirtualKey> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VirtualKey {
  VirtualKey({
    required this.id,
    required this.label,
    required this.userId,
    required this.validDays,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String label;
  int userId;
  String validDays;
  DateTime createdAt;
  DateTime updatedAt;

  factory VirtualKey.fromJson(Map<String, dynamic> json) => VirtualKey(
        id: json["id"],
        label: json["label"],
        userId: json["user_id"],
        validDays: json["valid_days"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "label": label,
        "user_id": userId,
        "valid_days": validDays,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
