import 'package:flutter/material.dart';

import '../../core/mock/mock_data.dart';
import '../../models/dashboard_metric.dart';
import '../../widgets/common/metric_card.dart';
import '../../widgets/layout/page_header.dart';
import '../../widgets/tables/team_members_table.dart';
import '../../controllers/navigation_controller.dart';
import '../../models/app_user.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fakeNav = NavigationController()..startPreview(AppRole.manager);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const PageHeader(
          title: 'HR overview',
          subtitle:
              'Organization-level completion visibility across goal sheets, check-ins, and manager actions.',
        ),
        const SizedBox(height: 22),
        _MetricGrid(metrics: MockData.adminMetrics),
        const SizedBox(height: 22),
        TeamMembersTable(members: MockData.teamMembers, controller: fakeNav),
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
