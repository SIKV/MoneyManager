import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/common/provider/current_account_provider.dart';
import 'package:moneymanager/feature/transactions/service/providers.dart';

import '../../../data/providers.dart';

final transactionsListProvider = StreamProvider((ref) async* {
  // Rebuild when the current account changed.
  ref.watch(currentAccountProvider);
  // Rebuild when a category added/updated/deleted.
  ref.watch(categoriesRepositoryUpdatedProvider);
  // Rebuild when the current filter changed.
  final currentFilter = ref.watch(currentFilterProvider).value;

  final transactionService = await ref.watch(transactionServiceProvider);

  if (currentFilter != null) {
    yield* transactionService.getFiltered(currentFilter);
  } else {
    yield* const Stream.empty();
  }
});
