import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/domain/wallet.dart';

part 'wallet_settings_state.freezed.dart';

@freezed
class WalletSettingsState with _$WalletSettingsState {
  const factory WalletSettingsState({
    required Wallet? wallet,
    required bool walletDeleted,
  }) = _WalletSettingsState;
}
