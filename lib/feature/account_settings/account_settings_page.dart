import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/ui/widget/delete_button.dart';
import 'package:moneymanager/ui/widget/small_section_text.dart';

import '../../theme/spacings.dart';
import '../../ui/widget/delete_confirmation.dart';
import 'controller/account_settings_controller.dart';

class AccountSettingsPage extends ConsumerWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accountSettingsControllerProvider);

    _listenAccountDeleted(context, ref);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Text(AppLocalizations.of(context)!.accountSettings),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacings.four),
              child: SmallSectionText(state.value?.account?.currency.name ?? ''),
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
                    onPressed: () => _deleteAccount(context, ref),
                    title: AppLocalizations.of(context)!.deleteAccount,
                  ),
                  const SizedBox(height: Spacings.four),
                  SmallSectionText(AppLocalizations.of(context)!.deleteAccountWarning),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteAccount(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteConfirmation(
          title: AppLocalizations.of(context)!.deleteAccountTitle,
          description: AppLocalizations.of(context)!.deleteAccountDescription,
          onDeletePressed: () {
            ref.read(accountSettingsControllerProvider.notifier)
                .deleteAccount();
          },
        );
      },
    );
  }

  void _listenAccountDeleted(BuildContext context, WidgetRef ref) {
    ref.listen(accountSettingsControllerProvider.selectAsync((data) => data.accountDeleted), (previous, next) {
      next.then((accountDeleted) {
        if (accountDeleted) {
          Navigator.pop(context);
        }
      });
    });
  }
}
