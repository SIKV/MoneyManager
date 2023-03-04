import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/transaction/ui/category_selector.dart';
import 'package:moneymanager/feature/transaction/ui/date_time_selector.dart';
import 'package:moneymanager/feature/transaction/ui/note_selector.dart';

import '../controller/transaction_maker_controller.dart';
import '../domain/transaction_property.dart';

class SelectorContainer extends ConsumerWidget {
  const SelectorContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProperty = ref.watch(transactionMakerControllerProvider
        .select((state) => state.selectedProperty));

    switch (selectedProperty) {
      case TransactionProperty.date:
        return const DateTimeSelector();
      case TransactionProperty.category:
        return const CategorySelector();
      case TransactionProperty.amount:
        return const Text('Amount');
      case TransactionProperty.note:
        return const NoteSelector();
    }
  }
}
