import 'package:flutter/material.dart';
import 'package:sample/auth/auth_repository.dart';
import 'package:sample/dependency_context.dart';

class LoggedInScreen extends StatelessWidget {
  const LoggedInScreen({super.key});

  Future<void> _signOut(BuildContext context) async {
    di<AuthRepository>().logout();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // white screen
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Logged in',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => _signOut(context),
              icon: const Icon(Icons.logout, color: Colors.black),
              label:
                  const Text('Log out', style: TextStyle(color: Colors.black)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
