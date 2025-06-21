import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
import 'package:moneymanager/data/local/entity/currency_entity.dart';

part 'wallet_entity.g.dart';

@Collection(ignore: {'props'})
class WalletEntity extends Equatable {
  @Name('id')
  final Id id;

  @Name('currency')
  final CurrencyEntity currency;

  const WalletEntity({
    required this.id,
    required this.currency,
  });

  WalletEntity.fromJson(Map<String, dynamic> json):
        id = json['id'] as Id,
        currency = CurrencyEntity.fromJson(json['currency']);

  @override
  List<Object?> get props => [id];
}
