import 'package:flutter/material.dart';

import '../../controllers/navigation_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../models/app_user.dart';
import '../common/status_badge.dart';

class AppTopBar extends StatelessWidget {
  const AppTopBar({super.key, required this.controller, this.onMenuPressed});

  final NavigationController controller;
  final VoidCallback? onMenuPressed;

  @override
  Widget build(BuildContext context) {
    final user = controller.activeUser;

    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: const Border(
          bottom: BorderSide(color: AppColors.borderSoft, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final hideUserDetails = constraints.maxWidth < 720;
          final hideRoleBadge = constraints.maxWidth < 520;

          return Row(
            children: [
              if (onMenuPressed != null) ...[
                IconButton(
                  onPressed: onMenuPressed,
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: AppColors.textSecondary,
                    size: 24,
                  ),
                  splashRadius: 24,
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  controller.activePage.label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _TopBarActions(
                user: user,
                showRoleBadge: !hideRoleBadge,
                showUserDetails: !hideUserDetails,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TopBarActions extends StatelessWidget {
  const _TopBarActions({
    required this.user,
    required this.showRoleBadge,
    required this.showUserDetails,
  });

  final AppUser user;
  final bool showRoleBadge;
  final bool showUserDetails;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showRoleBadge) ...[
          StatusBadge.forRole(user.role),
          const SizedBox(width: 16),
        ],
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textSecondary,
              size: 22,
            ),
          ),
        ),
        const SizedBox(width: 8),
        _UserAvatar(user: user),
        if (showUserDetails) ...[
          const SizedBox(width: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 96, maxWidth: 180),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  user.organizationName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          user.name.substring(0, 1).toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
