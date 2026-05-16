enum AppRole { employee, manager, hr, admin }

extension AppRoleLabel on AppRole {
  String get label {
    switch (this) {
      case AppRole.employee:
        return 'Employee';
      case AppRole.manager:
        return 'Manager';
      case AppRole.hr:
        return 'HR';
      case AppRole.admin:
        return 'Admin';
    }
  }

  String get firestoreValue {
    switch (this) {
      case AppRole.employee:
        return 'employee';
      case AppRole.manager:
        return 'manager';
      case AppRole.hr:
        return 'hr';
      case AppRole.admin:
        return 'admin';
    }
  }

  static AppRole fromFirestoreValue(String? value) {
    switch (value) {
      case 'manager':
        return AppRole.manager;
      case 'hr':
        return AppRole.hr;
      case 'admin':
        return AppRole.admin;
      case 'employee':
      default:
        return AppRole.employee;
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

  factory AppUser.fromFirestore(String id, Map<String, dynamic> data) {
    return AppUser(
      id: id,
      name: (data['displayName'] as String?) ?? 'Lumina User',
      email: (data['email'] as String?) ?? '',
      role: AppRoleLabel.fromFirestoreValue(data['role'] as String?),
      department: (data['departmentName'] as String?) ?? 'Unassigned',
      managerName: (data['managerName'] as String?) ?? 'Unassigned',
      organizationName: (data['organizationName'] as String?) ?? 'Lumina',
    );
  }

  final String id;
  final String name;
  final String email;
  final AppRole role;
  final String department;
  final String managerName;
  final String organizationName;
}
