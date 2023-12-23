import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/domain/currency.dart';

part 'add_account_state.freezed.dart';

@freezed
class AddAccountState with _$AddAccountState {
  const factory AddAccountState({
    required Currency? selectedCurrency,
    required bool alreadyExists,
    required bool isFirstAccount,
    required bool accountAdded,
  }) = _AddAccountState;
}
