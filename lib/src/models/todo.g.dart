// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Todo> _$todoSerializer = new _$TodoSerializer();

class _$TodoSerializer implements StructuredSerializer<Todo> {
  @override
  final Iterable<Type> types = const [Todo, _$Todo];
  @override
  final String wireName = 'Todo';

  @override
  Iterable serialize(Serializers serializers, Todo object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.todoId != null) {
      result
        ..add('todoId')
        ..add(serializers.serialize(object.todoId,
            specifiedType: const FullType(int)));
    }
    if (object.title != null) {
      result
        ..add('title')
        ..add(serializers.serialize(object.title,
            specifiedType: const FullType(String)));
    }
    if (object.message != null) {
      result
        ..add('message')
        ..add(serializers.serialize(object.message,
            specifiedType: const FullType(String)));
    }
    if (object.completed != null) {
      result
        ..add('completed')
        ..add(serializers.serialize(object.completed,
            specifiedType: const FullType(int)));
    }
    if (object.dueDate != null) {
      result
        ..add('dueDate')
        ..add(serializers.serialize(object.dueDate,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  Todo deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TodoBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'todoId':
          result.todoId = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'title':
          result.title = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'message':
          result.message = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'completed':
          result.completed = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'dueDate':
          result.dueDate = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Todo extends Todo {
  @override
  final int todoId;
  @override
  final String title;
  @override
  final String message;
  @override
  final int completed;
  @override
  final String dueDate;

  factory _$Todo([void updates(TodoBuilder b)]) =>
      (new TodoBuilder()..update(updates)).build();

  _$Todo._(
      {this.todoId, this.title, this.message, this.completed, this.dueDate})
      : super._();

  @override
  Todo rebuild(void updates(TodoBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  TodoBuilder toBuilder() => new TodoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Todo &&
        todoId == other.todoId &&
        title == other.title &&
        message == other.message &&
        completed == other.completed &&
        dueDate == other.dueDate;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, todoId.hashCode), title.hashCode), message.hashCode),
            completed.hashCode),
        dueDate.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Todo')
          ..add('todoId', todoId)
          ..add('title', title)
          ..add('message', message)
          ..add('completed', completed)
          ..add('dueDate', dueDate))
        .toString();
  }
}

class TodoBuilder implements Builder<Todo, TodoBuilder> {
  _$Todo _$v;

  int _todoId;
  int get todoId => _$this._todoId;
  set todoId(int todoId) => _$this._todoId = todoId;

  String _title;
  String get title => _$this._title;
  set title(String title) => _$this._title = title;

  String _message;
  String get message => _$this._message;
  set message(String message) => _$this._message = message;

  int _completed;
  int get completed => _$this._completed;
  set completed(int completed) => _$this._completed = completed;

  String _dueDate;
  String get dueDate => _$this._dueDate;
  set dueDate(String dueDate) => _$this._dueDate = dueDate;

  TodoBuilder();

  TodoBuilder get _$this {
    if (_$v != null) {
      _todoId = _$v.todoId;
      _title = _$v.title;
      _message = _$v.message;
      _completed = _$v.completed;
      _dueDate = _$v.dueDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Todo other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Todo;
  }

  @override
  void update(void updates(TodoBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Todo build() {
    final _$result = _$v ??
        new _$Todo._(
            todoId: todoId,
            title: title,
            message: message,
            completed: completed,
            dueDate: dueDate);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
