import 'package:flutter/material.dart';

class Project {
  final String id;
  final String name;
  final String description;
  final DateTime created;

  Project({
    required this.id,
    required this.name,
    required this.description,
    required this.created,
  });
}

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key, required this.onProjectSelect});

  final ValueChanged<String> onProjectSelect;

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  bool _creating = false;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    setState(() {
      _nameController.clear();
      _descController.clear();
    });
  }

  void _createProject() async {
    final name = _nameController.text.trim();
    final description = _descController.text.trim();

    if (name.isEmpty) return;

    setState(() => _creating = true);

    try {
      setState(() {
        _nameController.clear();
        _descController.clear();
      });
    } catch (e) {
      debugPrint('Error creating project: $e');
    } finally {
      setState(() => _creating = false);
    }
  }

  void _deleteProject(String id) async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Projects',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _nameController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Project Name',
            labelStyle: const TextStyle(color: Colors.white70),
            filled: true,
            fillColor: Colors.grey[850],
            border: InputBorder.none,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _descController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Description',
            labelStyle: const TextStyle(color: Colors.white70),
            filled: true,
            fillColor: Colors.grey[850],
            border: InputBorder.none,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _creating ? null : _createProject,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
          child: _creating
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : const Text('Create Project',
                  style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
