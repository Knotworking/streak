import 'models/TargetPeriod.dart';

class HabitUtils {
  static DateTime calculatePeriodEnd(DateTime periodStart, TargetPeriod targetPeriod) {
    switch (targetPeriod) {
      case TargetPeriod.day:
        return DateTime(periodStart.year, periodStart.month, periodStart.day + 1);
      case TargetPeriod.week:
        // 8 to give us the next monday
        return DateTime(periodStart.year, periodStart.month, periodStart.day + 8 - periodStart.weekday);
      case TargetPeriod.month:
        return DateTime(periodStart.year, periodStart.month + 1, 1);
      default:
        throw Exception("Target period $targetPeriod not handled correctly in calculatePeriodEnd");
    }
  }
}
