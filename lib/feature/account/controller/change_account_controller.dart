import 'dart:async';
import 'package:collection/collection.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/data/providers.dart';
import 'package:moneymanager/domain/account.dart';

import '../../../preferences.dart';
import '../domain/change_account_state.dart';

final changeAccountControllerProvider = AsyncNotifierProvider
    .autoDispose<ChangeAccountController, ChangeAccountState>(() {
      return ChangeAccountController();
    });

class ChangeAccountController extends AutoDisposeAsyncNotifier<ChangeAccountState> {
  @override
  FutureOr<ChangeAccountState> build() async {
    final accountRepository = await ref.watch(accountsRepositoryProvider.future);
    final accounts = await accountRepository.getAll();

    final preferences = ref.watch(preferencesProvider);
    final currentAccountId = preferences.currentAccountId;

    return ChangeAccountState(
      accounts: accounts,
      currentAccount: accounts.firstWhereOrNull((it) => it.id == currentAccountId),
    );
  }

  void selectAccount(Account account) {
    final preferences = ref.read(preferencesProvider);
    preferences.setCurrentAccount(account.id);
  }
}
