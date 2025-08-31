import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  AuthRepository({required this.baseUrl});

  final String baseUrl;

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  Future<String?> getIdToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('idToken');
  }

  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('id_token');
    await prefs.remove('refresh_token');
    await prefs.remove('email');
    await prefs.remove('expires_in');
    await prefs.remove('display_name');
  }

  Future<http.Response> register(String email, String password) {
    return http.post(
      Uri.parse('$baseUrl/authentication/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
  }

  Future<http.Response> forgotPassword(String email) {
    return http.post(
      Uri.parse('$baseUrl/authentication/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );
  }
}
