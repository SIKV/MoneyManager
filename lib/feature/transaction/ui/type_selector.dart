import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/transaction_type.dart';
import '../../../localizations.dart';
import '../controller/transaction_maker_controller.dart';

class TypeSelector extends ConsumerWidget {
  const TypeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionType = ref.watch(transactionMakerControllerProvider
        .select((state) => state.type)
    );

    return CupertinoSlidingSegmentedControl<TransactionType>(
      groupValue: transactionType,
      onValueChanged: (type) {
        ref.read(transactionMakerControllerProvider.notifier)
            .setType(type ?? TransactionType.income);
      },
      children: <TransactionType, Widget>{
        TransactionType.income: Text(Strings.income.localized(context)),
        TransactionType.expense: Text(Strings.expense.localized(context)),
      },
    );
  }
}
