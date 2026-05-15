import 'package:flutter/material.dart';

import '../../controllers/navigation_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../models/app_user.dart';

class LoginPreviewScreen extends StatelessWidget {
  const LoginPreviewScreen({super.key, required this.controller});

  final NavigationController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(color: AppColors.background),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth > 820;

                  return Flex(
                    direction: wide ? Axis.horizontal : Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: wide ? 5 : 0,
                        child: _BrandPanel(wide: wide),
                      ),
                      SizedBox(width: wide ? 48 : 0, height: wide ? 0 : 40),
                      Expanded(
                        flex: wide ? 4 : 0,
                        child: _LoginPanel(controller: controller),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel({required this.wide});

  final bool wide;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: wide
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primary.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'Lumina',
          textAlign: wide ? TextAlign.left : TextAlign.center,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 52,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 14),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Text(
            'Enterprise-grade performance tracking and professional goal management for modern teams.',
            textAlign: wide ? TextAlign.left : TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              height: 1.6,
              letterSpacing: 0.2,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 36),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            _TrustPill(label: 'Multi-company'),
            _TrustPill(label: 'Audit-first'),
            _TrustPill(label: 'Enterprise SSO'),
          ],
        ),
      ],
    );
  }
}

class _LoginPanel extends StatelessWidget {
  const _LoginPanel({required this.controller});

  final NavigationController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 24,
            offset: const Offset(0, 16),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Workspace Preview',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontSize: 20, letterSpacing: -0.3),
          ),
          const SizedBox(height: 10),
          const Text(
            'Select a role to explore the interface. Full authentication will be available soon.',
            style: TextStyle(
              color: AppColors.textSecondary,
              height: 1.5,
              fontSize: 13,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 28),
          _RolePreviewButton(
            title: 'Employee Portal',
            subtitle: 'Create goals and track quarterly achievements',
            icon: Icons.person_rounded,
            onTap: () => controller.startPreview(AppRole.employee),
          ),
          const SizedBox(height: 12),
          _RolePreviewButton(
            title: 'Manager Dashboard',
            subtitle: 'Review approvals and conduct team check-ins',
            icon: Icons.supervisor_account_rounded,
            onTap: () => controller.startPreview(AppRole.manager),
          ),
          const SizedBox(height: 12),
          _RolePreviewButton(
            title: 'Admin Console',
            subtitle: 'View dashboards, audit logs, and system settings',
            icon: Icons.admin_panel_settings_rounded,
            onTap: () => controller.startPreview(AppRole.admin),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.16),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.primary,
                  size: 18,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'This is a UI preview. Authentication will use Microsoft Entra ID in production.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RolePreviewButton extends StatefulWidget {
  const _RolePreviewButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  State<_RolePreviewButton> createState() => _RolePreviewButtonState();
}

class _RolePreviewButtonState extends State<_RolePreviewButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.surfaceElevated
                : AppColors.surfaceMuted,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _isHovered
                  ? AppColors.primary.withValues(alpha: 0.24)
                  : AppColors.border,
              width: 1.2,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(widget.icon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_rounded,
                color: _isHovered ? AppColors.primary : AppColors.textMuted,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrustPill extends StatelessWidget {
  const _TrustPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
          fontSize: 12,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
