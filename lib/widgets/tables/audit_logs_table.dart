import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/audit_log.dart';
import '../common/section_panel.dart';
import '../common/status_badge.dart';

class AuditLogsTable extends StatelessWidget {
  const AuditLogsTable({super.key, required this.logs});

  final List<AuditLog> logs;

  @override
  Widget build(BuildContext context) {
    return SectionPanel(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 1000),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              AppColors.surfaceElevated.withValues(alpha: 0.8),
            ),
            headingRowHeight: 56,
            dataRowMinHeight: 70,
            dataRowMaxHeight: 80,
            columnSpacing: 28,
            horizontalMargin: 22,
            columns: [
              DataColumn(label: _TableHeaderCell(label: 'Timestamp')),
              DataColumn(label: _TableHeaderCell(label: 'User')),
              DataColumn(label: _TableHeaderCell(label: 'Role')),
              DataColumn(label: _TableHeaderCell(label: 'Action')),
              DataColumn(label: _TableHeaderCell(label: 'Field')),
              DataColumn(label: _TableHeaderCell(label: 'Old Value')),
              DataColumn(label: _TableHeaderCell(label: 'New Value')),
            ],
            rows: logs.map((log) {
              return DataRow(
                onSelectChanged: (_) {
                  showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: AppColors.surface,
                    showDragHandle: true,
                    builder: (context) => Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Audit Detail',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontSize: 18, letterSpacing: -0.3),
                          ),
                          const SizedBox(height: 18),
                          _AuditDetailRow(label: 'Action', value: log.action),
                          const SizedBox(height: 12),
                          _AuditDetailRow(label: 'User', value: log.user),
                          const SizedBox(height: 12),
                          _AuditDetailRow(
                            label: 'Field',
                            value: log.fieldChanged,
                          ),
                          const SizedBox(height: 12),
                          _AuditDetailRow(
                            label: 'Previous Value',
                            value: log.oldValue,
                          ),
                          const SizedBox(height: 12),
                          _AuditDetailRow(
                            label: 'New Value',
                            value: log.newValue,
                          ),
                        ],
                      ),
                    ),
                  );
                },
                cells: [
                  DataCell(
                    Text(
                      log.timestamp,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      log.user,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  DataCell(StatusBadge.forRole(log.role)),
                  DataCell(
                    Text(
                      log.action,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      log.fieldChanged,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      log.oldValue,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  DataCell(
                    Text(
                      log.newValue,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _TableHeaderCell extends StatelessWidget {
  const _TableHeaderCell({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 12,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _AuditDetailRow extends StatelessWidget {
  const _AuditDetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
