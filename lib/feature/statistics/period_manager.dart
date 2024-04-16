import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:moneymanager/feature/statistics/domain/period_type.dart';

import '../../common/date_time_utils.dart';
import 'domain/period.dart';

class PeriodManager {
  PeriodType _type;
  late Period _period;

  PeriodType get type {
    return _type;
  }

  set type(PeriodType type) {
    _type = type;
    _period = _createPeriod(DateTime.now());
  }

  Period get period {
    return _period;
  }

  PeriodManager(this._type) {
    _period = _createPeriod(DateTime.now());
  }

  Period goToPrevious() {
    switch (type) {
      case PeriodType.monthly:
        final prevMonth = subtractMonth(DateTime.fromMillisecondsSinceEpoch(_period.startTimestamp));
        _period = _createPeriod(prevMonth);
        break;
      case PeriodType.annually:
        final prevYear = subtractYear(DateTime.fromMillisecondsSinceEpoch(_period.startTimestamp));
        _period = _createPeriod(prevYear);
        break;
    }
    return _period;
  }

  Period goToNext() {
    switch (type) {
      case PeriodType.monthly:
        final nextMonth = addMonth(DateTime.fromMillisecondsSinceEpoch(_period.startTimestamp));
        _period = _createPeriod(nextMonth);
        break;
      case PeriodType.annually:
        final nextYear = addYear(DateTime.fromMillisecondsSinceEpoch(_period.startTimestamp));
        _period = _createPeriod(nextYear);
        break;
    }
    return _period;
  }

  Period _createPeriod(DateTime dateTime) {
    int startTimestamp = 0;
    int endTimestamp = 0;

    switch (type) {
      case PeriodType.monthly:
        startTimestamp = Jiffy.parseFromDateTime(dateTime)
            .startOf(Unit.month).millisecondsSinceEpoch;
        endTimestamp = Jiffy.parseFromDateTime(dateTime)
            .endOf(Unit.month).millisecondsSinceEpoch;
        break;
      case PeriodType.annually:
        startTimestamp = Jiffy.parseFromDateTime(dateTime)
            .startOf(Unit.year).millisecondsSinceEpoch;
        endTimestamp = Jiffy.parseFromDateTime(dateTime)
            .endOf(Unit.year).millisecondsSinceEpoch;
        break;
    }

    return Period(
      startTimestamp: startTimestamp,
      endTimestamp: endTimestamp,
      formatted: _formatDate(startTimestamp, endTimestamp, type),
    );
  }

  String _formatDate(int startTimestamp, int endTimestamp, PeriodType type) {
    switch (type) {
      case PeriodType.monthly:
        return DateFormat('MMMM yyyy')
            .format(DateTime.fromMillisecondsSinceEpoch(startTimestamp));
      case PeriodType.annually:
        return DateFormat('yyyy')
            .format(DateTime.fromMillisecondsSinceEpoch(startTimestamp));
    }
  }
}
