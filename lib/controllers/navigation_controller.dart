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
    return _pagesForRole(_activeRole);
  }

  void startPreview(AppRole role) {
    _authenticatedUser = null;
    _setRole(role);
    notifyListeners();
  }

  void startPreviewFromAuth() {
    _setRole(AppRole.employee);
    notifyListeners();
  }

  void setAuthenticatedUser(AppUser user) {
    _authenticatedUser = user;
    _setRole(user.role);
    notifyListeners();
  }

  void navigateTo(AppPage page) {
    final allowedPages = _pagesForRole(_activeRole);

    if (!allowedPages.contains(page)) {
      return;
    }

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

  void _setRole(AppRole role) {
    _activeRole = role;

    final allowedPages = _pagesForRole(role);

    if (!allowedPages.contains(_activePage)) {
      _activePage = _landingPageForRole(role);
    }
  }

  AppPage _landingPageForRole(AppRole role) {
    return switch (role) {
      AppRole.employee => AppPage.employeeDashboard,
      AppRole.manager => AppPage.managerDashboard,
      AppRole.hr => AppPage.adminDashboard,
      AppRole.admin => AppPage.adminDashboard,
    };
  }

  List<AppPage> _pagesForRole(AppRole? role) {
    return switch (role) {
      AppRole.employee => const [
        AppPage.employeeDashboard,
        AppPage.employeeGoals,
        AppPage.employeeGoalEditor,
        AppPage.employeeQuarterlyUpdate,
      ],
      AppRole.manager => const [
        AppPage.managerDashboard,
        AppPage.managerTeamGoals,
        AppPage.managerApprovalDetail,
        AppPage.managerCheckins,
      ],
      AppRole.hr => const [
        AppPage.adminDashboard,
        AppPage.adminReports,
        AppPage.adminAuditLogs,
        AppPage.adminIdentitySettings,
      ],
      AppRole.admin => const [
        AppPage.adminDashboard,
        AppPage.adminReports,
        AppPage.adminAuditLogs,
        AppPage.adminIdentitySettings,
      ],
      null => const [],
    };
  }
}
