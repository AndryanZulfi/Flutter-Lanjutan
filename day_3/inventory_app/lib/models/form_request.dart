import 'dart:convert';

class FormRequest {
  final num? id;
  final String? name;
  final int? stock;
  final String? imageBase64;

  FormRequest({
    this.id,
    this.name,
    this.stock,
    this.imageBase64,
  });

  factory FormRequest.fromRawJson(String str) =>
      FormRequest.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory FormRequest.fromJson(Map<String, dynamic> json) => FormRequest(
        id: json['id'] as num?,
        name: json['name'] as String?,
        stock: json['stock'] as int?,
        imageBase64: json['image_base64'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'stock': stock,
        'image_base64': imageBase64,
      };
}
