import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/domain/currency.dart';

part 'account.freezed.dart';

@freezed
class Account with _$Account {
  const factory Account({
    required String id,
    required Currency currency,
  }) = _Account;
}
