import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/transaction/ui/category_selector.dart';
import 'package:moneymanager/feature/transaction/ui/date_time_selector.dart';
import 'package:moneymanager/feature/transaction/ui/note_input.dart';

import '../controller/transaction_maker_controller.dart';
import '../domain/transaction_property.dart';
import 'amount_input.dart';

class SelectorContainer extends ConsumerWidget {
  const SelectorContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProperty = ref.watch(transactionMakerControllerProvider
        .selectAsync((state) => state.selectedProperty));

    return FutureBuilder(
      future: selectedProperty,
      builder: (context, snapshot) {
        switch (snapshot.data) {
          case TransactionProperty.date:
            return const DateTimeSelector();
          case TransactionProperty.category:
            return const CategorySelector();
          case TransactionProperty.amount:
            return const AmountInput();
          case TransactionProperty.note:
            return const NoteInput();
          default:
            // [selectedProperty] is null when UiMode.view is active.
            return const NoteInput();
        }
      },
    );
  }
}
