import 'dart:async';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:streak/HabitUtils.dart';
import 'package:streak/models/Habit.dart';
import 'package:streak/models/TargetPeriod.dart';

final habitsTable = "habits";

class DatabaseHelper {
  // Singleton
  static DatabaseHelper _instance;
  static Database _database;

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {
    if (_instance == null) {
      _instance = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _instance;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDatabase();
    }
    return _database;
  }

  Future<Database> initDatabase() async {
    var database = await openDatabase(
      join(await getDatabasesPath(), 'habits.db'),
      // When the database is first created, create a table to store data.
      onCreate: (db, version) {
        db.execute(
          '''CREATE TABLE $habitsTable(
            ${Habit.idKey} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${Habit.nameKey} TEXT,
            ${Habit.targetKey} INTEGER,
            ${Habit.targetPeriodKey} TEXT,
            ${Habit.periodCountKey} INTEGER,
            ${Habit.streakKey} INTEGER,
            ${Habit.periodEndKey} INTEGER)
          ''',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    return database;
  }

  Future<void> checkStreaks() async {
    final Database db = await database;

    print("checking streaks");

    // Query the table for all habits.
    final List<Map<String, dynamic>> maps = await db.query(habitsTable);

    final now = DateTime.now();

    for (Map<String, dynamic> map in maps) {
      DateTime periodEnd =
          DateTime.fromMillisecondsSinceEpoch(map[Habit.periodEndKey]);

      if (now.isAfter(periodEnd)) {
        print('now: $now is after period end: $periodEnd');
        int id = map[Habit.idKey];
        if (map[Habit.periodCountKey] >= map[Habit.targetKey]) {
          print("goal reached for ${map[Habit.nameKey]}");
          _incrementHabitStreak(id);
        } else {
          print("goal not reached for ${map[Habit.nameKey]}");
          _resetHabitStreak(id);
        }

        print("resetting count for ${map[Habit.nameKey]}");
        _resetHabitCount(id);
      }
    }
  }

  // List all habits from the habits table
  Future<List<Habit>> getHabits() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all habits.
    final List<Map<String, dynamic>> maps = await db.query(habitsTable);

    // Convert the List<Map<String, dynamic> into a List<Habit>.
    return List.generate(maps.length, (i) {
      return Habit(
          id: maps[i][Habit.idKey],
          name: maps[i][Habit.nameKey],
          target: maps[i][Habit.targetKey],
          targetPeriod: EnumToString.fromString(
              TargetPeriod.values, maps[i][Habit.targetPeriodKey]),
          periodCount: maps[i][Habit.periodCountKey],
          streak: maps[i][Habit.streakKey],
          periodEnd:
              DateTime.fromMillisecondsSinceEpoch(maps[i][Habit.periodEndKey]));
    });
  }

  //TODO find better way to read just one entry
  Future<Habit> getHabit(int id) async {
    final Database db = await database;

    final List<Map<String, dynamic>> map = await db.query(habitsTable,
        where: "${Habit.idKey} = ?", whereArgs: [id], limit: 1);

    if (map.isNotEmpty) {
      return Habit(
          id: map[0][Habit.idKey],
          name: map[0][Habit.nameKey],
          target: map[0][Habit.targetKey],
          targetPeriod: EnumToString.fromString(
              TargetPeriod.values, map[0][Habit.targetPeriodKey]),
          periodCount: map[0][Habit.periodCountKey],
          streak: map[0][Habit.streakKey],
          periodEnd:
              DateTime.fromMillisecondsSinceEpoch(map[0][Habit.periodEndKey]));
    } else {
      return null;
    }
  }

  // Inserts a habit into the database
  void saveHabit(Habit habit) async {
    // Get a reference to the database.
    final Database db = await database;

    // Insert the Habit into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      habitsTable,
      habit.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // change a habit's count by an integer value
  Future<void> modifyHabitCount(Habit habit, int modifier) async {
    final Database db = await database;

    await checkStreaks();

    // Editing the passed in habit causes UI jumps
    Habit existingHabit = await getHabit(habit.id);

    existingHabit.periodCount += 1;

    // can return the number of rows updated
    db.update(habitsTable, existingHabit.toMap(),
        where: "${Habit.idKey} = ?", whereArgs: [habit.id]);
    // print("habit updated: ${existingHabit.name}");
  }

  void _resetHabitCount(int habitId) async {
    final Database db = await database;

    Habit existingHabit = await getHabit(habitId);
    existingHabit.periodCount = 0;
    existingHabit.periodEnd = HabitUtils.calculatePeriodEnd(
        existingHabit.periodEnd, existingHabit.targetPeriod);

    // can return the number of rows updated
    db.update(habitsTable, existingHabit.toMap(),
        where: "${Habit.idKey} = ?", whereArgs: [habitId]);
  }

  void _resetHabitStreak(int habitId) async {
    final Database db = await database;

    Habit existingHabit = await getHabit(habitId);
    existingHabit.streak = 0;

    // can return the number of rows updated
    db.update(habitsTable, existingHabit.toMap(),
        where: "${Habit.idKey} = ?", whereArgs: [habitId]);
  }

  void _incrementHabitStreak(int habitId) async {
    final Database db = await database;

    Habit existingHabit = await getHabit(habitId);
    existingHabit.streak += 1;

    // can return the number of rows updated
    db.update(habitsTable, existingHabit.toMap(),
        where: "${Habit.idKey} = ?", whereArgs: [habitId]);
  }

  void updateHabit(Habit habit) async {
    final Database db = await database;
    habit.periodEnd = DateTime.now();

    // can return the number of rows updated
    db.update(habitsTable, habit.toMap(),
        where: "${Habit.idKey} = ?", whereArgs: [habit.id]);
  }

  // delete all habits from the database
  Future<int> deleteAllHabits() async {
    final Database db = await database;
    return db.delete(habitsTable);
  }
}
