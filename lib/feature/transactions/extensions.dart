import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../common/date_time_utils.dart';
import '../../domain/transaction_type.dart';
import 'domain/transaction_filter.dart';

extension TransactionFilterExtensions on TransactionFilter {

  String getTitle(BuildContext context) {
    switch (this) {
      case TransactionFilter.dayIncome:
        return AppLocalizations.of(context)!.dayIncome;
      case TransactionFilter.dayExpenses:
        return AppLocalizations.of(context)!.dayExpenses;
      case TransactionFilter.weekIncome:
        return AppLocalizations.of(context)!.weekIncome;
      case TransactionFilter.weekExpenses:
        return AppLocalizations.of(context)!.weekExpenses;
      case TransactionFilter.monthIncome:
        return AppLocalizations.of(context)!.monthIncome;
      case TransactionFilter.monthExpenses:
        return AppLocalizations.of(context)!.monthExpenses;
      case TransactionFilter.yearIncome:
        return AppLocalizations.of(context)!.yearIncome;
      case TransactionFilter.yearExpenses:
        return AppLocalizations.of(context)!.yearExpenses;
    }
  }

  TransactionType getTransactionType() {
    switch (this) {
      case TransactionFilter.dayIncome:
      case TransactionFilter.weekIncome:
      case TransactionFilter.monthIncome:
      case TransactionFilter.yearIncome:
        return TransactionType.income;
      case TransactionFilter.dayExpenses:
      case TransactionFilter.weekExpenses:
      case TransactionFilter.monthExpenses:
      case TransactionFilter.yearExpenses:
        return TransactionType.expense;
    }
  }

  int getFromTimestamp(DateTime now) {
    switch (this) {
      case TransactionFilter.dayIncome:
      case TransactionFilter.dayExpenses:
        return subtractDay(now).millisecondsSinceEpoch;
      case TransactionFilter.weekIncome:
      case TransactionFilter.weekExpenses:
        return subtractWeek(now).millisecondsSinceEpoch;
      case TransactionFilter.monthIncome:
      case TransactionFilter.monthExpenses:
        return subtractMonth(now).millisecondsSinceEpoch;
      case TransactionFilter.yearIncome:
      case TransactionFilter.yearExpenses:
        return subtractYear(now).millisecondsSinceEpoch;
    }
  }
}
