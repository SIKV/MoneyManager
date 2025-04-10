import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/data/providers.dart';
import 'package:moneymanager/domain/wallet.dart';

import '../../../local_preferences.dart';
import '../domain/change_wallet_state.dart';

final changeWalletControllerProvider = AsyncNotifierProvider
    .autoDispose<ChangeWalletController, ChangeWalletState>(() {
      return ChangeWalletController();
    });

class ChangeWalletController extends AutoDisposeAsyncNotifier<ChangeWalletState> {

  @override
  FutureOr<ChangeWalletState> build() async {
    final accountRepository = await ref.watch(walletsRepositoryProvider);
    final accounts = await accountRepository.getAll();

    final preferences = ref.watch(localPreferencesProvider);
    final currentAccountId = preferences.currentWalletId;

    return ChangeWalletState(
      wallets: accounts,
      currentWallet: accounts.firstWhereOrNull((it) => it.id == currentAccountId),
    );
  }

  void selectWallet(Wallet account) {
    final preferences = ref.read(localPreferencesProvider);
    preferences.setCurrentWallet(account.id);

    ref.invalidateSelf();
  }
}
