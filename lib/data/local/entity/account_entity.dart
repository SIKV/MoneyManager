import 'package:isar/isar.dart';
import 'package:moneymanager/data/local/entity/currency_entity.dart';

part 'account_entity.g.dart';

@collection
class AccountEntity {
  final Id internalId;

  @Name("id")
  final String id;

  @Name("currency")
  final CurrencyEntity currency;

  AccountEntity({
    required this.id,
    required this.currency,
  }) : internalId = Isar.autoIncrement;
}
