import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';
import 'package:moneymanager/data/local/entity/currency_entity.dart';

part 'account_entity.g.dart';

@Collection(ignore: {'props'})
class AccountEntity extends Equatable {
  @Name("id")
  final Id id;

  @Name("currency")
  final CurrencyEntity currency;

  const AccountEntity({
    required this.id,
    required this.currency,
  });

  @override
  List<Object?> get props => [id];
}
