import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/common/currency_formatter.dart';
import 'package:moneymanager/common/provider/current_wallet_provider.dart';
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
    final currentAccountOrNull = ref.watch(currentWalletOrNullProvider);
    final filterService = await ref.watch(filterServiceProvider);
    final currencyFormatter = ref.watch(currencyFormatterProvider);

    // Rebuild when a transaction added/updated/deleted.
    ref.watch(transactionsRepositoryUpdatedProvider);

    final transactionsRepository = await ref.watch(transactionsRepositoryProvider);
    int fromTimestamp = filterService.getRange().getFromTimestamp(DateTime.now());

    final transactions = await transactionsRepository.getAll(
      typeFilter: filterService.getType(),
      fromTimestamp: fromTimestamp,
    ).first;

    double amount = calculateAmount(transactions);
    String formattedAmount = currencyFormatter.format(amount, compact: true);

    return HeaderState(
      currentWallet: currentAccountOrNull.value,
      amount: amount,
      formattedAmount: formattedAmount,
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
