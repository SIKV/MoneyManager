import 'package:moneymanager/domain/account.dart';
import '../domain/currency.dart';
import 'local/entity/account_entity.dart';
import 'local/entity/currency_entity.dart';

extension AccountEntityToDomain on AccountEntity {
  Account? toDomain() {
    final code = currency.code;
    final name = currency.name;
    final symbol = currency.symbol;

    if (code == null || name == null || symbol == null) {
      return null;
    }
    return Account(
      id: id,
      currency: Currency(
        code: code,
        name: name,
        symbol: symbol,
        emoji: currency.emoji,
      ),
    );
  }
}

extension DomainToAccountEntity on Account {
  AccountEntity toEntity() {
    return AccountEntity(
      id: id,
      currency: CurrencyEntity(
        code: currency.code,
        name: currency.name,
        symbol: currency.symbol,
        emoji: currency.emoji,
      ),
    );
  }
}
