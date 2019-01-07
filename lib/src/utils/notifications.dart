import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_task/src/models/todo.dart';
import 'package:flutter_task/src/utils/notification_manager.dart';
import 'package:flutter_task/src/utils/helpers.dart';

const String _notificationChannelId = 'ScheduledNotification';
const String _notificationChannelName = 'Scheduled Notification';
const String _notificationChannelDescription =
    'Pushes a notification at a specified date';

Future scheduleNotification(Todo todo) async {
  FlutterLocalNotificationsPlugin notificationManager =
      NotificationManager().get();

  final notificationDetails = NotificationDetails(
    AndroidNotificationDetails(
      _notificationChannelId,
      _notificationChannelName,
      _notificationChannelDescription,
      importance: Importance.Max,
      priority: Priority.High,
    ),
    IOSNotificationDetails(),
  );

  await notificationManager.schedule(
    todo.todoId,
    todo.title,
    todo.message,
    Helpers.setDueDateToNotificationTime(dateString: todo.dueDate),
    notificationDetails,
    payload: todo.toString(),
  );
}

Future<Null> cancelNotification(Todo todo) async {
  FlutterLocalNotificationsPlugin notificationManager =
      NotificationManager().get();

  await notificationManager.cancel(todo.todoId);
  return null;
}
