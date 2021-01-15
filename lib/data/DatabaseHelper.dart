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
        lastRecordedDate: DateTime.fromMillisecondsSinceEpoch(maps[i]['lastRecordedDate'])
      );
    });
  }

  // Inserts a habit into the database
  void saveHabit(Habit habit)  async{
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
}