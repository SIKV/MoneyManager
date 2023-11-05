import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/domain/account.dart';

part 'account_settings_state.freezed.dart';

@freezed
class AccountSettingsState with _$AccountSettingsState {
  const factory AccountSettingsState({
    required Account? account,
    required bool accountDeleted,
  }) = _AccountSettingsState;
}
