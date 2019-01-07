import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:flutter_task/src/data/constants.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get() async {
    Sqflite.devSetDebugModeOn(true);
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  DatabaseHelper._internal();

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'main.db');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute("CREATE TABLE ${Constants.todoTable}(${Constants.id} INTEGER PRIMARY KEY AUTOINCREMENT, ${Constants.title} TEXT, ${Constants.message} TEXT, ${Constants.completed} INTEGER, ${Constants.dueDate} TEXT)");

    print("Database Created");
  }

}