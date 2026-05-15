enum UomType { numeric, percentage, timeline, zeroBased }

enum GoalDirection {
  higherIsBetter,
  lowerIsBetter,
  deadlineBased,
  zeroIsSuccess,
}

enum GoalStatus {
  draft,
  submitted,
  approved,
  rework,
  locked,
  notStarted,
  onTrack,
  completed,
  overdue,
}

extension UomTypeLabel on UomType {
  String get label {
    switch (this) {
      case UomType.numeric:
        return 'Numeric';
      case UomType.percentage:
        return 'Percentage';
      case UomType.timeline:
        return 'Timeline';
      case UomType.zeroBased:
        return 'Zero-based';
    }
  }
}

extension GoalDirectionLabel on GoalDirection {
  String get label {
    switch (this) {
      case GoalDirection.higherIsBetter:
        return 'Higher is better';
      case GoalDirection.lowerIsBetter:
        return 'Lower is better';
      case GoalDirection.deadlineBased:
        return 'Deadline based';
      case GoalDirection.zeroIsSuccess:
        return 'Zero is success';
    }
  }
}

extension GoalStatusLabel on GoalStatus {
  String get label {
    switch (this) {
      case GoalStatus.draft:
        return 'Draft';
      case GoalStatus.submitted:
        return 'Submitted';
      case GoalStatus.approved:
        return 'Approved';
      case GoalStatus.rework:
        return 'Rework';
      case GoalStatus.locked:
        return 'Locked';
      case GoalStatus.notStarted:
        return 'Not Started';
      case GoalStatus.onTrack:
        return 'On Track';
      case GoalStatus.completed:
        return 'Completed';
      case GoalStatus.overdue:
        return 'Overdue';
    }
  }
}

class Goal {
  const Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.thrustArea,
    required this.uomType,
    required this.direction,
    required this.targetLabel,
    required this.targetValue,
    required this.actualValue,
    required this.weightage,
    required this.status,
    required this.progress,
  });

  final String id;
  final String title;
  final String description;
  final String thrustArea;
  final UomType uomType;
  final GoalDirection direction;
  final String targetLabel;
  final double targetValue;
  final double actualValue;
  final int weightage;
  final GoalStatus status;
  final double progress;
}
