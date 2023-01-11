import 'package:flutter/widgets.dart';

import '../../localizations.dart';
import 'domain/transactions_header_value.dart';

extension GetTitle on TransactionsHeaderValue {

  String getTitle(BuildContext context) {
    switch (this) {
      case TransactionsHeaderValue.dayIncome:
        return Strings.dayIncome.localized(context);
      case TransactionsHeaderValue.dayExpenses:
        return Strings.dayExpenses.localized(context);
      case TransactionsHeaderValue.weekIncome:
        return Strings.weekIncome.localized(context);
      case TransactionsHeaderValue.weekExpenses:
        return Strings.weekExpenses.localized(context);
      case TransactionsHeaderValue.monthIncome:
        return Strings.monthIncome.localized(context);
      case TransactionsHeaderValue.monthExpenses:
        return Strings.monthExpenses.localized(context);
      case TransactionsHeaderValue.yearIncome:
        return Strings.yearIncome.localized(context);
      case TransactionsHeaderValue.yearExpenses:
        return Strings.yearExpenses.localized(context);
    }
  }
}
