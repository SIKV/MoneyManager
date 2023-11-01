import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/theme/spacings.dart';
import 'package:moneymanager/ui/widget/delete_button.dart';

import '../controller/transaction_maker_controller.dart';
import '../domain/ui_mode.dart';

class TransactionActions extends ConsumerWidget {
  const TransactionActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateValue = ref.watch(transactionMakerControllerProvider);

    final saveButton = FilledButton(
      onPressed: () => _saveTransaction(ref),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_rounded),
          const SizedBox(width: Spacings.two),
          Text(AppLocalizations.of(context)!.save),
        ],
      ),
    );

    return stateValue.when(
        loading: () => Container(),
        error: (_, __) => Container(),
        data: (state) {
          switch (state.uiMode) {
            case UiMode.add:
              return SizedBox(
                width: double.infinity,
                child: saveButton,
              );
            case UiMode.view:
              return Row(
                children: [
                  DeleteButton(
                    onPressed: () => _deleteTransaction(context, ref),
                    title: AppLocalizations.of(context)!.delete,
                  ),
                  const SizedBox(width: Spacings.three),
                  Expanded(
                    flex: 2,
                    child: saveButton,
                  ),
                ],
              );
          }
        }
    );
  }

  void _saveTransaction(WidgetRef ref) {
    ref.read(transactionMakerControllerProvider.notifier)
        .save();
  }

  void _deleteTransaction(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _DeleteConfirmation(
            onDeletePressed: () {
              ref.read(transactionMakerControllerProvider.notifier)
                  .delete();
            });
      },
    );
  }
}

class _DeleteConfirmation extends StatelessWidget {
  final VoidCallback onDeletePressed;

  const _DeleteConfirmation({Key? key,
    required this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.deleteTransactionTitle),
      content: Text(AppLocalizations.of(context)!.deleteTransactionDescription),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () {
            onDeletePressed();
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.delete),
        ),
      ],
    );
  }
}
