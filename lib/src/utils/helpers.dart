import 'package:intl/intl.dart';

class Helpers {
  static final Helpers _instance = Helpers._internal();

  factory Helpers() {
    return _instance;
  }

  Helpers._internal();
  static String displayDateFormat({dateString: String}) {
    if (dateString == null || dateString == 'null' || dateString == '') {
      return "";
    }
    final f = DateFormat('M/d/y');
    DateTime date = DateTime.parse(dateString);
    return f.format(date);
  }

  static setDueDateToNotificationTime({dateString: String}) {
    if (dateString == null || dateString == 'null' || dateString == '') {
      return "";
    }
    DateTime date = DateTime.parse(dateString);
    return DateTime(date.year, date.month, date.day, 7, 0, 0, 0, 0);
  }

}