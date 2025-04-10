import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/domain/currency.dart';

part 'add_wallet_state.freezed.dart';

@freezed
class AddWalletState with _$AddWalletState {
  const factory AddWalletState({
    required Currency? selectedCurrency,
    required bool alreadyExists,
    required bool isFirstWallet,
    required bool walletAdded,
  }) = _AddWalletState;
}
