import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_type.dart';
import 'package:moneymanager/theme/spacings.dart';

import '../../../localizations.dart';
import '../controller/transaction_maker_controller.dart';
import '../domain/ui_mode.dart';

class TransactionActions extends ConsumerWidget {
  const TransactionActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateValue = ref.watch(transactionMakerControllerProvider);

    return stateValue.when(
      loading: () => Container(),
      error: (_, __) => Container(),
      data: (state) {
        switch (state.uiMode) {
          case UiMode.add:
            return _AddModeActions(type: state.transaction.type);
          case UiMode.view:
            return _ViewModeActions(type: state.transaction.type);
        }
      }
    );
  }
}

class _AddModeActions extends ConsumerWidget {
  final TransactionType type;

  const _AddModeActions({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: [
        FilledButton(
          onPressed: () => _saveTransaction(ref),
          child: Row(
            children: [
              const Icon(Icons.done),
              const SizedBox(width: Spacings.two),
              Text('${Strings.transaction_actionAdd.localized(context)} ${type.getTitle(context)}'),
            ],
          ),
        ),
      ],
    );
  }

  void _saveTransaction(WidgetRef ref) {
    ref.read(transactionMakerControllerProvider.notifier)
        .save();
  }
}

class _ViewModeActions extends ConsumerWidget {
  final TransactionType type;

  const _ViewModeActions({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ButtonBar(
      alignment: MainAxisAlignment.end,
      children: [
        FilledButton(
          onPressed: () => {
            // TODO:
          },
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          child: Row(
            children: [
              const Icon(Icons.delete_outline_rounded),
              const SizedBox(width: Spacings.two),
              Text(Strings.transaction_actionDelete.localized(context)),
            ],
          ),
        ),
        FilledButton(
          onPressed: () => {
            // TODO:
          },
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.onBackground,
          ),
          child: Row(
            children: [
              const Icon(Icons.done),
              const SizedBox(width: Spacings.two),
              Text(Strings.transaction_actionSave.localized(context)),
            ],
          ),
        ),
      ],
    );
  }
}
