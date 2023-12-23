import 'package:moneymanager/data/mapping.dart';

import '../../domain/account.dart';
import '../local/datasource/accounts_local_data_source.dart';

class AccountsRepository {
  final AccountsLocalDataSource localDataSource;

  AccountsRepository(this.localDataSource);

  Future<void> add(Account account) async {
    return localDataSource.add(account.toEntity());
  }

  Future<Account?> getById(int id) async {
    final account = await localDataSource.getById(id);
    return account?.toDomain();
  }

  Future<List<Account>> getByCurrencyCode(String currencyCode) async {
    return (await localDataSource.getByCurrencyCode(currencyCode))
        .map((it) => it.toDomain())
        .whereType<Account>()
        .toList();
  }

  Future<List<Account>> getAll() async {
    return (await localDataSource.getAll())
        .map((it) => it.toDomain())
        .whereType<Account>()
        .toList();
  }
}
