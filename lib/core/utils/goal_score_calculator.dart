import '../../models/goal.dart';

class GoalScoreCalculator {
  const GoalScoreCalculator._();

  static double calculate({
    required UomType uomType,
    required GoalDirection direction,
    required double target,
    required double actual,
  }) {
    if (target <= 0 && uomType != UomType.zeroBased) {
      return 0;
    }

    switch (uomType) {
      case UomType.zeroBased:
        return actual == 0 ? 100 : 0;
      case UomType.timeline:
        return actual <= target ? 100 : 0;
      case UomType.numeric:
      case UomType.percentage:
        if (direction == GoalDirection.lowerIsBetter) {
          if (actual <= 0) {
            return 100;
          }
          return (target / actual) * 100;
        }
        return (actual / target) * 100;
    }
  }
}
