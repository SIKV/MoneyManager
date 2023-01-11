import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/transactions/domain/transactions_header_config.dart';
import 'package:moneymanager/feature/transactions/domain/transactions_header_value.dart';

final transactionsHeaderControllerProvider = AsyncNotifierProvider<
    TransactionsHeaderController, TransactionsHeaderConfig>(() {
      return TransactionsHeaderController();
});

class TransactionsHeaderController extends AsyncNotifier<TransactionsHeaderConfig> {
  TransactionsHeaderConfig _config = const TransactionsHeaderConfig(
    values: TransactionsHeaderValue.values,
    selectedValue: TransactionsHeaderValue.monthExpenses,
  );

  @override
  FutureOr<TransactionsHeaderConfig> build() {
    return _config;
  }

  void selectValue(TransactionsHeaderValue value) {
    _config = _config.copyWith(
      selectedValue: value
    );

    ref.invalidateSelf();
  }
}
