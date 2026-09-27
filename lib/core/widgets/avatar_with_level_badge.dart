import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AvatarWithLevelBadge extends StatelessWidget {
  const AvatarWithLevelBadge({
    super.key,
    required this.level,
    this.radius = 26,
  });

  final String level;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: AppColors.primary.withValues(alpha: 0.14),
          child: Icon(
            Icons.person_outline,
            color: AppColors.primary,
            size: radius * 1.05,
          ),
        ),
        Positioned(
          right: -5,
          bottom: -4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
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
