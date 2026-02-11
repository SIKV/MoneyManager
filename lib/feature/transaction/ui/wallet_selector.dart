import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/provider/current_wallet_provider.dart';
import '../../../navigation/routes.dart';

class WalletSelector extends ConsumerWidget {
  final bool isEnabled;

  const WalletSelector({
    super.key,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentAccount = ref.watch(currentWalletProvider);

    return currentAccount.whenOrNull(
      data: (currentAccount) =>
          InkWell(
            onTap: isEnabled ? () {
              _showChangeWallet(context);
            } : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(currentAccount.currency.code),
                if (isEnabled) const Icon(Icons.keyboard_arrow_down_rounded)
              ],
            ),
          )
    ) ?? Container();
  }

  void _showChangeWallet(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.changeWalletModal);
  }
}
