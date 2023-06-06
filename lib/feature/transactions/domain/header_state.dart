import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/feature/transactions/domain/transaction_filter.dart';

import '../../../domain/account.dart';

part 'header_state.freezed.dart';

@freezed
class HeaderState with _$HeaderState {
  const factory HeaderState({
    required Account? currentAccount,
    required String amount,
    required int transactionCount,
    required TransactionFilter currentFilter,
    required List<TransactionFilter> filters,
  }) = _HeaderState;
}
