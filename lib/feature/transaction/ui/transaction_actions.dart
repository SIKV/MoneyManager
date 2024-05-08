import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/ui/widget/primary_button.dart';

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
                  title: AppLocalizations.of(context)!.save,
                ),
              );
            case UiMode.view:
              return Container();
            case UiMode.edit:
              return SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  onPressed: () => _saveTransaction(ref),
                  title: AppLocalizations.of(context)!.saveChanges,
                ),
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
