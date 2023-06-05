import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/transaction_type.dart';
import '../../../localizations.dart';
import '../controller/transaction_maker_controller.dart';

class TypeSelector extends ConsumerWidget {
  const TypeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionType = ref.watch(transactionMakerControllerProvider
        .selectAsync((state) => state.transaction.type));

    final thumbColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).colorScheme.background
        : Theme.of(context).colorScheme.primary;

    return FutureBuilder(
      future: transactionType,
      builder: (context, snapshot) {
        return CupertinoSlidingSegmentedControl<TransactionType>(
          thumbColor: thumbColor,
          groupValue: snapshot.data,
          onValueChanged: (type) {
            ref.read(transactionMakerControllerProvider.notifier)
                .setType(type ?? TransactionType.income);
          },
          children: <TransactionType, Widget>{
            TransactionType.income: Text(Strings.income.localized(context)),
            TransactionType.expense: Text(Strings.expense.localized(context)),
          },
        );
      },
    );
  }
}
