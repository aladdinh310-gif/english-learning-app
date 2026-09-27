import 'package:flutter/material.dart';

class Achievement {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.xpReward,
    required this.unlocked,
    required this.progress,
    this.unlockDate,
  });

  final String id;
  final String title;
  final String description;
  final IconData icon;
  final int xpReward;
  final bool unlocked;
  final String progress;
  final DateTime? unlockDate;

  Achievement copyWith({
    bool? unlocked,
    String? progress,
    DateTime? unlockDate,
  }) {
    return Achievement(
      id: id,
      title: title,
      description: description,
      icon: icon,
      xpReward: xpReward,
      unlocked: unlocked ?? this.unlocked,
      progress: progress ?? this.progress,
      unlockDate: unlockDate ?? this.unlockDate,
    );
  }
}
