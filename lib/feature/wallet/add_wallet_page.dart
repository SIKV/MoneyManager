import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/wallet/select_currency_button.dart';
import 'package:moneymanager/navigation/routes.dart';
import 'package:moneymanager/theme/spacings.dart';
import 'package:moneymanager/ui/widget/primary_button.dart';

import '../../l10n/app_localizations.dart';
import '../../ui/widget/small_section_text.dart';
import 'controller/add_wallet_controller.dart';

class AddWalletPage extends ConsumerWidget {
  const AddWalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addWalletControllerProvider).value;

    _listenWalletAdded(context, ref);
    _listenWalletAlreadyExists(context, ref);

    final canAddWallet = state?.selectedCurrency != null &&
        state?.alreadyExists == false;

    Widget? leading;

    if (state?.isFirstWallet == false) {
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
                child: Text(AppLocalizations.of(context)!.addWalletPage_title,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
              const SizedBox(height: Spacings.half),
              Center(
                child: SmallSectionText(AppLocalizations.of(context)!.addWalletPage_subtitle),
              ),
              const SizedBox(height: Spacings.eight),
              const SelectCurrencyButton(),
              const SizedBox(height: Spacings.eight),

              PrimaryButton(
                onPressed: canAddWallet ? () => _addWallet(context, ref) : null,
                title: AppLocalizations.of(context)!.addWalletPage_addButton,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addWallet(BuildContext context, WidgetRef ref) {
    ref.read(addWalletControllerProvider.notifier)
        .addWallet();
  }

  void _listenWalletAdded(BuildContext context, WidgetRef ref) {
    ref.listen(addWalletControllerProvider, (previous, next) {
      if (next.value?.walletAdded == true) {
        if (next.value?.isFirstWallet == true) {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        } else {
          Navigator.pop(context);
        }
      }
    });
  }

  void _listenWalletAlreadyExists(BuildContext context, WidgetRef ref) {
    ref.listen(addWalletControllerProvider
        .select((state) => state.value?.alreadyExists), (previous, next) {

      if (next == true) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.addWalletPage_alreadyExistsError),
            )
        );
      }
    });
  }
}
