import 'package:flutter/material.dart';

import '../../controllers/navigation_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../core/mock/mock_data.dart';
import '../../models/dashboard_metric.dart';
import '../../widgets/common/metric_card.dart';
import '../../widgets/common/section_panel.dart';
import '../../widgets/layout/page_header.dart';
import '../../widgets/tables/team_members_table.dart';

class ManagerDashboardScreen extends StatelessWidget {
  const ManagerDashboardScreen({super.key, required this.navigationController});

  final NavigationController navigationController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeader(
          title: 'Manager workspace',
          subtitle:
              'Review submitted goals, monitor team progress, and document quarterly check-ins.',
        ),
        const SizedBox(height: 22),
        _MetricGrid(metrics: MockData.managerMetrics),
        const SizedBox(height: 22),
        TeamMembersTable(
          members: MockData.teamMembers,
          controller: navigationController,
        ),
        const SizedBox(height: 18),
        const SectionPanel(
          child: Row(
            children: [
              Icon(Icons.info_outline_rounded, color: AppColors.primary),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Approval actions are UI-only for now. Backend locking and audit writes will be added in a later phase.',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.metrics});

  final List<DashboardMetric> metrics;

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
