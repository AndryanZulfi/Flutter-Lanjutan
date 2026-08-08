import 'dart:convert';

class AuthRequest {
  final String? name;
  final String email;
  final String password;
  final String? passwordConfirmation;

  AuthRequest({
    this.name,
    required this.email,
    required this.password,
    this.passwordConfirmation,
  });

  factory AuthRequest.fromRawJson(String str) =>
      AuthRequest.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  factory AuthRequest.fromJson(Map<String, dynamic> json) => AuthRequest(
        name: json['name'] as String?,
        email: json['email'] as String? ?? '',
        password: json['password'] as String? ?? '',
        passwordConfirmation: json['password_confirmation'] as String?,
      );

  Map<String, dynamic> toJson() => {
        if (name != null) 'name': name,
        'email': email,
        'password': password,
        if (passwordConfirmation != null)
          'password_confirmation': passwordConfirmation,
      };
}
