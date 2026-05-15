enum AppRole { employee, manager, admin }

extension AppRoleLabel on AppRole {
  String get label {
    switch (this) {
      case AppRole.employee:
        return 'Employee';
      case AppRole.manager:
        return 'Manager';
      case AppRole.admin:
        return 'HR Admin';
    }
  }
}

class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.department,
    required this.managerName,
    required this.organizationName,
  });

  final String id;
  final String name;
  final String email;
  final AppRole role;
  final String department;
  final String managerName;
  final String organizationName;
}
