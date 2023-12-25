import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/common/provider/current_account_provider.dart';
import 'package:moneymanager/data/providers.dart';
import 'package:moneymanager/data/repository/accounts_repository.dart';
import 'package:moneymanager/domain/account.dart';
import 'package:moneymanager/feature/account_settings/domain/account_settings_state.dart';
import 'package:moneymanager/service/providers.dart';

import '../../../data/repository/transactions_repository.dart';

final accountSettingsControllerProvider = AsyncNotifierProvider
    .autoDispose<AccountSettingsController, AccountSettingsState>(() {
  return AccountSettingsController();
});

class AccountSettingsController extends AutoDisposeAsyncNotifier<AccountSettingsState> {

  @override
  FutureOr<AccountSettingsState> build() async {
    final Account? currentAccount = await ref.watch(currentAccountOrNullProvider.future);

    return AccountSettingsState(
      account: currentAccount,
      accountDeleted: false,
    );
  }

  void deleteAccount() async {
    final Account? currentAccount = await ref.watch(currentAccountOrNullProvider.future);

    if (currentAccount != null) {
      // Delete transactions.
      final TransactionsRepository transactionsRepository = await ref
          .watch(transactionsRepositoryProvider);

      await transactionsRepository.deleteByAccountId(currentAccount.id);

      // Delete account.
      final AccountsRepository accountsRepository = await ref
          .watch(accountsRepositoryProvider);

      await accountsRepository.delete(currentAccount.id);

      // Reset current account id.
      Account? firstAccount = await accountsRepository.firstOrNull();
      final currentAccountService = await ref.watch(currentAccountServiceProvider);
      currentAccountService.setCurrentAccount(firstAccount?.id);

      // Update state.
      state = const AsyncValue.data(
        AccountSettingsState(
          account: null,
          accountDeleted: true,
        ),
      );
    }
  }
}
