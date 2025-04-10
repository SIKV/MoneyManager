import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/navigation/routes.dart';
import 'package:moneymanager/theme/dimens.dart';
import 'package:moneymanager/ui/widget/panel.dart';

import '../../domain/wallet.dart';
import '../../theme/spacings.dart';
import 'controller/change_wallet_controller.dart';

class ChangeWalletPage extends ConsumerWidget {
  const ChangeWalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(changeWalletControllerProvider);

    return state.when(
      loading: () => Container(),
      error: (_, __) => SizedBox(
        height: Dimens.changeWalletPageHeight,
        child: Center(
          child: Text(AppLocalizations.of(context)!.generalErrorMessage),
        ),
      ),
      data: (state) => Panel(
        title: AppLocalizations.of(context)!.changeWalletPage_title,
        child: _WalletsList(
          wallets: state.wallets,
          currentWallet: state.currentWallet,
        ),
      ),
    );
  }
}

class _WalletsList extends ConsumerWidget {
  final List<Wallet> wallets;
  final Wallet? currentWallet;

  const _WalletsList({
    required this.wallets,
    required this.currentWallet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIcon = Icon(Icons.radio_button_checked,
      color: Theme.of(context).colorScheme.primary,
    );

    const unselectedIcon = Icon(Icons.circle_outlined);

    const selectedTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
    );

    return ListView.builder(
      shrinkWrap: true,
      itemCount: wallets.length + 1,
      itemBuilder: (context, index) {
        if (index >= wallets.length) {
          return ListTile(
            onTap: () => _addWallet(context),
            leading: const Icon(Icons.add),
            title: Text(AppLocalizations.of(context)!.changeWalletPage_addWalletButton),
          );
        } else {
          final wallet = wallets[index];

          return ListTile(
            onTap: () => _selectWallet(context, ref, wallet),
            contentPadding: const EdgeInsets.only(
              left: Spacings.four,
              right: Spacings.three,
            ),
            leading: wallet == currentWallet ? selectedIcon : unselectedIcon,
            title: Text(wallet.currency.code,
              style: wallet == currentWallet ? selectedTextStyle : null,
            ),
            subtitle: Text(wallet.currency.name),
          );
        }
      },
    );
  }

  void _addWallet(BuildContext context) {
    Navigator.pop(context);
    Navigator.pushNamed(context, AppRoutes.addWallet);
  }

  void _selectWallet(BuildContext context, WidgetRef ref, Wallet wallet) {
    ref.read(changeWalletControllerProvider.notifier)
        .selectWallet(wallet);

    Navigator.pop(context);
  }
}
