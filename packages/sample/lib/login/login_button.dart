import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sample/configuration/configuration.dart';
import 'package:sample/dependency_context.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

SizedBox loginButton(
    {required Color backgroundColor, required Color textColor}) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: loginAction,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 10),
      ),
      child: Text(
        'login with diskrot',
        style: TextStyle(
          fontSize: 16,
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}

String _csrfState([int length = 32]) {
  final r = Random.secure();
  final bytes = List<int>.generate(length, (_) => r.nextInt(256));
  return base64Url.encode(bytes).replaceAll('=', '');
}

Future<void> loginAction() async {
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

  await launchUrlString(
    authUri.toString(),
    webOnlyWindowName: '_self',
  );
}
