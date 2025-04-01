import 'package:intl/intl.dart';

class DateTimeUtil {

  static String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('HH:mm dd-MM-yyyy');
    return formatter.format(dateTime);
  }
}
