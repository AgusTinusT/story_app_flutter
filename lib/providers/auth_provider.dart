import 'package:flutter/material.dart';
import 'package:story_app/models.dart';
import 'package:story_app/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isAuthenticated = false;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> checkAuth() async {
    final token = await _authService.getToken();
    _isAuthenticated = token != null;
    notifyListeners();
  }

  Future<LoginResponse> login(String email, String password) async {
    _setLoading(true);
    final response = await _authService.login(email, password);
    if (!response.error) {
      _isAuthenticated = true;
    }
    _setLoading(false);
    return response;
  }

  Future<RegisterResponse> register(
    String name,
    String email,
    String password,
  ) async {
    _setLoading(true);
    final response = await _authService.register(name, email, password);
    _setLoading(false);
    return response;
  }

  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    notifyListeners();
  }
}
