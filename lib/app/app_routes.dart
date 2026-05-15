import 'package:flutter/material.dart';

enum AppPage {
  login(route: '/login', label: 'Login', icon: Icons.login_rounded),
  employeeDashboard(
    route: '/employee/dashboard',
    label: 'Dashboard',
    icon: Icons.dashboard_rounded,
  ),
  employeeGoals(
    route: '/employee/goals',
    label: 'My Goals',
    icon: Icons.flag_rounded,
  ),
  employeeGoalEditor(
    route: '/employee/goals/edit',
    label: 'Goal Sheet',
    icon: Icons.edit_document,
  ),
  employeeQuarterlyUpdate(
    route: '/employee/quarterly-update',
    label: 'Quarterly Updates',
    icon: Icons.stacked_line_chart_rounded,
  ),
  managerDashboard(
    route: '/manager/dashboard',
    label: 'Dashboard',
    icon: Icons.space_dashboard_rounded,
  ),
  managerTeamGoals(
    route: '/manager/team-goals',
    label: 'Team Goals',
    icon: Icons.groups_rounded,
  ),
  managerApprovalDetail(
    route: '/manager/approvals/demo',
    label: 'Approval Review',
    icon: Icons.fact_check_rounded,
  ),
  managerCheckins(
    route: '/manager/checkins',
    label: 'Check-ins',
    icon: Icons.rate_review_rounded,
  ),
  adminDashboard(
    route: '/admin/dashboard',
    label: 'Overview',
    icon: Icons.analytics_rounded,
  ),
  adminReports(
    route: '/admin/reports',
    label: 'Reports',
    icon: Icons.table_chart_rounded,
  ),
  adminAuditLogs(
    route: '/admin/audit-logs',
    label: 'Audit Logs',
    icon: Icons.manage_search_rounded,
  ),
  adminIdentitySettings(
    route: '/admin/identity-settings',
    label: 'Identity',
    icon: Icons.admin_panel_settings_rounded,
  );

  const AppPage({required this.route, required this.label, required this.icon});

  final String route;
  final String label;
  final IconData icon;
}
