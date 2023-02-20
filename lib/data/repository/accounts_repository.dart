import 'package:moneymanager/data/mapping.dart';

import '../../domain/account.dart';
import '../local/datasource/accounts_local_data_source.dart';

class AccountsRepository {
  final AccountsLocalDataSource localDataSource;

  AccountsRepository(this.localDataSource);

  Future<void> addOrUpdate(Account account) async {
    return localDataSource.addOrUpdate(account.toEntity());
  }

  Future<List<Account>> getAll() async {
    final accounts = await localDataSource.getAll();
    return accounts
        .map((it) => it.toDomain())
        .whereType<Account>()
        .toList();
  }
}
