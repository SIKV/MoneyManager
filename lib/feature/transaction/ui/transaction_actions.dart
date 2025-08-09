import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/ui/widget/primary_button.dart';

import '../../../l10n/app_localizations.dart';
import '../../../ui/widget/delete_button.dart';
import '../../../ui/widget/delete_confirmation.dart';
import '../controller/transaction_maker_controller.dart';
import '../domain/ui_mode.dart';

class TransactionActions extends ConsumerWidget {
  const TransactionActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateValue = ref.watch(transactionMakerControllerProvider);

    return stateValue.when(
        loading: () => Container(),
        error: (_, __) => Container(),
        data: (state) {
          switch (state.uiMode) {
            case UiMode.add:
              return SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  onPressed: () => _saveTransaction(ref),
                  title: AppLocalizations.of(context)!.actionSave,
                ),
              );
            case UiMode.view:
              return Container();
            case UiMode.edit:
              return Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      onPressed: () => _saveTransaction(ref),
                      title: AppLocalizations.of(context)!.actionSave,
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DeleteButton(
                      style: DeleteButtonStyle.outlined,
                      onPressed: () => _deleteTransaction(context, ref),
                    ),
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
          title: AppLocalizations.of(context)!.transactionPage_deleteTitle,
          description: AppLocalizations.of(context)!.transactionPage_deleteDescription,
          onDeletePressed: () {
            ref.read(transactionMakerControllerProvider.notifier)
                .delete();
          },
        );
      },
    );
  }
}
