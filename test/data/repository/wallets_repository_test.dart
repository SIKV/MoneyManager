import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moneymanager/data/local/datasource/wallets_local_data_source.dart';
import 'package:moneymanager/data/local/entity/wallet_entity.dart';
import 'package:moneymanager/data/local/entity/currency_entity.dart';
import 'package:moneymanager/data/mapping.dart';
import 'package:moneymanager/data/repository/wallets_repository.dart';
import 'package:moneymanager/domain/wallet.dart';
import 'package:moneymanager/domain/currency.dart';

class WalletsLocalDataSourceMock extends Mock implements WalletsLocalDataSource { }

const walletEntityMock = WalletEntity(
  id: 0,
  currency: CurrencyEntity(),
);

void main() {
  setUpAll(() {
    registerFallbackValue(walletEntityMock);
  });

  test('add() updates LocalDataSource', () async {
    // GIVEN
    final localDataSourceMock = WalletsLocalDataSourceMock();

    when(() => localDataSourceMock.add(any()))
        .thenAnswer((_) async {});

    final repository = WalletsRepository(localDataSourceMock);

    const wallet = Wallet(
      id: 0,
      currency: Currency(
        code: 'code',
        name: 'name',
        symbol: 'symbol',
        emoji: 'emoji',
      ),
    );

    // WHEN
    await repository.add(wallet);

    // THEN
    verify(() => localDataSourceMock.add(wallet.toEntity()))
        .called(1);
  });

  test('getAll() returns entities from LocalDataSource', () async {
    // GIVEN
    const wallets = [
      Wallet(
        id: 0,
        currency: Currency(
          code: 'code',
          name: 'name',
          symbol: 'symbol',
          emoji: 'emoji',
        ),
      ),
    ];

    final localDataSourceMock = WalletsLocalDataSourceMock();

    when(() => localDataSourceMock.getAll())
        .thenAnswer((_) async {
      return wallets.map((it) => it.toEntity()).toList();
    });

    final repository = WalletsRepository(localDataSourceMock);

    // WHEN
    final actualWallets = await repository.getAll();

    // THEN
    expect(actualWallets, wallets);

    verify(() => localDataSourceMock.getAll())
        .called(1);
  });

  // TODO: Test delete()
}
