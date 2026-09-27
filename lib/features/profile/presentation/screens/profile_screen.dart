import 'package:flutter/material.dart';

import '../../../../core/routing/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../progress/data/progress_data.dart';
import '../../../progress/domain/models/skill_progress.dart';
import '../../data/profile_data.dart';
import '../widgets/avatar_with_level_badge.dart';
import '../widgets/profile_stat_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        ProgressManager.instance,
        ProfileData.instance,
      ]),
      builder: (context, _) {
        final manager = ProgressManager.instance;
        final profile = ProfileData.instance.profile;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              IconButton(
                tooltip: 'Settings',
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.settings),
                icon: const Icon(Icons.settings_outlined),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              Center(
                child: ProfileAvatarWithLevelBadge(
                  level: manager.currentLevel,
                  avatarIndex: profile.avatarIndex,
                ),
              ),
              const SizedBox(height: 14),
              Center(
                child: Text(
                  profile.displayName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  profile.email,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  '${manager.currentLevel} • ${manager.currentLevelTitle}',
                  style: const TextStyle(color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  ProfileStatCard(
                    label: 'XP',
                    value: '${manager.progress.xp}',
                    icon: Icons.bolt_outlined,
                  ),
                  const SizedBox(width: 10),
                  ProfileStatCard(
                    label: 'Streak',
                    value: '${manager.progress.currentStreak}',
                    icon: Icons.local_fire_department_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  ProfileStatCard(
                    label: 'Lessons',
                    value: '${manager.progress.lessonsCompleted}',
                    icon: Icons.menu_book_outlined,
                  ),
                  const SizedBox(width: 10),
                  ProfileStatCard(
                    label: 'Vocabulary',
                    value: '${manager.progress.vocabularyLearned}',
                    icon: Icons.translate_outlined,
                  ),
                ],
              ),
              const SizedBox(height: 18),
              OutlinedButton(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.editProfile),
                child: const Text('Edit Profile'),
              ),
              const SizedBox(height: 28),
              const Text(
                'Learning Progress',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...manager.progress.skills.map(_skillTile),
              const SizedBox(height: 18),
              Card(
                color: AppColors.surface,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.settings_outlined,
                        color: AppColors.primary,
                      ),
                      title: const Text('Settings'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.settings),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(
                        Icons.info_outline,
                        color: AppColors.primary,
                      ),
                      title: const Text('About'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.about),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              OutlinedButton(
                onPressed: () => _showLogoutDialog(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                ),
                child: const Text('Log Out'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _skillTile(SkillProgress skill) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skill.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text('${(skill.progress * 100).round()}%'),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: skill.progress,
            minHeight: 7,
            borderRadius: BorderRadius.circular(8),
            color: AppColors.primary,
            backgroundColor: AppColors.divider,
          ),
        ],
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text(
          'You are about to log out of this account. Continue?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
    if (shouldLogout == true && context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
    }
  }
}
