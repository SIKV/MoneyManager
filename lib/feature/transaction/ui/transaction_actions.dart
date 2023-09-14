import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_type.dart';
import 'package:moneymanager/theme/spacings.dart';

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
            return _AddModeActions(
              type: state.transaction.type,
              onAddPressed: () => _saveTransaction(ref),
            );
          case UiMode.view:
            return _ViewModeActions(
              type: state.transaction.type,
              onSavePressed: () => _saveTransaction(ref),
            );
        }
      }
    );
  }

  void _saveTransaction(WidgetRef ref) {
    ref.read(transactionMakerControllerProvider.notifier)
        .save();
  }
}

class _AddModeActions extends ConsumerWidget {
  final TransactionType type;
  final VoidCallback onAddPressed;

  const _AddModeActions({
    Key? key,
    required this.type,
    required this.onAddPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    IconData icon;

    switch (type) {
      case TransactionType.income:
        icon = Icons.arrow_circle_down_outlined;
        break;
      case TransactionType.expense:
        icon = Icons.arrow_circle_up_outlined;
        break;
    }

    return FilledButton(
      onPressed: onAddPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          const SizedBox(width: Spacings.two),
          Text('${AppLocalizations.of(context)!.addNew} ${type.getTitle(context)}'),
        ],
      ),
    );
  }
}

class _ViewModeActions extends ConsumerWidget {
  final TransactionType type;
  final VoidCallback onSavePressed;

  const _ViewModeActions({
    Key? key,
    required this.type,
    required this.onSavePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton(
      onPressed: onSavePressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_rounded),
          const SizedBox(width: Spacings.two),
          Text(AppLocalizations.of(context)!.save),
        ],
      ),
    );
  }
}
