import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/mock/mock_data.dart';
import '../../models/goal.dart';
import '../../widgets/common/buttons.dart';
import '../../widgets/common/section_panel.dart';
import '../../widgets/layout/page_header.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(
          title: 'Reports',
          subtitle:
              'Exportable planned vs actual reporting and completion tracking across organizations.',
          trailing: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              LuminaButton.secondary(
                label: 'Export CSV',
                icon: Icons.download_rounded,
                onPressed: () =>
                    _snack(context, 'CSV export is UI-only for now.'),
              ),
              LuminaButton.primary(
                label: 'Export Excel',
                icon: Icons.table_chart_rounded,
                onPressed: () =>
                    _snack(context, 'Excel export will be connected later.'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const _FilterRow(),
        const SizedBox(height: 18),
        SectionPanel(
          padding: EdgeInsets.zero,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 980),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  AppColors.surfaceElevated,
                ),
                columns: const [
                  DataColumn(label: Text('Employee')),
                  DataColumn(label: Text('Manager')),
                  DataColumn(label: Text('Department')),
                  DataColumn(label: Text('Goal Status')),
                  DataColumn(label: Text('Q1')),
                  DataColumn(label: Text('Q2')),
                  DataColumn(label: Text('Q3')),
                  DataColumn(label: Text('Q4')),
                  DataColumn(label: Text('Last Activity')),
                ],
                rows: MockData.teamMembers.map((member) {
                  return DataRow(
                    cells: [
                      DataCell(Text(member.name)),
                      DataCell(Text(member.manager)),
                      DataCell(Text(member.department)),
                      DataCell(Text(member.goalStatus.label)),
                      DataCell(Text('${member.completionRate.round()}%')),
                      DataCell(Text('${(member.completionRate - 6).round()}%')),
                      const DataCell(Text('Pending')),
                      const DataCell(Text('Pending')),
                      DataCell(Text(member.lastUpdated)),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _snack(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow();

  @override
  Widget build(BuildContext context) {
    return const SectionPanel(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _FilterChip(label: 'Department: All'),
          _FilterChip(label: 'Manager: All'),
          _FilterChip(label: 'Quarter: Q2'),
          _FilterChip(label: 'Status: Active'),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      avatar: const Icon(Icons.filter_list_rounded, size: 16),
      backgroundColor: AppColors.surfaceMuted,
      side: const BorderSide(color: AppColors.border),
    );
  }
}
