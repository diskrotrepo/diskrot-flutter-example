import 'package:flutter/material.dart';
import 'package:sample/application/app_screen.dart';
import 'package:sample/auth/auth_guard.dart';
import 'package:sample/dependency_context.dart';
import 'package:sample/theme.dart';

import 'login/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dependencySetup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'diskrot: Sample App',
      initialRoute: '/auth-check',
      theme: AppTheme.theme,
      onGenerateRoute: (settings) {
        if (settings.name == '/app') {
          return MaterialPageRoute(
              builder: (context) => const AuthGuard(child: AppScreen()));
        }
        return null;
      },
      routes: {
        '/auth-check': (context) => const AuthCheckScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
      },
    );
  }
}
