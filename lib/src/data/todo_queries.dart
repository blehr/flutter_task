import 'package:flutter_task/src/data/constants.dart';
import 'package:flutter_task/src/data/database.dart';
import 'package:flutter_task/src/models/serializers.dart';
import 'package:flutter_task/src/models/todo.dart';
import 'package:sqflite/sqflite.dart';

class TodoQueries {
  static final TodoQueries _instance = TodoQueries._internal();

  factory TodoQueries() {
    return _instance;
  }

  TodoQueries._internal();

  Future<Database> db = DatabaseHelper().get();

  Future<int> addTodo(Todo todo) async {
    var dbClient = await db;
    var mapTodo = serializers.serializeWith(Todo.serializer, todo);
    print(mapTodo);
    int res = await dbClient.insert(Constants.todoTable, mapTodo);
    return res;
  }

  Future<List<Todo>> getIncompleteTodos() async {
    var dbClient = await db;
    List<Map<String, dynamic>> rawTodos =  await dbClient.rawQuery('SELECT * FROM ${Constants.todoTable} WHERE ${Constants.completed} = 0 ORDER BY ${Constants.dueDate} ASC');
    return rawTodos.map((b) => serializers.deserializeWith(Todo.serializer, b)).toList();
  }

  Future<List<Todo>> getCompletedTodos() async {
    var dbClient = await db;
    List<Map<String, dynamic>> rawTodos =  await dbClient.rawQuery('SELECT * FROM ${Constants.todoTable} WHERE ${Constants.completed} = 1 ORDER BY ${Constants.dueDate} DESC');
    return rawTodos.map((b) => serializers.deserializeWith(Todo.serializer, b)).toList();
  }

  Future<int> updateTodo(Todo todo) async {
    var dbClient = await db;
    int res = await dbClient.update(Constants.todoTable, serializers.serializeWith(Todo.serializer, todo), where: "${Constants.id} = ?", whereArgs: [todo.todoId]);
    return res;
  }

  Future<int> deleteTodo(Todo todo) async {
    var dbClient = await db;
    int res = await dbClient.rawDelete("DELETE FROM ${Constants.todoTable} WHERE ${Constants.id} = ${todo.todoId}");
    return res;
  }

  Future closeDb() async {
    var dbClient = await db;
    dbClient.close();
  }

}