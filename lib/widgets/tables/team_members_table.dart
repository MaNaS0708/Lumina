import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../controllers/navigation_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../models/team_member.dart';
import '../common/progress_bar.dart';
import '../common/section_panel.dart';
import '../common/status_badge.dart';

class TeamMembersTable extends StatelessWidget {
  const TeamMembersTable({
    super.key,
    required this.members,
    required this.controller,
  });

  final List<TeamMember> members;
  final NavigationController controller;

  @override
  Widget build(BuildContext context) {
    return SectionPanel(
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 1080),
          child: DataTable(
            headingRowColor: WidgetStateProperty.all(
              AppColors.surfaceElevated.withValues(alpha: 0.8),
            ),
            headingRowHeight: 56,
            dataRowMinHeight: 72,
            dataRowMaxHeight: 88,
            columnSpacing: 32,
            horizontalMargin: 22,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border, width: 0),
            ),
            columns: [
              DataColumn(label: _TableHeaderCell(label: 'Employee')),
              DataColumn(label: _TableHeaderCell(label: 'Department')),
              DataColumn(label: _TableHeaderCell(label: 'Manager')),
              DataColumn(label: _TableHeaderCell(label: 'Goal Status')),
              DataColumn(label: _TableHeaderCell(label: 'Weightage')),
              DataColumn(label: _TableHeaderCell(label: 'Completion')),
              DataColumn(label: _TableHeaderCell(label: 'Action')),
            ],
            rows: members.map((member) {
              return DataRow(
                cells: [
                  DataCell(
                    Text(
                      member.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      member.department,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  DataCell(
                    Text(
                      member.manager,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  DataCell(StatusBadge.forGoal(member.goalStatus)),
                  DataCell(
                    Text(
                      '${member.totalWeightage}%',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  DataCell(LuminaProgressBar(value: member.completionRate)),
                  DataCell(
                    OutlinedButton.icon(
                      onPressed: () =>
                          controller.navigateTo(AppPage.managerApprovalDetail),
                      icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                      label: const Text('Review'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.border,
                          width: 1,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
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
