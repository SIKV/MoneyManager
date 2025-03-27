import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/account/select_currency_button.dart';
import 'package:moneymanager/navigation/routes.dart';
import 'package:moneymanager/theme/spacings.dart';
import 'package:moneymanager/ui/widget/primary_button.dart';

import '../../ui/widget/small_section_text.dart';
import 'controller/add_account_controller.dart';

class AddAccountPage extends ConsumerWidget {
  const AddAccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addAccountControllerProvider).value;

    _listenAccountAdded(context, ref);
    _listenAccountAlreadyExists(context, ref);

    final canAddAccount = state?.selectedCurrency != null &&
        state?.alreadyExists == false;

    Widget? leading;

    if (state?.isFirstAccount == false) {
      leading = IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: leading,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Spacings.seven),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(AppLocalizations.of(context)!.addAccountTitle,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const SizedBox(height: Spacings.half),
              Center(
                child: SmallSectionText(AppLocalizations.of(context)!.addAccountSubtitle),
              ),
              const SizedBox(height: Spacings.eight),
              const SelectCurrencyButton(),
              const SizedBox(height: Spacings.eight),

              PrimaryButton(
                onPressed: canAddAccount ? () => _addAccount(context, ref) : null,
                icon: Icons.add,
                title: AppLocalizations.of(context)!.addAccountActionButton,
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

  void _listenAccountAdded(BuildContext context, WidgetRef ref) {
    ref.listen(addAccountControllerProvider, (previous, next) {
      if (next.value?.accountAdded == true) {
        if (next.value?.isFirstAccount == true) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else {
          Navigator.pop(context);
        }
      }
    });
  }

  void _listenAccountAlreadyExists(BuildContext context, WidgetRef ref) {
    ref.listen(addAccountControllerProvider
        .select((state) => state.value?.alreadyExists), (previous, next) {

      if (next == true) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.accountAlreadyExistsError),
            )
        );
      }
    });
  }
}
