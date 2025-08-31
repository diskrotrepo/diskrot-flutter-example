import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sample/dependency_context.dart';
import 'package:sample/configuration/configuration.dart';

class OAuthCallbackScreen extends StatefulWidget {
  const OAuthCallbackScreen({super.key});

  @override
  State<OAuthCallbackScreen> createState() => _OAuthCallbackScreenState();
}

class _OAuthCallbackScreenState extends State<OAuthCallbackScreen> {
  String? _error;

  @override
  void initState() {
    super.initState();
    _handleCallback();
  }

  Future<void> _handleCallback() async {
    final uri = Uri.base;
    final code = uri.queryParameters['code'];
    final returnedState = uri.queryParameters['state'];
    final error = uri.queryParameters['error'];
    final errorDesc = uri.queryParameters['error_description'];

    if (error != null) {
      setState(
          () => _error = '$error${errorDesc != null ? ": $errorDesc" : ""}');
      return;
    }

    if (code == null || code.isEmpty) {
      setState(() => _error = 'Missing authorization code');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final expectedState = prefs.getString('oauth_state');
    await prefs.remove('oauth_state');
    if (expectedState == null || expectedState != returnedState) {
      setState(() => _error = 'Invalid state');
      return;
    }

    try {
      final cfg = di.get<Configuration>();
      final tokenUri = cfg.secure
          ? Uri.https(cfg.loginUri, '/v1/authentication/token')
          : Uri.http(cfg.loginUri, '/v1/authentication/token');

      final body = {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': cfg.redirectUri,
        'client_id': cfg.applicationId,
      };

      final res = await http.post(
        tokenUri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body.entries
            .map((e) =>
                '${Uri.encodeQueryComponent(e.key)}=${Uri.encodeQueryComponent(e.value)}')
            .join('&'),
      );

      if (res.statusCode != 200) {
        setState(() => _error = 'Token exchange failed (${res.statusCode})');
        return;
      }

      final json = jsonDecode(res.body) as Map<String, dynamic>;
      final accessToken = json['access_token'] as String?;
      final idToken = json['id_token'] as String?;
      final refreshToken = json['refresh_token'] as String?;
      final expiresIn = json['expires_in']?.toString();

      if (accessToken == null) {
        setState(() => _error = 'No access token returned');
        return;
      }

      await prefs.setString('access_token', accessToken);
      if (idToken != null) await prefs.setString('id_token', idToken);
      if (refreshToken != null) {
        await prefs.setString('refresh_token', refreshToken);
      }
      if (expiresIn != null) await prefs.setString('expires_in', expiresIn);

      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/app');
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Unexpected error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _error == null
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
      ),
    );
  }
}
