import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/mock/mock_data.dart';
import '../../widgets/common/section_panel.dart';
import '../../widgets/layout/page_header.dart';
import '../../widgets/tables/audit_logs_table.dart';

class AuditLogsScreen extends StatelessWidget {
  const AuditLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(
          title: 'Audit logs',
          subtitle:
              'Compliance-focused activity trail for post-lock changes, approvals, and role updates.',
        ),
        SizedBox(height: 20),
        SectionPanel(
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _AuditFilter(label: 'Employee: All'),
              _AuditFilter(label: 'Action: All'),
              _AuditFilter(label: 'Date range: Last 30 days'),
              _AuditFilter(label: 'Risk: Post-lock only'),
            ],
          ),
        ),
        SizedBox(height: 18),
        AuditLogsTable(logs: MockData.auditLogs),
      ],
    );
  }
}

class _AuditFilter extends StatelessWidget {
  const _AuditFilter({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      avatar: const Icon(Icons.manage_search_rounded, size: 16),
      backgroundColor: AppColors.surfaceMuted,
      side: const BorderSide(color: AppColors.border),
    );
  }
}
