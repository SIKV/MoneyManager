import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moneymanager/domain/transaction_type_filter.dart';

import '../../common/date_time_utils.dart';
import 'domain/transaction_range_filter.dart';

String getFilterTitle(TransactionRangeFilter range, TransactionTypeFilter type) {
  // TODO: Implement.
  return '';
}

extension TransactionRangeFilterExtensions on TransactionRangeFilter {

  String getTitle(BuildContext context) {
    switch (this) {
      case TransactionRangeFilter.day:
        return AppLocalizations.of(context)!.thisDay;
      case TransactionRangeFilter.week:
        return AppLocalizations.of(context)!.thisWeek;
      case TransactionRangeFilter.month:
        return AppLocalizations.of(context)!.thisMonth;
      case TransactionRangeFilter.year:
        return AppLocalizations.of(context)!.thisYear;
    }
  }

  int getFromTimestamp(DateTime now) {
    switch (this) {
      case TransactionRangeFilter.day:
        return subtractDay(now).millisecondsSinceEpoch;
      case TransactionRangeFilter.week:
        return subtractWeek(now).millisecondsSinceEpoch;
      case TransactionRangeFilter.month:
        return subtractMonth(now).millisecondsSinceEpoch;
      case TransactionRangeFilter.year:
        return subtractYear(now).millisecondsSinceEpoch;
    }
  }
}
