import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:sample/application/app_screen.dart';
import 'package:sample/auth/auth_guard.dart';
import 'package:sample/dependency_context.dart';
import 'package:sample/login/callback_screen.dart';
import 'package:sample/theme.dart';

import 'login/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  await dependencySetup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'diskrot: Sample App',
      theme: AppTheme.theme,
      onGenerateRoute: (settings) {
        final uri = Uri.parse(settings.name ?? '/');
        switch (uri.path) {
          case '/app':
            return MaterialPageRoute(
                builder: (_) => const AuthGuard(child: AppScreen()));
          case '/oauth/callback':
            return MaterialPageRoute(
                builder: (_) => const OAuthCallbackScreen());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/':
          case '/auth-check':
          default:
            return MaterialPageRoute(builder: (_) => const AuthCheckScreen());
        }
      },
    );
  }
}
