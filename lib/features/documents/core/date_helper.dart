import 'package:intl/intl.dart';

class DateHelper {
  static String timestampToReadableDate(String timestamp) {
    // Convert the timestamp string to an integer (microseconds)
    int timestampInt = int.parse(timestamp);

    // Convert microseconds to milliseconds
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestampInt ~/ 1000);

    var formatter = DateFormat('MMMM d, yyyy h:mm a');
    return formatter.format(date);
  }
}
