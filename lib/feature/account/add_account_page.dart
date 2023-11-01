import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/account/select_currency_button.dart';
import 'package:moneymanager/theme/spacings.dart';
import 'package:moneymanager/ui/widget/close_circle_button.dart';

import '../../ui/widget/small_section_text.dart';
import 'controller/add_account_controller.dart';

class AddAccountPage extends ConsumerWidget {
  const AddAccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addAccountControllerProvider).value;

    ref.listen(addAccountControllerProvider, (previous, next) {
      if (next.value?.accountAdded == true) {
        Navigator.pop(context);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(Spacings.four),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: CloseCircleButton(
                    onTap: () {
                      if (state?.isFirstAccount == true) {
                        // TODO Close the app
                      } else {
                        Navigator.pop(context);
                      }
                    }
                  ),
                ),
              ),

              const SizedBox(height: Spacings.six),

              Text(AppLocalizations.of(context)!.addAccountTitle,
                style: Theme.of(context).textTheme.headlineLarge,
              ),

              const SizedBox(height: Spacings.half),

              SmallSectionText(AppLocalizations.of(context)!.addAccountSubtitle),

              const SizedBox(height: Spacings.eight),

              const SelectCurrencyButton(),

              const SizedBox(height: Spacings.eight),

              FilledButton(
                onPressed: state?.selectedCurrency != null ? () => _addAccount(context, ref) : null,
                child: Text(AppLocalizations.of(context)!.addAccountActionButton),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addAccount(BuildContext context, WidgetRef ref) {
    ref.read(addAccountControllerProvider.notifier)
        .addAccount();
  }
}
