import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../models/goal.dart';
import '../common/progress_bar.dart';
import '../common/section_panel.dart';
import '../common/status_badge.dart';

class GoalsTable extends StatelessWidget {
  const GoalsTable({super.key, required this.goals, this.editable = false});

  final List<Goal> goals;
  final bool editable;

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
            dataRowMinHeight: 76,
            dataRowMaxHeight: 96,
            columnSpacing: 28,
            horizontalMargin: 22,
            columns: [
              DataColumn(label: _TableHeaderCell(label: 'Goal')),
              DataColumn(label: _TableHeaderCell(label: 'Thrust Area')),
              DataColumn(label: _TableHeaderCell(label: 'UoM')),
              DataColumn(label: _TableHeaderCell(label: 'Target')),
              DataColumn(label: _TableHeaderCell(label: 'Weight')),
              DataColumn(label: _TableHeaderCell(label: 'Status')),
              DataColumn(label: _TableHeaderCell(label: 'Progress')),
            ],
            rows: goals.map((goal) {
              return DataRow(
                cells: [
                  DataCell(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          goal.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 11,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DataCell(Text(goal.thrustArea)),
                  DataCell(Text(goal.uomType.label)),
                  DataCell(
                    _EditableLook(text: goal.targetLabel, enabled: editable),
                  ),
                  DataCell(
                    _EditableLook(
                      text: '${goal.weightage}%',
                      enabled: editable,
                    ),
                  ),
                  DataCell(StatusBadge.forGoal(goal.status)),
                  DataCell(
                    SizedBox(
                      width: 130,
                      child: LuminaProgressBar(value: goal.progress),
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

class _EditableLook extends StatelessWidget {
  const _EditableLook({required this.text, required this.enabled});

  final String text;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return Text(
        text,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 7),
          const Icon(Icons.edit_rounded, size: 13, color: AppColors.textMuted),
        ],
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
