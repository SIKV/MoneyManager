import 'package:flutter/cupertino.dart';
import 'package:moneymanager/localizations.dart';

import '../../domain/transaction_type.dart';
import '../../theme/colors.dart';

extension TransactionTypeUtils on TransactionType {

  String getTypeTitle() {
    switch (this) {
      case TransactionType.income:
        return Strings.income;
      case TransactionType.expense:
        return Strings.expense;
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

  String getTitle(BuildContext context) {
    switch (this) {
      case TransactionType.income:
        return Strings.income.localized(context);
      case TransactionType.expense:
        return Strings.expense.localized(context);
    }
  }
}
