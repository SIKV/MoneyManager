import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/feature/transactions/domain/transaction_range_filter.dart';

import '../../../domain/wallet.dart';
import '../../../domain/transaction_type_filter.dart';

part 'header_state.freezed.dart';

@freezed
class HeaderState with _$HeaderState {
  const factory HeaderState({
    required Wallet? currentWallet,
    required String amount,
    required int transactionsCount,
    required TransactionTypeFilter typeFilter,
    required TransactionRangeFilter rangeFilter,
    required List<TransactionTypeFilter> typeFilters,
    required List<TransactionRangeFilter> rangeFilters,
  }) = _HeaderState;
}
