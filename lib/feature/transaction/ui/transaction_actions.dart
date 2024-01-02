import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/theme/spacings.dart';
import 'package:moneymanager/ui/widget/delete_button.dart';
import 'package:moneymanager/ui/widget/primary_button.dart';

import '../../../ui/widget/delete_confirmation.dart';
import '../controller/transaction_maker_controller.dart';
import '../domain/ui_mode.dart';

class TransactionActions extends ConsumerWidget {
  const TransactionActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateValue = ref.watch(transactionMakerControllerProvider);

    final saveButton = PrimaryButton(
      onPressed: () => _saveTransaction(ref),
      icon: Icons.check_rounded,
      title: AppLocalizations.of(context)!.save,
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
        return DeleteConfirmation(
          title: AppLocalizations.of(context)!.deleteTransactionTitle,
          description: AppLocalizations.of(context)!.deleteTransactionDescription,
          onDeletePressed: () {
            ref.read(transactionMakerControllerProvider.notifier)
                .delete();
          },
        );
      },
    );
  }
}
