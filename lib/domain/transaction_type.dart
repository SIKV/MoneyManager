import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../theme/colors.dart';

enum TransactionType {
  income,
  expense,
}

extension TransactionTypeUtils on TransactionType {

  String getTitle(BuildContext context) {
    switch (this) {
      case TransactionType.income:
        return AppLocalizations.of(context)!.income;
      case TransactionType.expense:
        return AppLocalizations.of(context)!.expense;
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
