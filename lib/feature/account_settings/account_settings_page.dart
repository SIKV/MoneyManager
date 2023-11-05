import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/ui/widget/delete_button.dart';
import 'package:moneymanager/ui/widget/small_section_text.dart';

import '../../theme/spacings.dart';
import 'account_settings_controller.dart';

class AccountSettingsPage extends ConsumerWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accountSettingsControllerProvider);

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
                    onPressed: () { },
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
}
