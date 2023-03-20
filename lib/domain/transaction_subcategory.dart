import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_subcategory.freezed.dart';

@freezed
class TransactionSubcategory with _$TransactionSubcategory {
  const factory TransactionSubcategory({
    required int id,
    required String title,
  }) = _TransactionSubcategory;
}
