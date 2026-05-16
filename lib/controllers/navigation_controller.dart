import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../app/app_routes.dart';
import '../core/mock/mock_data.dart';
import '../models/app_user.dart';

class NavigationController extends ChangeNotifier {
  AppUser? _authenticatedUser;
  AppRole? _activeRole;
  AppPage _activePage = AppPage.login;

  AppRole? get activeRole => _activeRole;
  AppPage get activePage => _activePage;
  bool get isPreviewSessionActive => _activeRole != null;

  AppUser get activeUser {
    if (_authenticatedUser != null) {
      return _authenticatedUser!;
    }

    switch (_activeRole) {
      case AppRole.manager:
        return MockData.manager;
      case AppRole.hr:
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
      case AppRole.hr:
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
    _authenticatedUser = null;
    _activeRole = role;
    _activePage = switch (role) {
      AppRole.employee => AppPage.employeeDashboard,
      AppRole.manager => AppPage.managerDashboard,
      AppRole.hr || AppRole.admin => AppPage.adminDashboard,
    };
    notifyListeners();
  }

  void startPreviewFromAuth() {
    _activeRole = AppRole.employee;
    _activePage = AppPage.employeeDashboard;
    notifyListeners();
  }

  void setAuthenticatedUser(AppUser user) {
    _authenticatedUser = user;
    _activeRole = user.role;
    _activePage = switch (user.role) {
      AppRole.employee => AppPage.employeeDashboard,
      AppRole.manager => AppPage.managerDashboard,
      AppRole.hr || AppRole.admin => AppPage.adminDashboard,
    };
    notifyListeners();
  }

  void navigateTo(AppPage page) {
    _activePage = page;
    notifyListeners();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    _authenticatedUser = null;
    _activeRole = null;
    _activePage = AppPage.login;
    notifyListeners();
  }

  void signOutPreview() {
    _authenticatedUser = null;
    _activeRole = null;
    _activePage = AppPage.login;
    notifyListeners();
  }
}
