import 'package:moneymanager/data/mapping.dart';

import '../../domain/wallet.dart';
import '../local/datasource/wallets_local_data_source.dart';

class WalletsRepository {
  final WalletsLocalDataSource localDataSource;

  WalletsRepository(this.localDataSource);

  Future<void> add(Wallet wallet) async {
    return localDataSource.add(wallet.toEntity());
  }

  Future<Wallet?> firstOrNull() async {
    final wallet = await localDataSource.firstOrNull();
    return wallet?.toDomain();
  }

  Future<Wallet?> getById(int id) async {
    final wallet = await localDataSource.getById(id);
    return wallet?.toDomain();
  }

  Future<List<Wallet>> getByCurrencyCode(String currencyCode) async {
    return (await localDataSource.getByCurrencyCode(currencyCode))
        .map((it) => it.toDomain())
        .whereType<Wallet>()
        .toList();
  }

  Future<List<Wallet>> getAll() async {
    return (await localDataSource.getAll())
        .map((it) => it.toDomain())
        .whereType<Wallet>()
        .toList();
  }

  Future<void> delete(int id) async {
    return localDataSource.delete(id);
  }
}
