import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/feature/transaction/domain/transaction_blueprint.dart';
import 'package:moneymanager/feature/transaction/domain/transaction_property.dart';
import 'package:moneymanager/feature/transaction/domain/ui_mode.dart';
import 'package:moneymanager/feature/transaction/domain/validation_error.dart';

import '../../../domain/transaction_category.dart';

part 'transaction_maker_state.freezed.dart';

@freezed
class TransactionMakerState with _$TransactionMakerState {
  const factory TransactionMakerState({
    required UiMode uiMode,
    required TransactionProperty selectedProperty,
    required List<TransactionCategory> categories,
    required TransactionBlueprint transaction,
    required ValidationError? validationError,
    required bool transactionSaved,
  }) = _TransactionMakerState;
}
