import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/ui/widget/delete_button.dart';
import 'package:moneymanager/ui/widget/small_section_text.dart';

import '../../theme/spacings.dart';
import '../../ui/widget/delete_confirmation.dart';
import 'controller/wallet_settings_controller.dart';

class WalletSettingsPage extends ConsumerWidget {
  const WalletSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(walletSettingsControllerProvider);

    _listenWalletDeleted(context, ref);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Text(AppLocalizations.of(context)!.walletSettingsPage_title),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacings.four),
              child: SmallSectionText(state.value?.wallet?.currency.name ?? ''),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(Spacings.four),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: Spacings.five),
                  DeleteButton(
                    onPressed: () => _deleteWallet(context, ref),
                    title: AppLocalizations.of(context)!.walletSettingsPage_deleteButton,
                  ),
                  const SizedBox(height: Spacings.four),
                  SmallSectionText(AppLocalizations.of(context)!.walletSettingsPage_warning),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteWallet(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteConfirmation(
          title: AppLocalizations.of(context)!.walletSettingsPage_deleteConfirmationTitle,
          description: AppLocalizations.of(context)!.walletSettingsPage_deleteConfirmationDescription,
          onDeletePressed: () {
            ref.read(walletSettingsControllerProvider.notifier)
                .deleteWallet();
          },
        );
      },
    );
  }

  void _listenWalletDeleted(BuildContext context, WidgetRef ref) {
    ref.listen(walletSettingsControllerProvider.selectAsync((data) => data.walletDeleted), (previous, next) {
      next.then((walletDeleted) {
        if (walletDeleted) {
          Navigator.pop(context);
        }
      });
    });
  }
}
