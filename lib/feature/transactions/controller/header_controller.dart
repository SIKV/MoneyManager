import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/common/provider/current_account_provider.dart';
import 'package:moneymanager/feature/transactions/domain/header_state.dart';
import 'package:moneymanager/feature/transactions/domain/transaction_filter.dart';
import 'package:moneymanager/feature/transactions/service/providers.dart';

final headerControllerProvider = AsyncNotifierProvider<HeaderController, HeaderState>(() {
  return HeaderController();
});

class HeaderController extends AsyncNotifier<HeaderState> {

  @override
  FutureOr<HeaderState> build() async {
    final currentAccount = ref.watch(currentAccountProvider);
    final filterService = await ref.watch(filterServiceProvider);

    return HeaderState(
      currentAccount: currentAccount.value,
      amount: '100',
      transactionCount: 0,
      currentFilter: filterService.getFilter(),
      filters: TransactionFilter.values,
    );
  }

  void selectFilter(TransactionFilter filter) async {
    (await ref.watch(filterServiceProvider))
        .setFilter(filter);

    ref.invalidateSelf();
  }
}
