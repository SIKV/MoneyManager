import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction.dart';
import 'package:moneymanager/domain/transaction_category.dart';
import 'package:moneymanager/domain/transaction_type.dart';
import 'package:moneymanager/feature/transaction/domain/transaction_property.dart';
import 'package:moneymanager/utils.dart';

import '../domain/transaction_maker_state.dart';

final transactionMakerProvider = NotifierProvider
    .autoDispose<_TransactionMakerNotifier, TransactionMakerState>(() {
      return _TransactionMakerNotifier();
});

class _TransactionMakerNotifier extends AutoDisposeNotifier<TransactionMakerState> {
  TransactionMakerState _state = TransactionMakerState(
    transactionId: generateUniqueId(),
    createdAt: DateTime.now().millisecondsSinceEpoch,
    type: TransactionType.expense,
    category: null,
    subcategory: null,
    amount: 0,
    note: null,
    selectedProperty: TransactionProperty.category,
  );

  @override
  TransactionMakerState build() {
    return _state;
  }

  void setTransaction(Transaction transaction) {
    _state = _state.copyWith(
      transactionId: transaction.id,
      createdAt: transaction.createdAt,
      type: transaction.type,
      category: transaction.category,
      subcategory: transaction.subcategory,
      amount: transaction.amount,
      note: transaction.note,
    );
    ref.invalidateSelf();
  }

  void selectProperty(TransactionProperty value) {
    _state = _state.copyWith(
        selectedProperty: value
    );
    ref.invalidateSelf();
  }

  void setType(TransactionType type) {
    // TODO: Reset category.
    _state = _state.copyWith(
      type: type,
    );
    ref.invalidateSelf();
  }

  void setCategory(TransactionCategory category) {
    _state = _state.copyWith(
      category: category,
    );
    ref.invalidateSelf();
  }

  void save() {
    // TODO: Implement
  }
}
