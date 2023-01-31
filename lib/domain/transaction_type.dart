import 'package:flutter/widgets.dart';

import '../localizations.dart';
import '../theme/colors.dart';

enum TransactionType {
  income,
  expense,
}

extension TransactionTypeUtils on TransactionType {

  String getTitle(BuildContext context) {
    switch (this) {
      case TransactionType.income:
        return Strings.income.localized(context);
      case TransactionType.expense:
        return Strings.expense.localized(context);
    }
  }

  Color getColor(AppColors colors) {
    switch (this) {
      case TransactionType.income:
        return colors.incomeTransaction;
      case TransactionType.expense:
        return colors.expenseTransaction;
    }
  }
}
