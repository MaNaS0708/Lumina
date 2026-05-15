import '../../models/goal.dart';

class GoalValidationResult {
  const GoalValidationResult({
    required this.totalWeightage,
    required this.isTotalValid,
    required this.isMinimumValid,
    required this.isCountValid,
  });

  final int totalWeightage;
  final bool isTotalValid;
  final bool isMinimumValid;
  final bool isCountValid;

  bool get isValid => isTotalValid && isMinimumValid && isCountValid;
}

class GoalValidators {
  const GoalValidators._();

  static GoalValidationResult validate(List<Goal> goals) {
    final total = goals.fold<int>(0, (sum, goal) => sum + goal.weightage);

    return GoalValidationResult(
      totalWeightage: total,
      isTotalValid: total == 100,
      isMinimumValid: goals.every((goal) => goal.weightage >= 10),
      isCountValid: goals.length <= 8,
    );
  }
}
