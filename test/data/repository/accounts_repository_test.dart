import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moneymanager/data/local/datasource/accounts_local_data_source.dart';
import 'package:moneymanager/data/local/entity/account_entity.dart';
import 'package:moneymanager/data/local/entity/currency_entity.dart';
import 'package:moneymanager/data/mapping.dart';
import 'package:moneymanager/data/repository/accounts_repository.dart';
import 'package:moneymanager/domain/account.dart';
import 'package:moneymanager/domain/currency.dart';

class AccountsLocalDataSourceMock extends Mock implements AccountsLocalDataSource { }

const accountEntityMock = AccountEntity(
  id: 0,
  currency: CurrencyEntity(),
);

void main() {
  setUpAll(() {
    registerFallbackValue(accountEntityMock);
  });

  test('add() updates LocalDataSource', () async {
    // GIVEN
    final localDataSourceMock = AccountsLocalDataSourceMock();

    when(() => localDataSourceMock.add(any()))
        .thenAnswer((_) async {});

    final repository = AccountsRepository(localDataSourceMock);

    const account = Account(
      id: 0,
      currency: Currency(
        code: 'code',
        name: 'name',
        symbol: 'symbol',
        emoji: 'emoji',
      ),
    );

    // WHEN
    await repository.add(account);

    // THEN
    verify(() => localDataSourceMock.add(account.toEntity()))
        .called(1);
  });

  test('getAll() returns entities from LocalDataSource', () async {
    // GIVEN
    const accounts = [
      Account(
        id: 0,
        currency: Currency(
          code: 'code',
          name: 'name',
          symbol: 'symbol',
          emoji: 'emoji',
        ),
      ),
    ];

    final localDataSourceMock = AccountsLocalDataSourceMock();

    when(() => localDataSourceMock.getAll())
        .thenAnswer((_) async {
      return accounts.map((it) => it.toEntity()).toList();
    });

    final repository = AccountsRepository(localDataSourceMock);

    // WHEN
    final actualAccounts = await repository.getAll();

    // THEN
    expect(actualAccounts, accounts);

    verify(() => localDataSourceMock.getAll())
        .called(1);
  });

  // TODO: Test delete()
}
