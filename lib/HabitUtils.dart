import 'models/TargetPeriod.dart';

class HabitUtils {
  static DateTime calculatePeriodEnd(DateTime periodStart, TargetPeriod targetPeriod, int periodCount) {
    switch (targetPeriod) {
      case TargetPeriod.day:
        return DateTime(periodStart.year, periodStart.month, periodStart.day + periodCount);
      case TargetPeriod.week:
        // +1 to give us the next monday
        return DateTime(periodStart.year, periodStart.month, periodStart.day + 7 * periodCount + 1 - periodStart.weekday);
      case TargetPeriod.month:
        return DateTime(periodStart.year, periodStart.month + periodCount, 1);
      default:
        throw Exception("Target period $targetPeriod not handled correctly in calculatePeriodEnd");
    }
  }
}
