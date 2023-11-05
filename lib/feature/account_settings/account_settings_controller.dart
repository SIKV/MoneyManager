import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/account.dart';
import 'package:moneymanager/feature/account_settings/account_settings_state.dart';

import '../../data/providers.dart';
import '../../local_preferences.dart';

final accountSettingsControllerProvider = AsyncNotifierProvider
    .autoDispose<AccountSettingsController, AccountSettingsState>(() {
  return AccountSettingsController();
});

class AccountSettingsController extends AutoDisposeAsyncNotifier<AccountSettingsState> {

  @override
  FutureOr<AccountSettingsState> build() async {
    Account? account;

    final preferences = ref.watch(localPreferencesProvider);
    final currentAccountId = preferences.currentAccountId;

    if (currentAccountId != null) {
      final accountRepository = await ref.watch(accountsRepositoryProvider);
      account = await accountRepository.getById(currentAccountId);
    }

    return AccountSettingsState(
      account: account,
      accountDeleted: false,
    );
  }

  void deleteAccount() {
    // TODO: Implement.
  }
}
