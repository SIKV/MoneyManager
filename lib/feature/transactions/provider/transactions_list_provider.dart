import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/common/provider/current_wallet_provider.dart';
import 'package:moneymanager/feature/transactions/service/providers.dart';

import '../../../data/providers.dart';

final transactionsListProvider = StreamProvider((ref) async* {
  // Rebuild when the current account changed.
  ref.watch(currentWalletProvider);
  // Rebuild when a category added/updated/deleted.
  ref.watch(categoriesRepositoryUpdatedProvider);
  // Rebuild when the current type filter changed.
  final currentTypeFilter = ref.watch(currentTypeFilterProvider).value;
  // Rebuild when the current range filter changed.
  final currentRangeFilter = ref.watch(currentRangeFilterProvider).value;

  // TODO: This is a temporary fix.
  // When a new transaction is added Isar doesn't emit a new value. It works when deleting or updating one.
  // Rebuild when a transaction added/updated/deleted.
  ref.watch(transactionsRepositoryUpdatedProvider);

  final transactionService = await ref.watch(transactionServiceProvider);

  if (currentTypeFilter != null && currentRangeFilter != null) {
    yield* transactionService.getFiltered(currentTypeFilter, currentRangeFilter);
  } else {
    yield* const Stream.empty();
  }
});
