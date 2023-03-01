import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/domain/account.dart';

part 'change_account_state.freezed.dart';

@freezed
class ChangeAccountState with _$ChangeAccountState {
  const factory ChangeAccountState({
    required List<Account> accounts,
    Account? currentAccount,
  }) = _ChangeAccountState;
}
