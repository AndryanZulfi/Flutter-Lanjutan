import 'package:flutter/material.dart';
import '../../models/auth_request.dart';
import '../../models/auth_response.dart';
import '../../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider(this._authService);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String name = "";
  String email = "";
  String password = "";
  String confirmPassword = "";

  final formKey = GlobalKey<FormState>();

  Future<AuthResponse?> login() async {
    setIsLoading(true);
    try {
      final request = AuthRequest(
        email: email,
        password: password,
      );
      final response = await _authService.login(request);
      return response;
    } catch (e) {
      rethrow;
    } finally {
      setIsLoading(false);
    }
  }

  Future<AuthResponse?> register() async {
    setIsLoading(true);
    try {
      final request = AuthRequest(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: confirmPassword,
      );
      final response = await _authService.register(request);
      return response;
    } catch (e) {
      rethrow;
    } finally {
      setIsLoading(false);
    }
  }
}
