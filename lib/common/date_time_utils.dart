import 'package:jiffy/jiffy.dart';

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
