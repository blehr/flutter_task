class Constants {
  static final Constants _instance = Constants._internal();

  factory Constants() {
    return _instance;
  }

  Constants._internal();

  static final String todoTable = 'TodoTable';
  static final String id = 'todoId';
  static final String title = 'title';
  static final String message = 'message';
  static final String completed = 'completed';
  static final String dueDate = 'dueDate';

}