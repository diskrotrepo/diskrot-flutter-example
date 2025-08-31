import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sample/configuration/configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:watch_it/watch_it.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _error = '';

  String _csrfState([int length = 32]) {
    final r = Random.secure();
    final bytes = List<int>.generate(length, (_) => r.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  Future<void> _login() async {
    late Uri authUri;
    final cfg = di.get<Configuration>();

    final state = _csrfState();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('oauth_state', state);

    final qp = {
      'client_id': cfg.applicationId,
      'redirect_uri': cfg.redirectUri,
      'response_type': 'code',
      'state': state,
    };

    if (cfg.secure) {
      authUri = Uri.https(cfg.loginUri, '/authorize', qp);
    } else {
      authUri = Uri.http(cfg.loginUri, '/authorize', qp);
    }

    final ok = await launchUrlString(
      authUri.toString(),
      webOnlyWindowName: '_self',
    );

    if (!ok && mounted) setState(() => _error = 'Could not open login page');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'diskrot',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'sample app',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text(
                          'login with diskrot',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (_error.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          _error,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
