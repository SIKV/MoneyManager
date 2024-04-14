import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moneymanager/domain/transaction_type.dart';
import 'package:moneymanager/domain/transaction_type_filter.dart';

import '../../common/date_time_utils.dart';
import '../../domain/transaction.dart';
import 'domain/transaction_range_filter.dart';

// TODO: Add unit tests.
double calculateAmount(List<Transaction> transactions) {
  return transactions.fold(0.0, (previousValue, element) {
    double amount = element.amount;
    if (element.type == TransactionType.expense) {
      amount = -amount;
    }
    return previousValue + amount;
  });
}

String getFilterTitle(BuildContext context, TransactionRangeFilter range, TransactionTypeFilter type) {
  String title = range.getTitle(context);
  switch (type) {
    case TransactionTypeFilter.income:
      return '$title ${AppLocalizations.of(context)!.lIncome}';
    case TransactionTypeFilter.expenses:
      return '$title ${AppLocalizations.of(context)!.lExpenses}';
    case TransactionTypeFilter.all:
      return title;
  }
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

  // TODO: Check if it works correctly.
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
