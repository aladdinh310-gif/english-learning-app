import 'package:flutter/material.dart';

/// Static content for one onboarding slide. Plain UI data class — not a
/// domain entity, since onboarding copy is fixed, not fetched.
class OnboardingSlideData {
  const OnboardingSlideData({
    required this.icon,
    required this.titleLine1,
    required this.titleLine2,
    required this.subtitle,
    required this.buttonLabel,
  });

  final IconData icon;
  final String titleLine1;
  final String titleLine2; // rendered in primary color, matches design
  final String subtitle;
  final String buttonLabel;

  static const List<OnboardingSlideData> slides = [
    OnboardingSlideData(
      icon: Icons.school_rounded,
      titleLine1: 'Speak',
      titleLine2: 'Naturally',
      subtitle: 'Learn English. Build your future.',
      buttonLabel: 'Get Started',
    ),
    OnboardingSlideData(
      icon: Icons.forum_rounded,
      titleLine1: 'Speak with',
      titleLine2: 'Confidence',
      subtitle: 'Practice real conversations and improve your speaking skills with AI.',
      buttonLabel: 'Next',
    ),
    OnboardingSlideData(
      icon: Icons.public_rounded,
      titleLine1: 'Learn at',
      titleLine2: 'Your Own Pace',
      subtitle: 'Choose from different levels and topics, and learn what matters to you.',
      buttonLabel: 'Next',
    ),
    OnboardingSlideData(
      icon: Icons.track_changes_rounded,
      titleLine1: 'Track Your',
      titleLine2: 'Progress',
      subtitle: 'Set goals, earn rewards and see your improvement every day.',
      buttonLabel: 'Get Started',
    ),
  ];
}
