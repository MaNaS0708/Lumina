import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/app_user.dart';
import '../../models/goal.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  factory StatusBadge.forGoal(GoalStatus status) {
    final color = switch (status) {
      GoalStatus.completed ||
      GoalStatus.approved ||
      GoalStatus.locked => AppColors.success,
      GoalStatus.submitted || GoalStatus.onTrack => AppColors.primary,
      GoalStatus.rework ||
      GoalStatus.draft ||
      GoalStatus.notStarted => AppColors.warning,
      GoalStatus.overdue => AppColors.danger,
    };

    final icon = switch (status) {
      GoalStatus.completed ||
      GoalStatus.approved ||
      GoalStatus.locked => Icons.check_circle_rounded,
      GoalStatus.rework => Icons.keyboard_return_rounded,
      GoalStatus.overdue => Icons.warning_rounded,
      _ => Icons.circle_rounded,
    };

    return StatusBadge(label: status.label, color: color, icon: icon);
  }

  factory StatusBadge.forRole(AppRole role) {
    final color = switch (role) {
      AppRole.employee => AppColors.primary,
      AppRole.manager => AppColors.success,
      AppRole.hr => AppColors.primary,
      AppRole.admin => AppColors.warning,
    };

    final icon = switch (role) {
      AppRole.employee => Icons.person_rounded,
      AppRole.manager => Icons.supervisor_account_rounded,
      AppRole.hr => Icons.badge_rounded,
      AppRole.admin => Icons.admin_panel_settings_rounded,
    };

    return StatusBadge(label: role.label, color: color, icon: icon);
  }

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.28), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 13),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
