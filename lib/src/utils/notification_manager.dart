import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();

  factory NotificationManager() {
    return _instance;
  }

  NotificationManager._internal();

  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin; 

  FlutterLocalNotificationsPlugin get() {
    if (_flutterLocalNotificationsPlugin != null) {
      return _flutterLocalNotificationsPlugin;
    }
    _flutterLocalNotificationsPlugin = initPlugin();

    return _flutterLocalNotificationsPlugin;
  }


  initPlugin() {
    _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    return _flutterLocalNotificationsPlugin;
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
  }
}
