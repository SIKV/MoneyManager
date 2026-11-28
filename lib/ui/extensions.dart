import 'package:flutter/material.dart';
import 'package:moneymanager/domain/transaction_category.dart';
import 'package:moneymanager/domain/transaction_type.dart';

import '../feature/common/domain/transaction_item_ui_model.dart';
import '../l10n/app_localizations.dart';
import '../theme/colors.dart';
import '../theme/radius.dart';
import '../theme/spacings.dart';

extension TransactionCategoryExtensions on TransactionCategory {
  Widget getIcon(AppColors colors) {
    final emoji = this.emoji;
    if (emoji != null) {
      return Text(emoji,
        style: const TextStyle(
          fontSize: 21,
        ),
      );
    } else {
      return type.getIcon(colors);
    }
  }
}

extension TransactionUiModelExtensions on TransactionUiModel {
  Widget _getIcon(AppColors colors) {
    final emoji = this.emoji;
    if (emoji != null) {
      return Text(emoji,
        style: const TextStyle(
          fontSize: 21,
        ),
      );
    } else {
      return type.getIcon(colors);
    }
  }
  
  Widget getIcon(AppColors colors) {
    return Container(
        width: Spacings.eight,
        height: Spacings.eight,
        alignment: Alignment.center,
        decoration: ShapeDecoration(
          color: colors.colorScheme.surfaceContainerHigh,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.three)),
          ),
        ),
        child: _getIcon(colors)
    );
  }
}

extension TransactionTypeExtensions on TransactionType {
  String getTitle(BuildContext context, {bool usePlural = false}) {
    switch (this) {
      case TransactionType.income:
        return AppLocalizations.of(context)!.income;
      case TransactionType.expense:
        if (usePlural) {
          return AppLocalizations.of(context)!.expenses;
        } else {
          return AppLocalizations.of(context)!.expense;
        }
    }
  }

  Widget getIcon(AppColors colors) {
    switch (this) {
      case TransactionType.income:
        return Icon(Icons.arrow_circle_down_outlined,
          color: colors.incomeTransaction,
        );
      case TransactionType.expense:
        return Icon(Icons.arrow_circle_up_outlined,
          color: colors.expenseTransaction,
        );
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
