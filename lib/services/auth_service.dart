import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:story_app/models.dart';

class AuthService {
  // URL dasar dari API kita
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1';
  final _storage = const FlutterSecureStorage();

  // Fungsi untuk Register
  Future<RegisterResponse> register(
    String name,
    String email,
    String password,
  ) async {
    final url = Uri.parse('$_baseUrl/register');

    // Body request yang akan dikirim dalam format JSON
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    // Decode response body
    return RegisterResponse.fromJson(jsonDecode(response.body));
  }

  // Fungsi untuk Login
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

  // Fungsi untuk menyimpan token menggunakan SharedPreferences
  Future<void> _saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  // Fungsi untuk mengambil token (bisa digunakan nanti untuk cek sesi)
  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  // Fungsi untuk Logout
  Future<void> logout() async {
    await _storage.delete(key: 'token');
  }
}
