import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moneymanager/ui/widget/segmented_control.dart';

import '../../domain/transaction_type.dart';

class TransactionTypeSelector extends StatelessWidget {
  final TransactionType? selectedType;
  final Function(TransactionType?) onSelectedTypeChanged;

  const TransactionTypeSelector({
    super.key,
    required this.selectedType,
    required this.onSelectedTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedControl<TransactionType>(
      values: <TransactionType, Widget>{
        TransactionType.income: Text(AppLocalizations.of(context)!.income),
        TransactionType.expense: Text(AppLocalizations.of(context)!.expense),
      },
      selectedValue: selectedType,
      onSelectedValueChanged: (transactionType) {
        onSelectedTypeChanged(transactionType);
      },
    );
  }
}
