import 'package:flutter/widgets.dart';

import '../../localizations.dart';
import 'domain/transaction_filter.dart';

extension TransactionFilterExtensions on TransactionFilter {

  String getTitle(BuildContext context) {
    switch (this) {
      case TransactionFilter.dayIncome:
        return Strings.dayIncome.localized(context);
      case TransactionFilter.dayExpenses:
        return Strings.dayExpenses.localized(context);
      case TransactionFilter.weekIncome:
        return Strings.weekIncome.localized(context);
      case TransactionFilter.weekExpenses:
        return Strings.weekExpenses.localized(context);
      case TransactionFilter.monthIncome:
        return Strings.monthIncome.localized(context);
      case TransactionFilter.monthExpenses:
        return Strings.monthExpenses.localized(context);
      case TransactionFilter.yearIncome:
        return Strings.yearIncome.localized(context);
      case TransactionFilter.yearExpenses:
        return Strings.yearExpenses.localized(context);
    }
  }
}
