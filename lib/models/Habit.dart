import 'package:streak/models/TargetPeriod.dart';

class Habit {
  static const idKey = 'id';
  static const nameKey = 'name';
  static const targetKey = 'target';
  static const targetPeriodKey = 'targetPeriod';
  static const periodCountKey = 'periodCount';
  static const countForPeriodKey = 'countForPeriod';
  static const streakKey = 'streak';
  static const periodEndKey = 'periodEnd';

  final int id;
  String name;
  int target;
  TargetPeriod targetPeriod;
  int periodCount;
  int countForPeriod;
  int streak;
  DateTime periodEnd;

  Habit(
      {this.id,
      this.name,
      this.target,
      this.targetPeriod,
      this.periodCount,
      this.countForPeriod,
      this.streak,
      this.periodEnd});

  //TODO "new" habit constructor

  //TODO improve
  // don't insert id if < 0
  Map<String, dynamic> toMap() {
    if (id >= 0) {
      return {
        idKey: id,
        nameKey: name,
        targetKey: target,
        targetPeriodKey: targetPeriod.toString().split('.').last,
        periodCountKey: periodCount,
        countForPeriodKey: countForPeriod,
        streakKey: streak,
        periodEndKey: periodEnd.millisecondsSinceEpoch
      };
    } else {
      return {
        nameKey: name,
        targetKey: target,
        targetPeriodKey: targetPeriod.toString().split('.').last,
        periodCountKey: periodCount,
        countForPeriodKey: countForPeriod,
        streakKey: streak,
        periodEndKey: periodEnd.millisecondsSinceEpoch
      };
    }
  }

  // Implement toString to make it easier to see information about
  // each habit when using the print statement.
  @override
  String toString() {
    return 'Habit{$idKey: $id, '
        '$nameKey: $name, '
        '$targetKey: $target, '
        '$targetPeriodKey: $targetPeriod, '
        '$periodCountKey: $periodCount, '
        '$countForPeriodKey: $countForPeriod, '
        '$streakKey: $streak, '
        '$periodEndKey: $periodEnd}';
  }
}
