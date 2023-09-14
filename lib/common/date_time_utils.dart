import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

String formatDate(DateTime dateTime) {
  var today = DateTime.now();
  var yesterday = today.subtract(const Duration(days: 1));
  
  if (dateTime.day == today.day && dateTime.month == today.month && dateTime.year == today.year) {
    return "Today";
  } else if (dateTime.day == yesterday.day && dateTime.month == yesterday.month && dateTime.year == yesterday.year) {
    return "Yesterday";
  } else if (dateTime.year == today.year) {
    final DateFormat formatter = DateFormat('d MMMM');
    return formatter.format(dateTime);
  } else {
    final DateFormat formatter = DateFormat('d MMMM yyyy');
    return formatter.format(dateTime);
  }
}

String formatDateTime(DateTime dateTime) {
  final DateFormat timeFormat = DateFormat(DateFormat.HOUR_MINUTE);
  return '${formatDate(dateTime)} ${timeFormat.format(dateTime)}';
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
