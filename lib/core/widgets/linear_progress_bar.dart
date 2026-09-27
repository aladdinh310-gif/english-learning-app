import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class LinearProgressBar extends StatelessWidget {
  const LinearProgressBar({
    super.key,
    required this.value,
    this.color = AppColors.primary,
    this.minHeight = 8,
  });

  final double value;
  final Color color;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: value.clamp(0.0, 1.0),
        minHeight: minHeight,
        backgroundColor: AppColors.divider,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
