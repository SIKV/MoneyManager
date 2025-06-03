import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/common/currency_formatter.dart';
import 'package:moneymanager/feature/transactions/service/filter_service.dart';
import 'package:moneymanager/feature/transactions/service/transaction_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/providers.dart';
import '../../common/transaction_ui_model_mapper.dart';

final transactionServiceProvider = Provider((ref) async {
  final transactionsRepository = await ref.watch(transactionsRepositoryProvider);
  final currencyFormatter = ref.watch(currencyFormatterProvider);
  final mapper = TransactionUiModelMapper(currencyFormatter);
  return TransactionService(transactionsRepository, mapper);
});

final filterServiceProvider = Provider((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return FilterService(prefs);
});

final currentTypeFilterProvider = StreamProvider((ref) async* {
  final filterService = await ref.watch(filterServiceProvider);
  yield* filterService.onTypeChanged;
});

final currentRangeFilterProvider = StreamProvider((ref) async* {
  final filterService = await ref.watch(filterServiceProvider);
  yield* filterService.onRangeChanged;
});
