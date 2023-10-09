import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/common/provider/current_account_provider.dart';
import 'package:moneymanager/data/providers.dart';
import 'package:moneymanager/feature/transactions/domain/header_state.dart';
import 'package:moneymanager/feature/transactions/domain/transaction_range_filter.dart';
import 'package:moneymanager/feature/transactions/extensions.dart';
import 'package:moneymanager/feature/transactions/service/providers.dart';

import '../../../domain/transaction_type_filter.dart';

final headerControllerProvider = AsyncNotifierProvider<HeaderController, HeaderState>(() {
  return HeaderController();
});

class HeaderController extends AsyncNotifier<HeaderState> {

  @override
  FutureOr<HeaderState> build() async {
    final currentAccount = ref.watch(currentAccountProvider);
    final filterService = await ref.watch(filterServiceProvider);

    final transactionsRepository = await ref.watch(transactionsRepositoryProvider);
    int fromTimestamp = filterService.getRange().getFromTimestamp(DateTime.now());

    final transactions = await transactionsRepository.getAll(
      typeFilter: filterService.getType(),
      fromTimestamp: fromTimestamp,
    ).first;

    final amount = calculateAmount(transactions).toString();

    return HeaderState(
      currentAccount: currentAccount.value,
      amount: amount,
      transactionsCount: transactions.length,
      typeFilter: filterService.getType(),
      rangeFilter: filterService.getRange(),
      typeFilters: filterService.getTypes(),
      rangeFilters: filterService.getRanges(),
    );
  }

  void setTypeFilter(TransactionTypeFilter type) async {
    (await ref.watch(filterServiceProvider))
        .setType(type);

    ref.invalidateSelf();
  }

  void setRangeFilter(TransactionRangeFilter range) async {
    (await ref.watch(filterServiceProvider))
        .setRange(range);

    ref.invalidateSelf();
  }
}
