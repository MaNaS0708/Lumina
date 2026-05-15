import 'package:flutter/material.dart';

import '../../controllers/goal_sheet_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../models/goal.dart';
import '../../widgets/common/buttons.dart';
import '../../widgets/common/section_panel.dart';
import '../../widgets/layout/page_header.dart';

class GoalSheetEditorScreen extends StatelessWidget {
  const GoalSheetEditorScreen({super.key, required this.controller});

  final GoalSheetController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final validation = controller.validation;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(
              title: 'FY 2026 Goal Sheet',
              subtitle:
                  'Aarav Sharma - Manager: Meera Iyer - Status: Draft preview',
              trailing: LuminaButton.primary(
                label: 'Add Goal',
                icon: Icons.add_rounded,
                onPressed: controller.addDraftGoal,
              ),
            ),
            const SizedBox(height: 22),
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth > 1050;
                final form = _GoalFormList(goals: controller.goals);
                final validationPanel = _ValidationPanel(
                  totalWeightage: validation.totalWeightage,
                  totalValid: validation.isTotalValid,
                  minimumValid: validation.isMinimumValid,
                  countValid: validation.isCountValid,
                );

                if (!wide) {
                  return Column(
                    children: [
                      validationPanel,
                      const SizedBox(height: 16),
                      form,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 7, child: form),
                    const SizedBox(width: 18),
                    Expanded(flex: 3, child: validationPanel),
                  ],
                );
              },
            ),
            const SizedBox(height: 18),
            SectionPanel(
              child: Wrap(
                spacing: 12,
                runSpacing: 10,
                alignment: WrapAlignment.end,
                children: [
                  LuminaButton.secondary(
                    label: 'Save Draft',
                    icon: Icons.save_outlined,
                    onPressed: () => _showSnack(
                      context,
                      'Draft saved locally in UI preview.',
                    ),
                  ),
                  LuminaButton.primary(
                    label: 'Submit for Approval',
                    icon: Icons.send_rounded,
                    onPressed: validation.isValid
                        ? () => _showSnack(
                            context,
                            'Goal sheet is ready for backend submission later.',
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _GoalFormList extends StatelessWidget {
  const _GoalFormList({required this.goals});

  final List<Goal> goals;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: goals.map((goal) => _GoalEditorCard(goal: goal)).toList(),
    );
  }
}

class _GoalEditorCard extends StatelessWidget {
  const _GoalEditorCard({required this.goal});

  final Goal goal;

  @override
  Widget build(BuildContext context) {
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
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '${goal.weightage}%',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _FieldBox(label: 'Thrust Area', value: goal.thrustArea),
                _FieldBox(label: 'UoM Type', value: goal.uomType.label),
                _FieldBox(label: 'Direction', value: goal.direction.label),
                _FieldBox(label: 'Target', value: goal.targetLabel),
                _FieldBox(label: 'Weightage', value: '${goal.weightage}%'),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              goal.description,
              style: const TextStyle(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldBox extends StatelessWidget {
  const _FieldBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}

class _ValidationPanel extends StatelessWidget {
  const _ValidationPanel({
    required this.totalWeightage,
    required this.totalValid,
    required this.minimumValid,
    required this.countValid,
  });

  final int totalWeightage;
  final bool totalValid;
  final bool minimumValid;
  final bool countValid;

  @override
  Widget build(BuildContext context) {
    return SectionPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Validation', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Total weightage: $totalWeightage%',
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 18),
          _RuleRow(valid: totalValid, text: 'Total weightage must equal 100%'),
          _RuleRow(valid: minimumValid, text: 'Minimum 10% per goal'),
          _RuleRow(valid: countValid, text: 'Maximum 8 goals per employee'),
        ],
      ),
    );
  }
}

class _RuleRow extends StatelessWidget {
  const _RuleRow({required this.valid, required this.text});

  final bool valid;
  final String text;

  @override
  Widget build(BuildContext context) {
    final color = valid ? AppColors.success : AppColors.warning;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            valid ? Icons.check_circle_rounded : Icons.error_rounded,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
