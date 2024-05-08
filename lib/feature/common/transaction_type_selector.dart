import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moneymanager/ui/widget/segmented_control.dart';

import '../../domain/transaction_type.dart';

class TransactionTypeSelector extends StatelessWidget {
  final TransactionType? selectedType;
  final Function(TransactionType?) onSelectedTypeChanged;
  final bool isEnabled;
  final bool usePlural;

  const TransactionTypeSelector({
    super.key,
    required this.selectedType,
    required this.onSelectedTypeChanged,
    this.isEnabled = true,
    this.usePlural = false,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedControl<TransactionType>(
      values: <TransactionType, Widget>{
        TransactionType.income: _getTextFor(context, TransactionType.income, usePlural),
        TransactionType.expense: _getTextFor(context, TransactionType.expense, usePlural),
      },
      selectedValue: selectedType,
      onSelectedValueChanged: (transactionType) {
        if (isEnabled) {
          onSelectedTypeChanged(transactionType);
        }
      },
    );
  }

  Widget _getTextFor(BuildContext context, TransactionType type, bool usePlural) {
    switch (type) {
      case TransactionType.income:
        return Text(AppLocalizations.of(context)!.income);
      case TransactionType.expense:
        if (usePlural) {
          return Text(AppLocalizations.of(context)!.expenses);
        } else {
          return Text(AppLocalizations.of(context)!.expense);
        }
    }
  }
}
