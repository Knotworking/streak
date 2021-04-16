import 'package:flutter_test/flutter_test.dart';
import 'package:streak/HabitUtils.dart';
import 'package:streak/models/TargetPeriod.dart';

void main() {
  test('Calculate period end for day', () {
    // prepare
    DateTime periodStart = DateTime(2020, 1, 1, 12);
    TargetPeriod targetPeriod = TargetPeriod.day;
    DateTime expectedEndDate = DateTime(2020, 1, 2, 0);

    // execute
    DateTime actual = HabitUtils.calculatePeriodEnd(periodStart, targetPeriod);

    // verify
    expect(actual, expectedEndDate);
  });

  test('Calculate period end for last day of the month', () {
    // prepare
    DateTime periodStart = DateTime(2020, 1, 31, 12);
    TargetPeriod targetPeriod = TargetPeriod.day;
    DateTime expectedEndDate = DateTime(2020, 2, 1, 0);

    // execute
    DateTime actual = HabitUtils.calculatePeriodEnd(periodStart, targetPeriod);

    // verify
    expect(actual, expectedEndDate);
  });

  test('Calculate period end from midnight', () {
    // prepare
    DateTime periodStart = DateTime(2020, 1, 1, 0);
    TargetPeriod targetPeriod = TargetPeriod.day;
    DateTime expectedEndDate = DateTime(2020, 1, 2, 0);

    // execute
    DateTime actual = HabitUtils.calculatePeriodEnd(periodStart, targetPeriod);

    // verify
    expect(actual, expectedEndDate);
  });

  test('Calculate period end for week', () {
    // prepare
    DateTime periodStart = DateTime(2020, 1, 1, 12);
    TargetPeriod targetPeriod = TargetPeriod.week;
    DateTime expectedEndDate = DateTime(2020, 1, 6, 0);

    // execute
    DateTime actual = HabitUtils.calculatePeriodEnd(periodStart, targetPeriod);

    // verify
    expect(actual, expectedEndDate);
  });

  test('Calculate period end for week should always be sunday at midnight', () {
    // prepare
    DateTime periodStart = DateTime(2020, 1, 5, 23, 59);
    TargetPeriod targetPeriod = TargetPeriod.week;
    DateTime expectedEndDate = DateTime(2020, 1, 6, 0);

    // execute
    DateTime actual = HabitUtils.calculatePeriodEnd(periodStart, targetPeriod);

    // verify
    expect(actual, expectedEndDate);
  });

  test('Calculate period end for week at end of month', () {
    // prepare
    DateTime periodStart = DateTime(2020, 1, 29, 12);
    TargetPeriod targetPeriod = TargetPeriod.week;
    DateTime expectedEndDate = DateTime(2020, 2, 3, 0);

    // execute
    DateTime actual = HabitUtils.calculatePeriodEnd(periodStart, targetPeriod);

    // verify
    expect(actual, expectedEndDate);
  });

  test('Calculate period end for month', () {
    // prepare
    DateTime periodStart = DateTime(2020, 1, 15, 12);
    TargetPeriod targetPeriod = TargetPeriod.month;
    DateTime expectedEndDate = DateTime(2020, 2, 1, 0);

    // execute
    DateTime actual = HabitUtils.calculatePeriodEnd(periodStart, targetPeriod);

    // verify
    expect(actual, expectedEndDate);
  });

  test('Calculate period end for month from start of the month', () {
    // prepare
    DateTime periodStart = DateTime(2020, 1, 1, 0);
    TargetPeriod targetPeriod = TargetPeriod.month;
    DateTime expectedEndDate = DateTime(2020, 2, 1, 0);

    // execute
    DateTime actual = HabitUtils.calculatePeriodEnd(periodStart, targetPeriod);

    // verify
    expect(actual, expectedEndDate);
  });
}