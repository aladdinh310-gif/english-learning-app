import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ProfileAvatarWithLevelBadge extends StatelessWidget {
  const ProfileAvatarWithLevelBadge({
    super.key,
    required this.level,
    required this.avatarIndex,
    this.radius = 46,
  });

  final String level;
  final int avatarIndex;
  final double radius;

  static const _icons = [
    Icons.person,
    Icons.face,
    Icons.emoji_people,
    Icons.school,
    Icons.auto_awesome,
  ];

  @override
  Widget build(BuildContext context) {
    final icon = _icons[avatarIndex.clamp(0, _icons.length - 1)];
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: AppColors.primary.withValues(alpha: 0.14),
          child: Icon(icon, color: AppColors.primary, size: radius * 1.05),
        ),
        Positioned(
          right: -5,
          bottom: -4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.backgroundStart, width: 2),
            ),
            child: Text(
              level,
              style: const TextStyle(
                color: AppColors.onPrimary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
