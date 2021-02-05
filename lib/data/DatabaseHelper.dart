import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:streak/models/Habit.dart';

final habitsTable = "habits";

class DatabaseHelper {
  // Singleton
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  Future<Database> database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal() {
    initDatabase();
  }

  initDatabase() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'habits.db'),
      // When the database is first created, create a table to store data.
      onCreate: (db, version) {
        db.execute(
          '''CREATE TABLE $habitsTable(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            streak INTEGER,
            lastRecordedDate INTEGER)
          ''',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  // List all habits from the habits table
  Future<List<Habit>> getHabits() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query(habitsTable);

    // Convert the List<Map<String, dynamic> into a List<Habit>.
    return List.generate(maps.length, (i) {
      return Habit(
          id: maps[i]['id'],
          name: maps[i]['name'],
          streak: maps[i]['streak'],
          lastRecordedDate:
              DateTime.fromMillisecondsSinceEpoch(maps[i]['lastRecordedDate']));
    });
  }

  //TODO find better way to read just one entry
  Future<Habit> getHabit(int id) async {
    final Database db = await database;

    final List<Map<String, dynamic>> map =
        await db.query(habitsTable, where: "id = ?", whereArgs: [id], limit: 1);

    if (map.isNotEmpty) {
      return Habit(
          id: map[0]['id'],
          name: map[0]['name'],
          streak: map[0]['streak'],
          lastRecordedDate:
              DateTime.fromMillisecondsSinceEpoch(map[0]['lastRecordedDate']));
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
  void modifyHabitCount(Habit habit, int modifier) async {
    final Database db = await database;

    // Editing the passed in habit causes UI jumps
    Habit existingHabit = await getHabit(habit.id);
    existingHabit.streak += modifier;
    existingHabit.lastRecordedDate = DateTime.now();

    // can return the number of rows updated
    db.update(habitsTable, existingHabit.toMap(),
        where: "id = ?", whereArgs: [habit.id]);
  }

  // delete all habits from the database
  Future<int> deleteAllHabits() async {
    final Database db = await database;
    return db.delete(habitsTable);
  }
}
