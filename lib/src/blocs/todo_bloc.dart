import 'dart:async';
import 'package:flutter_task/src/data/todo_queries.dart';
import 'package:flutter_task/src/models/todo.dart';
import 'package:flutter_task/src/utils/notifications.dart';
import 'package:rxdart/rxdart.dart';

class TodoBloc {
  final _todoController = BehaviorSubject<List<Todo>>();
  final _completedTodoController = BehaviorSubject<List<Todo>>();
  final _singleTodoController = BehaviorSubject<Todo>();
  final _titleController = BehaviorSubject<String>();
  final _messageController = BehaviorSubject<String>();
  final _dueDateController = BehaviorSubject<String>();

  final todoQueries = TodoQueries();

  Stream<List<Todo>> get todoStream => _todoController.stream;
  Stream<List<Todo>> get completedTodos => _completedTodoController.stream;
  Stream<Todo> get singleTodoStream => _singleTodoController.stream;

  Stream<String> get title => _titleController.stream;
  Stream<String> get message => _messageController.stream;
  Stream<String> get dueDate => _dueDateController.stream;

  Function(String) get changeTitle => _titleController.sink.add;
  Function(String) get changeMessage => _messageController.sink.add;
  Function(String) get changeDueDate => _dueDateController.sink.add;
  Function(Todo) get addSingleTodo => _singleTodoController.sink.add;

  Future<int> submitTodo() async {
    final title = _titleController.value;
    if (title == null || title.isEmpty) {
      _titleController.sink.addError('Must not be empty');
      return null;
    }

    final message = _messageController.value;

    final dueDate = _dueDateController.value;

    Todo newTodo = Todo((b) => b
      ..todoId = null
      ..title = title
      ..message = message
      ..completed = 0
      ..dueDate = dueDate);

    var res = await insertTodo(newTodo);
    Todo withId = newTodo.rebuild((b) => b..todoId = res);

    if (withId.dueDate != null) {
      scheduleNotification(withId);
    }

    clearAddTodo();
    return res;
  }

  getIncompleteTodos() async {
    _todoController.sink.add(await todoQueries.getIncompleteTodos());
  }

  getCompletedTodos() async {
    _completedTodoController.sink.add(await todoQueries.getCompletedTodos());
  }

  Future<int> insertTodo(Todo todo) async {
    var res = await todoQueries.addTodo(todo);
    getIncompleteTodos();
    return res;
  }

  changeCompletion(Todo todo) async {
    Todo updatedTodo =
        todo.rebuild((b) => b..completed = todo.completed == 0 ? 1 : 0);
    await todoQueries.updateTodo(updatedTodo);
    getIncompleteTodos();
    getCompletedTodos();
  }

  updateEditingTodo() async {
    Todo todo = _singleTodoController.value;
    updateTodo(todo);
  }

  updateTodo(Todo todo) async {
    final title = _titleController.value;
    if (title == null || title.isEmpty) {
      _titleController.sink.addError('Must not be empty');
      return null;
    }

    final message = _messageController.value;

    final dueDate =
        _dueDateController.value == null ? '' : _dueDateController.value;

    Todo newTodo = Todo((b) => b
      ..todoId = todo.todoId
      ..title = title
      ..message = message
      ..completed = todo.completed
      ..dueDate = dueDate);
    if (todo != newTodo) {
      print(newTodo);
      await todoQueries.updateTodo(newTodo);
      if (todo.dueDate != newTodo.dueDate) {
        await cancelNotification(todo);
        await scheduleNotification(newTodo);
      }
    }
    getIncompleteTodos();
    getCompletedTodos();
    clearAddTodo();
  }

  deleteTodo(Todo todo) async {
    await cancelNotification(todo);
    await todoQueries.deleteTodo(todo);
    getIncompleteTodos();
  }

  clearAddTodo() async {
    _titleController.sink.add(null);
    _messageController.sink.add(null);
    _dueDateController.sink.add(null);
  }

  dispose() {
    _todoController.close();
    _titleController.close();
    _messageController.close();
    _dueDateController.close();
    _singleTodoController.close();
    _completedTodoController.close();
  }
}
