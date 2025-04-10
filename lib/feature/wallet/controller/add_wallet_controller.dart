import 'dart:async';

import 'package:currency_picker/currency_picker.dart' as currency_picker;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/data/providers.dart';
import 'package:moneymanager/domain/currency.dart';
import 'package:moneymanager/local_preferences.dart';

import '../../../domain/wallet.dart';
import '../../../utils.dart';
import '../domain/add_wallet_state.dart';

final addWalletControllerProvider = AsyncNotifierProvider
    .autoDispose<AddWalletController, AddWalletState>(() {
      return AddWalletController();
    });

class AddWalletController extends AutoDisposeAsyncNotifier<AddWalletState> {

  @override
  FutureOr<AddWalletState> build() async {
    final accountRepository = await ref.watch(walletsRepositoryProvider);
    final accounts = await accountRepository.getAll();

    return AddWalletState(
      selectedCurrency: null,
      alreadyExists: false,
      isFirstWallet: accounts.isEmpty,
      walletAdded: false,
    );
  }

  void addWallet() async {
    final currentState = await future;
    final currency = currentState.selectedCurrency;

    if (currency != null) {
      final account = Wallet(
        id: generateUniqueInt(),
        currency: currency,
      );

      final accountExists = await isWalletExist(account.currency.code);
      if (accountExists) {
        return;
      }

      final accountsRepository = await ref.read(walletsRepositoryProvider);
      await accountsRepository.add(account);

      ref.read(localPreferencesProvider)
          .setCurrentWallet(account.id);

      state = AsyncValue.data(
          currentState.copyWith(
          walletAdded: true,
        )
      );
    }
  }

  void selectCurrency(currency_picker.Currency currency) async {
    final currentState = await future;

    state = AsyncValue.data(
        currentState.copyWith(
          alreadyExists: await isWalletExist(currency.code),
          selectedCurrency: Currency(
            code: currency.code,
            name: currency.name,
            symbol: currency.symbol,
            emoji: currency_picker.CurrencyUtils.currencyToEmoji(currency),
          ),
        )
    );
  }

  Future<bool> isWalletExist(String currencyCode) async {
    final accountsRepository = await ref.read(walletsRepositoryProvider);
    final accounts = await accountsRepository.getByCurrencyCode(currencyCode);
    return accounts.isNotEmpty;
  }
}
