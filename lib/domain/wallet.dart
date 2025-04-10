import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/domain/currency.dart';

part 'wallet.freezed.dart';

@freezed
class Wallet with _$Wallet {
  const factory Wallet({
    required int id,
    required Currency currency,
  }) = _Wallet;
}
