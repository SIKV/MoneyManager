import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/transaction_type.dart';
import '../../../localizations.dart';
import '../provider/transaction_maker_provider.dart';

class TypeSelector extends ConsumerWidget {
  const TypeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionType = ref.watch(transactionMakerProvider
        .select((state) => state.type)
    );

    return CupertinoSlidingSegmentedControl<TransactionType>(
      groupValue: transactionType,
      onValueChanged: (type) {
        ref.read(transactionMakerProvider.notifier)
            .setType(type ?? TransactionType.income);
      },
      children: <TransactionType, Widget>{
        TransactionType.income: Text(Strings.income.localized(context)),
        TransactionType.expense: Text(Strings.expense.localized(context)),
      },
    );
  }
}
