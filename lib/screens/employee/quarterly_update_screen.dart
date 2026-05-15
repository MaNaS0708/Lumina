import 'package:flutter/material.dart';

import '../../controllers/goal_sheet_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../models/goal.dart';
import '../../widgets/common/progress_bar.dart';
import '../../widgets/common/section_panel.dart';
import '../../widgets/common/status_badge.dart';
import '../../widgets/layout/page_header.dart';

class QuarterlyUpdateScreen extends StatelessWidget {
  const QuarterlyUpdateScreen({super.key, required this.controller});

  final GoalSheetController controller;

  @override
  Widget build(BuildContext context) {
    const quarters = ['Q1', 'Q2', 'Q3', 'Q4 / Annual'];

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageHeader(
              title: 'Quarterly update',
              subtitle:
                  'Capture actual achievement against planned targets and prepare for manager check-ins.',
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(quarters.length, (index) {
                final selected = controller.selectedQuarterIndex == index;
                return ChoiceChip(
                  selected: selected,
                  label: Text(quarters[index]),
                  onSelected: (_) => controller.selectQuarter(index),
                  selectedColor: AppColors.primarySoft,
                  backgroundColor: AppColors.surface,
                  side: const BorderSide(color: AppColors.border),
                );
              }),
            ),
            const SizedBox(height: 18),
            ...controller.goals.map((goal) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: SectionPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              goal.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          StatusBadge.forGoal(goal.status),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 14,
                        runSpacing: 14,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _MiniField(
                            label: 'Planned Target',
                            value: goal.targetLabel,
                          ),
                          _MiniField(
                            label: 'Actual Achievement',
                            value: goal.actualValue.toStringAsFixed(0),
                          ),
                          _MiniField(
                            label: 'Progress Status',
                            value: goal.status.label,
                          ),
                          SizedBox(
                            width: 180,
                            child: LuminaProgressBar(value: goal.progress),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SectionPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Manager comment preview',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Discussion notes and check-in comments will appear here after manager review is connected.',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MiniField extends StatelessWidget {
  const _MiniField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
