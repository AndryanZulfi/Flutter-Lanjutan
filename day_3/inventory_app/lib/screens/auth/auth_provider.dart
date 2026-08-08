import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/auth_request.dart';
import '../../models/auth_response.dart';
import '../../services/auth_service.dart';
import '../../utils/helper.dart';

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

  Future<void> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString(Helper.NAME) ?? '';
    notifyListeners();
  }

  Future<AuthResponse?> login() async {
    setIsLoading(true);
    try {
      final request = AuthRequest(
        email: email,
        password: password,
      );
      final response = await _authService.login(request);

      // Simpan token, status login, dan name ke SharedPreferences (session)
      final token = response.data?.token;
      final userName = response.data?.user?.name;

      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(Helper.TOKEN, token);
        await prefs.setBool(Helper.IS_LOGIN, true);
        if (userName != null) {
          await prefs.setString(Helper.NAME, userName);
          name = userName;
        }
      }

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
