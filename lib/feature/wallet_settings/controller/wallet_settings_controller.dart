import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/common/provider/current_wallet_provider.dart';
import 'package:moneymanager/data/providers.dart';
import 'package:moneymanager/data/repository/wallets_repository.dart';
import 'package:moneymanager/domain/wallet.dart';
import 'package:moneymanager/service/providers.dart';

import '../../../data/repository/transactions_repository.dart';
import '../domain/wallet_settings_state.dart';

final walletSettingsControllerProvider = AsyncNotifierProvider
    .autoDispose<WalletSettingsController, WalletSettingsState>(() {
  return WalletSettingsController();
});

class WalletSettingsController extends AutoDisposeAsyncNotifier<WalletSettingsState> {

  @override
  FutureOr<WalletSettingsState> build() async {
    final Wallet? currentWallet = await ref.watch(currentWalletOrNullProvider.future);

    return WalletSettingsState(
      wallet: currentWallet,
      walletDeleted: false,
    );
  }

  void deleteWallet() async {
    final Wallet? currentWallet = await ref.watch(currentWalletOrNullProvider.future);

    if (currentWallet != null) {
      // Delete transactions.
      final TransactionsRepository transactionsRepository = await ref
          .watch(transactionsRepositoryProvider);

      await transactionsRepository.deleteByWalletId(currentWallet.id);

      // Delete wallet.
      final WalletsRepository accountsRepository = await ref
          .watch(walletsRepositoryProvider);

      await accountsRepository.delete(currentWallet.id);

      // Reset current account id.
      Wallet? firstAccount = await accountsRepository.firstOrNull();
      final currentAccountService = await ref.watch(currentWalletServiceProvider);
      currentAccountService.setCurrentWallet(firstAccount?.id);

      // Update state.
      state = const AsyncValue.data(
        WalletSettingsState(
          wallet: null,
          walletDeleted: true,
        ),
      );
    }
  }
}
