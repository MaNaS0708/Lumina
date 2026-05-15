import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class LuminaProgressBar extends StatelessWidget {
  const LuminaProgressBar({super.key, required this.value, this.height = 6});

  final double value;
  final double height;

  @override
  Widget build(BuildContext context) {
    final normalized = (value / 100).clamp(0.0, 1.0);
    final color = value >= 90
        ? AppColors.success
        : (value >= 50 ? AppColors.primary : AppColors.warning);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
            color: AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.borderSoft, width: 0.5),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: FractionallySizedBox(
              widthFactor: normalized,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [color, color.withValues(alpha: 0.7)],
                  ),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${value.toStringAsFixed(0)}% Complete',
          style: TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
