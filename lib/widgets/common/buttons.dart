import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class LuminaButton extends StatelessWidget {
  const LuminaButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  }) : _variant = _ButtonVariant.primary;

  const LuminaButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  }) : _variant = _ButtonVariant.secondary;

  const LuminaButton.danger({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  }) : _variant = _ButtonVariant.danger;

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final _ButtonVariant _variant;

  @override
  Widget build(BuildContext context) {
    final isPrimary = _variant == _ButtonVariant.primary;
    final isDanger = _variant == _ButtonVariant.danger;
    final background = isDanger ? AppColors.danger : AppColors.primary;

    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
        Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
      ],
    );

    if (isPrimary || isDanger) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: child,
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.border),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: child,
    );
  }
}

enum _ButtonVariant { primary, secondary, danger }
