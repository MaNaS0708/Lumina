import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../widgets/common/buttons.dart';
import '../../widgets/common/section_panel.dart';
import '../../widgets/layout/page_header.dart';

class IdentitySettingsScreen extends StatelessWidget {
  const IdentitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(
          title: 'Identity settings',
          subtitle:
              'Future Microsoft Entra ID connection area. This screen is UI-only and makes no backend claims yet.',
          trailing: LuminaButton.secondary(
            label: 'Sync hierarchy - coming soon',
            icon: Icons.sync_rounded,
            onPressed: null,
          ),
        ),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth > 900;
            final status = _ConnectionStatus();
            final mapping = _RoleMapping();

            if (!wide) {
              return Column(
                children: [status, const SizedBox(height: 16), mapping],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: status),
                const SizedBox(width: 16),
                Expanded(child: mapping),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ConnectionStatus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SectionPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Microsoft Entra ID',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 14),
          _IdentityLine(label: 'Connection status', value: 'Not connected'),
          _IdentityLine(label: 'Tenant mode', value: 'Multi-company planned'),
          _IdentityLine(label: 'Allowed domains', value: 'Configured later'),
          _IdentityLine(
            label: 'Auth provider',
            value: 'Firebase Auth + Microsoft later',
          ),
        ],
      ),
    );
  }
}

class _RoleMapping extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SectionPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Role mapping preview',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 14),
          _IdentityLine(label: 'Lumina Employees', value: 'Employee'),
          _IdentityLine(label: 'Lumina Managers', value: 'Manager'),
          _IdentityLine(label: 'Lumina HR Admins', value: 'Admin'),
          Divider(color: AppColors.border, height: 28),
          Text(
            'These mappings are UI placeholders. Real Entra group/app-role sync will be implemented later.',
            style: TextStyle(color: AppColors.textSecondary, height: 1.4),
          ),
        ],
      ),
    );
  }
}

class _IdentityLine extends StatelessWidget {
  const _IdentityLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textMuted),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
