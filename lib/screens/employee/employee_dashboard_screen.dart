import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../controllers/goal_sheet_controller.dart';
import '../../controllers/navigation_controller.dart';
import '../../core/mock/mock_data.dart';
import '../../widgets/common/buttons.dart';
import '../../widgets/common/metric_card.dart';
import '../../widgets/layout/page_header.dart';
import '../../widgets/tables/goals_table.dart';

class EmployeeDashboardScreen extends StatelessWidget {
  const EmployeeDashboardScreen({
    super.key,
    required this.navigationController,
    required this.goalSheetController,
  });

  final NavigationController navigationController;
  final GoalSheetController goalSheetController;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: goalSheetController,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(
              title: 'My goal workspace',
              subtitle:
                  'Track approved goals, quarterly progress, and manager check-in readiness.',
              trailing: LuminaButton.primary(
                label: 'Create / Edit Goal Sheet',
                icon: Icons.edit_document,
                onPressed: () =>
                    navigationController.navigateTo(AppPage.employeeGoalEditor),
              ),
            ),
            const SizedBox(height: 22),
            _MetricsGrid(metrics: MockData.employeeMetrics),
            const SizedBox(height: 22),
            GoalsTable(goals: goalSheetController.goals),
          ],
        );
      },
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.metrics});

  final List metrics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 1050
            ? 4
            : constraints.maxWidth > 640
            ? 2
            : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: columns == 1 ? 2.7 : 1.55,
          ),
          itemCount: metrics.length,
          itemBuilder: (context, index) => MetricCard(metric: metrics[index]),
        );
      },
    );
  }
}
