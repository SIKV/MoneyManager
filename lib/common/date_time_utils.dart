import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

String formatDate(DateTime dateTime) {
  var today = DateTime.now();
  var yesterday = today.subtract(const Duration(days: 1));
  
  if (dateTime.day == today.day && dateTime.month == today.month && dateTime.year == today.year) {
    return "Today";
  } else if (dateTime.day == yesterday.day && dateTime.month == yesterday.month && dateTime.year == yesterday.year) {
    return "Yesterday";
  } else {
    final DateFormat formatter = DateFormat('d MMMM');
    return formatter.format(dateTime);
  }
}

String formatDateTime(DateTime dateTime) {
  // TODO:
  final DateFormat formatter = DateFormat('E dd  h:m a');
  return formatter.format(dateTime);
}

DateTime subtractDay(DateTime dateTime) {
  return Jiffy.parseFromDateTime(dateTime)
      .subtract(days: 1)
      .dateTime;
}

DateTime subtractWeek(DateTime dateTime) {
  return Jiffy.parseFromDateTime(dateTime)
      .subtract(weeks: 1)
      .dateTime;
}

DateTime subtractMonth(DateTime dateTime) {
  return Jiffy.parseFromDateTime(dateTime)
      .subtract(months: 1)
      .dateTime;
}

DateTime subtractYear(DateTime dateTime) {
  return Jiffy.parseFromDateTime(dateTime)
      .subtract(years: 1)
      .dateTime;
}
