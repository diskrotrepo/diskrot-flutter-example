import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sample/configuration/configuration.dart';
import 'package:sample/dependency_context.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  AuthRepository({required this.baseUrl});

  final String baseUrl;

  Future<http.Response> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/authentication/login'),
      headers: {
        'Content-Type': 'application/json',
        "DiskRot-API-Key": di<Configuration>().apiKey,
      },
      body: jsonEncode({'email': email, 'password': password}),
    );
    final body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString('idToken', body['idToken']);
        prefs.setString('refreshToken', body['refreshToken']);
        prefs.setString('email', body['email']);
        prefs.setString('expiresIn', body['expiresIn']);
        prefs.setString('displayName', body['displayName']);
      });
    } else {
      throw Exception('Failed to login: ${body['message']}');
    }

    return response;
  }

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
    await prefs.remove('idToken');
    await prefs.remove('refreshToken');
    await prefs.remove('email');
    await prefs.remove('expiresIn');
    await prefs.remove('displayName');
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
