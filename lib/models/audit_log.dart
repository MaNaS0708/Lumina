import 'app_user.dart';

class AuditLog {
  const AuditLog({
    required this.timestamp,
    required this.user,
    required this.role,
    required this.action,
    required this.fieldChanged,
    required this.oldValue,
    required this.newValue,
  });

  final String timestamp;
  final String user;
  final AppRole role;
  final String action;
  final String fieldChanged;
  final String oldValue;
  final String newValue;
}
