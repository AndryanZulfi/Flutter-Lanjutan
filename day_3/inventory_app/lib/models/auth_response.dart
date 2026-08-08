import 'dart:convert';
import 'user.dart';

class AuthResponse {
  final String? status;
  final String? message;
  final AuthData? data;

  AuthResponse({
    this.status,
    this.message,
    this.data,
  });

  factory AuthResponse.fromRawJson(String str) =>
      AuthResponse.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        status: json['status'] as String?,
        message: json['message'] as String?,
        data: json['data'] == null
            ? null
            : AuthData.fromJson(json['data'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'data': data?.toJson(),
      };
}

class AuthData {
  final User? user;
  final String? token;

  AuthData({
    this.user,
    this.token,
  });

  factory AuthData.fromRawJson(String str) =>
      AuthData.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory AuthData.fromJson(Map<String, dynamic> json) => AuthData(
        user: json['user'] == null
            ? null
            : User.fromJson(json['user'] as Map<String, dynamic>),
        token: json['token'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'user': user?.toJson(),
        'token': token,
      };
}
