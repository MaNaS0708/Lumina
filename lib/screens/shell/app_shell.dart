import 'package:flutter/material.dart';

import '../../app/app_routes.dart';
import '../../controllers/goal_sheet_controller.dart';
import '../../controllers/navigation_controller.dart';
import '../../core/constants/app_colors.dart';
import '../../screens/admin/admin_dashboard_screen.dart';
import '../../screens/admin/audit_logs_screen.dart';
import '../../screens/admin/identity_settings_screen.dart';
import '../../screens/admin/reports_screen.dart';
import '../../screens/employee/employee_dashboard_screen.dart';
import '../../screens/employee/goal_sheet_editor_screen.dart';
import '../../screens/employee/quarterly_update_screen.dart';
import '../../screens/manager/approval_detail_screen.dart';
import '../../screens/manager/manager_dashboard_screen.dart';
import '../../widgets/layout/app_sidebar.dart';
import '../../widgets/layout/app_top_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.controller});

  final NavigationController controller;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final GoalSheetController goalSheetController = GoalSheetController();

  @override
  void dispose() {
    goalSheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mobile = constraints.maxWidth < 760;
        final compact =
            constraints.maxWidth >= 760 && constraints.maxWidth < 1120;

        if (mobile) {
          return Scaffold(
            drawer: Drawer(
              backgroundColor: AppColors.surfaceMuted,
              child: SafeArea(child: AppSidebar(controller: widget.controller)),
            ),
            body: Builder(
              builder: (context) => Column(
                children: [
                  AppTopBar(
                    controller: widget.controller,
                    onMenuPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                  Expanded(child: _PageBody(child: _screenForActivePage())),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: Row(
            children: [
              AppSidebar(controller: widget.controller, compact: compact),
              Expanded(
                child: Column(
                  children: [
                    AppTopBar(controller: widget.controller),
                    Expanded(child: _PageBody(child: _screenForActivePage())),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _screenForActivePage() {
    switch (widget.controller.activePage) {
      case AppPage.employeeDashboard:
      case AppPage.employeeGoals:
        return EmployeeDashboardScreen(
          navigationController: widget.controller,
          goalSheetController: goalSheetController,
        );
      case AppPage.employeeGoalEditor:
        return GoalSheetEditorScreen(controller: goalSheetController);
      case AppPage.employeeQuarterlyUpdate:
        return QuarterlyUpdateScreen(controller: goalSheetController);
      case AppPage.managerDashboard:
      case AppPage.managerTeamGoals:
      case AppPage.managerCheckins:
        return ManagerDashboardScreen(navigationController: widget.controller);
      case AppPage.managerApprovalDetail:
        return ApprovalDetailScreen(goalSheetController: goalSheetController);
      case AppPage.adminDashboard:
        return const AdminDashboardScreen();
      case AppPage.adminReports:
        return const ReportsScreen();
      case AppPage.adminAuditLogs:
        return const AuditLogsScreen();
      case AppPage.adminIdentitySettings:
        return const IdentitySettingsScreen();
      case AppPage.login:
        return const SizedBox.shrink();
    }
  }
}

class _PageBody extends StatelessWidget {
  const _PageBody({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(22),
        child: child,
      ),
    );
  }
}
