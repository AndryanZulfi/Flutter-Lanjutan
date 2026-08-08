import 'dart:convert';

class Item {
  final int? id;
  final int? userId;
  final String? name;
  final int? stock;
  final String? imageBase64;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Item({
    this.id,
    this.userId,
    this.name,
    this.stock,
    this.imageBase64,
    this.createdAt,
    this.updatedAt,
  });

  factory Item.fromRawJson(String str) =>
      Item.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json['id'] as int?,
        userId: json['user_id'] as int?,
        name: json['name'] as String?,
        stock: json['stock'] as int?,
        imageBase64: json['image_base64'] as String?,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.tryParse(json['created_at'].toString()),
        updatedAt: json['updated_at'] == null
            ? null
            : DateTime.tryParse(json['updated_at'].toString()),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'stock': stock,
        'image_base64': imageBase64,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
      };
}
