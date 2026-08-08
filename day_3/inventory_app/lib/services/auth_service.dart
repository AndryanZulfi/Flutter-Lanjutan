import 'package:http/http.dart' as http;

import '../models/auth_request.dart';
import '../models/auth_response.dart';
import 'endpoint.dart';

class AuthService {
  Future<AuthResponse> register(AuthRequest request) async {
    try {
      final response = await http.post(
        Uri.parse(Endpoint.REGISTER),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: request.toRawJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse.fromRawJson(response.body);
      } else {
        try {
          return AuthResponse.fromRawJson(response.body);
        } catch (_) {
          throw Exception(
              'Failed to register (${response.statusCode}): ${response.reasonPhrase}');
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<AuthResponse> login(AuthRequest request) async {
    try {
      final response = await http.post(
        Uri.parse(Endpoint.LOGIN),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: request.toRawJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse.fromRawJson(response.body);
      } else {
        try {
          return AuthResponse.fromRawJson(response.body);
        } catch (_) {
          throw Exception(
              'Failed to login (${response.statusCode}): ${response.reasonPhrase}');
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
