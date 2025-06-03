import 'dart:ffi';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/feature/search/domain/search_error.dart';

import '../../common/domain/transaction_item_ui_model.dart';

part 'search_state.freezed.dart';

@freezed
class SearchState with _$SearchState {
  const factory SearchState({
    required bool didSearch,
    required List<TransactionUiModel> searchResult,
    SearchError? error,
  }) = _SearchState;
}
