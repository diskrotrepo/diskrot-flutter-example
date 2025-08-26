import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sample/auth/auth_repository.dart';
import 'package:sample/dependency_context.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiskRotHttpClient {
  final String baseUrl;

  DiskRotHttpClient(this.baseUrl);

  Future<http.Response> get({required String endpoint}) async {
    final idToken = await di<AuthRepository>().getIdToken();

    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken'
      },
    );

    if (response.statusCode == 403) {
      await _refreshIdToken();
      return await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken'
        },
      );
    }

    return response;
  }

  Future<http.Response> post(
      {required String endpoint, required Map<String, dynamic> data}) async {
    final idToken = await di<AuthRepository>().getIdToken();

    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken'
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 403) {
      await _refreshIdToken();
      return await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken'
        },
        body: jsonEncode(data),
      );
    }

    return response;
  }

  Future<http.Response> put(
      {required String endpoint, required Map<String, dynamic> data}) async {
    final idToken = await di<AuthRepository>().getIdToken();

    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken'
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 403) {
      await _refreshIdToken();
      return await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken'
        },
        body: jsonEncode(data),
      );
    }

    return response;
  }

  Future<http.Response> delete({required String endpoint}) async {
    final idToken = await di<AuthRepository>().getIdToken();

    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken'
      },
    );

    if (response.statusCode == 403) {
      await _refreshIdToken();
      return await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $idToken'
        },
      );
    }

    return response;
  }

  Future<void> _refreshIdToken() async {
    await http
        .post(
      Uri.parse('$baseUrl/authentication/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'refreshToken': await di<AuthRepository>().getRefreshToken()}),
    )
        .then((refreshResponse) {
      if (refreshResponse.statusCode == 200) {
        final body = jsonDecode(refreshResponse.body);
        SharedPreferences.getInstance().then((prefs) {
          prefs.setString('idToken', body['id_token']);
          prefs.setString('accessToken', body['access_token']);
          prefs.setString('refreshToken', body['refresh_token']);
          prefs.setString('expiresIn', body['expires_in']);
        });
      } else {
        throw Exception('Failed to refresh token');
      }
    });
  }
}
