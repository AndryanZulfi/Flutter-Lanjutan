import 'dart:convert';
import 'item.dart';

class FormResponse {
  final String? status;
  final String? message;
  final Item? data;

  FormResponse({
    this.status,
    this.message,
    this.data,
  });

  factory FormResponse.fromRawJson(String str) =>
      FormResponse.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory FormResponse.fromJson(Map<String, dynamic> json) => FormResponse(
        status: json['status'] as String?,
        message: json['message'] as String?,
        data: json['data'] == null
            ? null
            : Item.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}
