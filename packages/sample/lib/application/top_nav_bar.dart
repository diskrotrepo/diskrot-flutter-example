import 'package:flutter/material.dart';

class TopNavBar extends StatelessWidget {
  final String currentProjectId;
  final String currentProjectName;
  final void Function(String view) onNavigate;
  final VoidCallback onLogout;
  final String currentView;

  const TopNavBar({
    super.key,
    required this.currentProjectId,
    required this.currentProjectName,
    required this.onNavigate,
    required this.onLogout,
    required this.currentView,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle tabStyle(bool active) => TextStyle(
          color: Colors.white,
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
        );

    return Container(
      height: 56,
      color: const Color(0xFF121212),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Text('diskrot',
              style: const TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          const Spacer(),
          TextButton(
            onPressed: () => onNavigate('dashboard'),
            child:
                Text('Dashboard', style: tabStyle(currentView == 'dashboard')),
          ),
          TextButton(
            onPressed: onLogout,
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
