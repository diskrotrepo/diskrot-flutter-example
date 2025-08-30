import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sample/configuration/configuration.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:watch_it/watch_it.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _error = '';

  // Optional: CSRF state helper
  String _csrfState([int length = 32]) {
    final r = Random.secure();
    final bytes = List<int>.generate(length, (_) => r.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  Future<void> _login() async {
    late Uri authUri;

    if (di.get<Configuration>().secure) {
      authUri = Uri.https(di.get<Configuration>().loginUri, '/authorize', {
        'client_id': di.get<Configuration>().applicationId,
        'redirect_uri': di.get<Configuration>().redirectUri,
        'response_type': 'code',
      });
    } else {
      authUri = Uri.http(di.get<Configuration>().loginUri, '/authorize', {
        'client_id': di.get<Configuration>().applicationId,
        'redirect_uri': di.get<Configuration>().redirectUri,
        'response_type': 'code',
      });
    }

    final ok = await launchUrlString(
      authUri.toString(),
      webOnlyWindowName: '_self',
    );

    if (!ok && mounted) {
      setState(() => _error = 'Could not open login page');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // Right half (single login button)
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
