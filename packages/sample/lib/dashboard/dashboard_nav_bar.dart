import 'package:flutter/material.dart';

class DashboardNavBar extends StatelessWidget {
  final String selected;
  final Function(String) onSelect;

  const DashboardNavBar({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: const Color(0xFF181818),
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Dashboard',
              style: TextStyle(
                color: Colors.pinkAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          _buildNavItem('projects', 'Projects'),
        ],
      ),
    );
  }

  Widget _buildNavItem(String key, String label) {
    final isSelected = selected == key;
    return ListTile(
      dense: true,
      selected: isSelected,
      selectedTileColor: Colors.pinkAccent,
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: () => onSelect(key),
    );
  }
}
