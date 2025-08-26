import 'package:flutter/material.dart';
import 'package:sample/application/top_nav_bar.dart';
import 'package:sample/auth/auth_repository.dart';
import 'package:sample/dashboard/dashboard_nav_bar.dart';
import 'package:sample/dashboard/projects_section.dart';
import 'package:sample/dependency_context.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  String _currentView = 'dashboard';
  String _selectedSubSection = 'projects';
  String? _currentProjectId;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    setState(() {});
  }

  void _onSectionChange(String view, String subSection) {
    setState(() {
      _currentView = view;
      _selectedSubSection = subSection;
    });
  }

  void _onLogout() async {
    await di<AuthRepository>().logout();

    if (!mounted) {
      return;
    }

    Navigator.pushReplacementNamed(context, '/login');
  }

  void _onProjectSelect(String id) {
    setState(() {
      _currentProjectId = id;
      _currentView = 'project';
      _selectedSubSection = 'general';
    });
  }

  late final Map<String, Map<String, WidgetBuilder>> sectionRegistry = {
    'dashboard': {
      'projects': (_) => ProjectsSection(onProjectSelect: _onProjectSelect),
    },
  };

  @override
  Widget build(BuildContext context) {
    final currentProjectName = 'default';
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          TopNavBar(
            currentProjectId: _currentProjectId ?? '',
            currentProjectName: currentProjectName,
            currentView: _currentView,
            onNavigate: (view) {
              final defaultSub = sectionRegistry[view]?.keys.first ?? '';
              _onSectionChange(view, defaultSub);
            },
            onLogout: _onLogout,
          ),
          Expanded(
            child: Row(
              children: [
                _buildNav(),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    color: const Color(0xFF1E1E1E),
                    child: _buildSectionContent(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNav() {
    switch (_currentView) {
      case 'dashboard':
      default:
        return DashboardNavBar(
          selected: _selectedSubSection,
          onSelect: (sub) => _onSectionChange('dashboard', sub),
        );
    }
  }

  Widget _buildSectionContent() {
    final builder = sectionRegistry[_currentView]?[_selectedSubSection];
    if (builder == null) return const SizedBox();
    return builder(context);
  }
}
