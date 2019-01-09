import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'todo.g.dart';

abstract class Todo implements Built<Todo, TodoBuilder> {
  static Serializer<Todo> get serializer => _$todoSerializer;
  @nullable
  int get todoId;

  @nullable
  String get title;

  @nullable
  String get message;

  @nullable
  int get completed;

  @nullable
  String get dueDate;

  Todo._();

  factory Todo([updates(TodoBuilder b)]) =
      _$Todo;
}