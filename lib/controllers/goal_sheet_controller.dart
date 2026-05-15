import 'package:flutter/material.dart';

import '../core/mock/mock_data.dart';
import '../core/utils/goal_validators.dart';
import '../models/goal.dart';

class GoalSheetController extends ChangeNotifier {
  final List<Goal> _goals = List<Goal>.from(MockData.goals);
  int _selectedQuarterIndex = 1;

  List<Goal> get goals => List.unmodifiable(_goals);
  int get selectedQuarterIndex => _selectedQuarterIndex;
  GoalValidationResult get validation => GoalValidators.validate(_goals);

  void selectQuarter(int index) {
    _selectedQuarterIndex = index;
    notifyListeners();
  }

  void addDraftGoal() {
    if (_goals.length >= 8) {
      return;
    }

    _goals.add(
      Goal(
        id: 'g-${_goals.length + 1}',
        title: 'New strategic goal',
        description: 'Describe the measurable outcome expected for this goal.',
        thrustArea: 'Business Priority',
        uomType: UomType.numeric,
        direction: GoalDirection.higherIsBetter,
        targetLabel: '100 units',
        targetValue: 100,
        actualValue: 0,
        weightage: 10,
        status: GoalStatus.draft,
        progress: 0,
      ),
    );
    notifyListeners();
  }
}
