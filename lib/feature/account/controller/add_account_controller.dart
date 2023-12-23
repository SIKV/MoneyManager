import 'dart:async';

import 'package:currency_picker/currency_picker.dart' as currency_picker;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/data/providers.dart';
import 'package:moneymanager/domain/currency.dart';
import 'package:moneymanager/feature/account/domain/add_account_state.dart';
import 'package:moneymanager/local_preferences.dart';

import '../../../domain/account.dart';
import '../../../utils.dart';

final addAccountControllerProvider = AsyncNotifierProvider
    .autoDispose<AddAccountController, AddAccountState>(() {
      return AddAccountController();
    });

class AddAccountController extends AutoDisposeAsyncNotifier<AddAccountState> {

  @override
  FutureOr<AddAccountState> build() async {
    final accountRepository = await ref.watch(accountsRepositoryProvider);
    final accounts = await accountRepository.getAll();

    return AddAccountState(
      selectedCurrency: null,
      alreadyExists: false,
      isFirstAccount: accounts.isEmpty,
      accountAdded: false,
    );
  }

  void addAccount() async {
    final currentState = await future;
    final currency = currentState.selectedCurrency;

    if (currency != null) {
      final account = Account(
        id: generateUniqueInt(),
        currency: currency,
      );

      final accountExists = await isAccountExist(account.currency.code);
      if (accountExists) {
        return;
      }

      final accountsRepository = await ref.read(accountsRepositoryProvider);
      await accountsRepository.add(account);

      ref.read(localPreferencesProvider)
          .setCurrentAccount(account.id);

      state = AsyncValue.data(
          currentState.copyWith(
          accountAdded: true,
        )
      );
    }
  }

  void selectCurrency(currency_picker.Currency currency) async {
    final currentState = await future;

    state = AsyncValue.data(
        currentState.copyWith(
          alreadyExists: await isAccountExist(currency.code),
          selectedCurrency: Currency(
            code: currency.code,
            name: currency.name,
            symbol: currency.symbol,
            emoji: currency_picker.CurrencyUtils.currencyToEmoji(currency),
          ),
        )
    );
  }

  Future<bool> isAccountExist(String currencyCode) async {
    final accountsRepository = await ref.read(accountsRepositoryProvider);
    final accounts = await accountsRepository.getByCurrencyCode(currencyCode);
    return accounts.isNotEmpty;
  }
}
