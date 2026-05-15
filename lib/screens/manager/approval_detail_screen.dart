import 'package:flutter/material.dart';

import '../../controllers/goal_sheet_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/common/buttons.dart';
import '../../widgets/common/section_panel.dart';
import '../../widgets/layout/page_header.dart';
import '../../widgets/tables/goals_table.dart';

class ApprovalDetailScreen extends StatelessWidget {
  const ApprovalDetailScreen({super.key, required this.goalSheetController});

  final GoalSheetController goalSheetController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: goalSheetController,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(
              title: 'Approval review',
              subtitle:
                  'Review employee goals, edit targets or weightages visually, and record manager feedback.',
            ),
            const SizedBox(height: 22),
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth > 1100;
                final table = GoalsTable(
                  goals: goalSheetController.goals,
                  editable: true,
                );
                final side = _ApprovalSidePanel(
                  totalWeightage: goalSheetController.validation.totalWeightage,
                );

                if (!wide) {
                  return Column(
                    children: [side, const SizedBox(height: 16), table],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 7, child: table),
                    const SizedBox(width: 18),
                    Expanded(flex: 3, child: side),
                  ],
                );
              },
            ),
            const SizedBox(height: 18),
            SectionPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Manager feedback',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  const TextField(
                    minLines: 3,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText:
                          'Add discussion notes or return-for-rework comments...',
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    alignment: WrapAlignment.end,
                    children: [
                      LuminaButton.danger(
                        label: 'Return for Rework',
                        icon: Icons.keyboard_return_rounded,
                        onPressed: () => _snack(
                          context,
                          'Marked as returned for rework in UI preview.',
                        ),
                      ),
                      LuminaButton.primary(
                        label: 'Approve and Lock Goals',
                        icon: Icons.lock_rounded,
                        onPressed: () => _snack(
                          context,
                          'Approval will lock goals after backend is connected.',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _snack(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}

class _ApprovalSidePanel extends StatelessWidget {
  const _ApprovalSidePanel({required this.totalWeightage});

  final int totalWeightage;

  @override
  Widget build(BuildContext context) {
    return SectionPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Employee detail',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 14),
          const _DetailLine(label: 'Employee', value: 'Aarav Sharma'),
          const _DetailLine(label: 'Department', value: 'Sales Operations'),
          const _DetailLine(label: 'Cycle', value: 'FY 2026'),
          _DetailLine(label: 'Weightage', value: '$totalWeightage%'),
          const Divider(color: AppColors.border, height: 28),
          const _DetailLine(
            label: 'Approval history',
            value: 'Submitted today, 10:42 AM',
          ),
          const _DetailLine(label: 'Validation', value: 'Ready for review'),
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
