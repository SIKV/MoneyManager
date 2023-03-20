import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/domain/currency.dart';
import 'package:moneymanager/feature/transaction/domain/transaction_blueprint.dart';
import 'package:moneymanager/feature/transaction/domain/transaction_property.dart';

import '../../../domain/transaction_category.dart';
import '../../../domain/transaction_subcategory.dart';
import '../../../domain/transaction_type.dart';

part 'transaction_maker_state.freezed.dart';

@freezed
class TransactionMakerState with _$TransactionMakerState {
  const factory TransactionMakerState({
    required TransactionBlueprint transaction,
    required TransactionProperty selectedProperty,
    required List<TransactionCategory> categories,
  }) = _TransactionMakerState;
}
