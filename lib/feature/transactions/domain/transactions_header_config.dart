import 'package:flutter/foundation.dart';
import 'package:moneymanager/feature/transactions/domain/transactions_header_value.dart';

@immutable
class TransactionsHeaderConfig {
  final List<TransactionsHeaderValue> values;
  final TransactionsHeaderValue selectedValue;

  const TransactionsHeaderConfig({
    required this.values,
    required this.selectedValue,
  });

  TransactionsHeaderConfig copyWith({
    List<TransactionsHeaderValue>? values,
    TransactionsHeaderValue? selectedValue,
  }) {
    return TransactionsHeaderConfig(
      values: values ?? this.values,
      selectedValue: selectedValue ?? this.selectedValue,
    );
  }
}
