import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';

/// Full-width rounded primary action button, reused across every screen
/// (Onboarding, Login, Signup, Lesson, Quiz, ...). No business logic —
/// purely presentational, driven entirely by constructor params.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.trailingIcon = Icons.arrow_forward_rounded,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: AppTextStyles.button),
          if (trailingIcon != null) ...[
            const SizedBox(width: 8),
            Icon(trailingIcon, size: 18, color: Colors.white),
          ],
        ],
      ),
    );
  }
}
