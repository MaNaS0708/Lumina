import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../core/mock/mock_data.dart';
import '../models/app_user.dart';

class NavigationController extends ChangeNotifier {
  AppRole? _activeRole;
  AppPage _activePage = AppPage.login;

  AppRole? get activeRole => _activeRole;
  AppPage get activePage => _activePage;
  bool get isPreviewSessionActive => _activeRole != null;

  AppUser get activeUser {
    switch (_activeRole) {
      case AppRole.manager:
        return MockData.manager;
      case AppRole.admin:
        return MockData.admin;
      case AppRole.employee:
      case null:
        return MockData.employee;
    }
  }

  List<AppPage> get pagesForActiveRole {
    switch (_activeRole) {
      case AppRole.manager:
        return const [
          AppPage.managerDashboard,
          AppPage.managerTeamGoals,
          AppPage.managerApprovalDetail,
          AppPage.managerCheckins,
        ];
      case AppRole.admin:
        return const [
          AppPage.adminDashboard,
          AppPage.adminReports,
          AppPage.adminAuditLogs,
          AppPage.adminIdentitySettings,
        ];
      case AppRole.employee:
        return const [
          AppPage.employeeDashboard,
          AppPage.employeeGoals,
          AppPage.employeeGoalEditor,
          AppPage.employeeQuarterlyUpdate,
        ];
      case null:
        return const [];
    }
  }

  void startPreview(AppRole role) {
    _activeRole = role;
    _activePage = switch (role) {
      AppRole.employee => AppPage.employeeDashboard,
      AppRole.manager => AppPage.managerDashboard,
      AppRole.admin => AppPage.adminDashboard,
    };
    notifyListeners();
  }

  void startPreviewFromAuth() {
    _activeRole = AppRole.employee;
    _activePage = AppPage.employeeDashboard;
    notifyListeners();
  }

  void navigateTo(AppPage page) {
    _activePage = page;
    notifyListeners();
  }

  void signOutPreview() {
    _activeRole = null;
    _activePage = AppPage.login;
    notifyListeners();
  }
}
