import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/domain/wallet.dart';

part 'change_wallet_state.freezed.dart';

@freezed
class ChangeWalletState with _$ChangeWalletState {
  const factory ChangeWalletState({
    required List<Wallet> wallets,
    Wallet? currentWallet,
  }) = _ChangeWalletState;
}
