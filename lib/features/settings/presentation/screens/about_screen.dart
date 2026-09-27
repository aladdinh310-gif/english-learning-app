import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Icon(Icons.school_outlined, color: AppColors.primary, size: 72),
          const SizedBox(height: 18),
          const Center(
            child: Text(
              'English Learning App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Learn English through:',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Text(
            '• Reading\n• Vocabulary\n• Grammar\n• Listening\n• Speaking\n• Quizzes',
          ),
          const SizedBox(height: 28),
          const Center(
            child: Text(
              'Built with Flutter',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
