import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/common/transaction_type_selector.dart';

import '../../../domain/transaction_type.dart';
import '../controller/transaction_maker_controller.dart';

class TypeSelector extends ConsumerWidget {
  final bool isEnabled;

  const TypeSelector({
    super.key,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionType = ref.watch(transactionMakerControllerProvider
        .selectAsync((state) => state.transaction.type));

    return FutureBuilder(
      future: transactionType,
      builder: (context, snapshot) {
        return TransactionTypeSelector(
          selectedType: snapshot.data,
          isEnabled: isEnabled,
          onSelectedTypeChanged: (type) {
            ref.read(transactionMakerControllerProvider.notifier)
                .setType(type ?? TransactionType.income);
          },
        );
      },
    );
  }
}
