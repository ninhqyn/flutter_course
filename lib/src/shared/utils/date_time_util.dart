import 'package:intl/intl.dart';

class DateTimeUtil {

  static String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('HH:mm dd-MM-yyyy');
    return formatter.format(dateTime);
  }

  static DateTime parseCustomDateTime(String input) {
    if (input.length != 14) {
      throw const FormatException("Input must be exactly 14 digits (yyyyMMddHHmmss)");
    }

    return DateTime(
        int.parse(input.substring(0, 4)),  // year
        int.parse(input.substring(4, 6)),  // month
        int.parse(input.substring(6, 8)),  // day
        int.parse(input.substring(8, 10)), // hour
        int.parse(input.substring(10, 12)),// minute
        int.parse(input.substring(12, 14)) // second
    );
  }
  static String formatFromRawString(String input) {
    final dt = parseCustomDateTime(input);
    return formatDateTime(dt);
  }

}
