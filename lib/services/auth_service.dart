import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:story_app/models.dart';

class AuthService {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1';
  final _storage = const FlutterSecureStorage();

  Future<RegisterResponse> register(
    String name,
    String email,
    String password,
  ) async {
    final url = Uri.parse('$_baseUrl/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    return RegisterResponse.fromJson(jsonDecode(response.body));
  }

  Future<LoginResponse> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final loginResponse = LoginResponse.fromJson(jsonDecode(response.body));

    if (!loginResponse.error) {
      await _saveToken(loginResponse.loginResult!.token);
    }
    return loginResponse;
  }

  Future<void> _saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }
}
