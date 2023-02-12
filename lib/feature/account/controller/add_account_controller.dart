import 'dart:async';

import 'package:currency_picker/currency_picker.dart' as currency_picker;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/currency.dart';
import 'package:moneymanager/feature/account/domain/add_account_state.dart';

final addAccountControllerProvider = AsyncNotifierProvider
    .autoDispose<_AddAccountController, AddAccountState>(() {
      return _AddAccountController();
    });

class _AddAccountController extends AutoDisposeAsyncNotifier<AddAccountState> {
  AddAccountState _state = const AddAccountState(
    selectedCurrency: null,
    isFirstAccount: true,
    accountAdded: false,
  );

  @override
  FutureOr<AddAccountState> build() {
    // TODO: Implement [isFirstAccount]
    return _state;
  }

  void addAccount() {
    // TODO: Implement.
    _state = _state.copyWith(
      accountAdded: true,
    );
    ref.invalidateSelf();
  }

  void selectCurrency(currency_picker.Currency currency) {
    _state = _state.copyWith(
      selectedCurrency: Currency(
        code: currency.code,
        name: currency.name,
        symbol: currency.symbol,
        emoji: currency_picker.CurrencyUtils.currencyToEmoji(currency),
      ),
    );
    ref.invalidateSelf();
  }
}
