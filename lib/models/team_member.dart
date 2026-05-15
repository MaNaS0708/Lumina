import 'goal.dart';

class TeamMember {
  const TeamMember({
    required this.id,
    required this.name,
    required this.department,
    required this.manager,
    required this.goalStatus,
    required this.totalWeightage,
    required this.lastUpdated,
    required this.completionRate,
  });

  final String id;
  final String name;
  final String department;
  final String manager;
  final GoalStatus goalStatus;
  final int totalWeightage;
  final String lastUpdated;
  final double completionRate;
}
