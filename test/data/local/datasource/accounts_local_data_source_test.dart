import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:moneymanager/data/local/datasource/accounts_local_data_source.dart';
import 'package:moneymanager/data/local/entity/account_entity.dart';
import 'package:moneymanager/data/local/entity/currency_entity.dart';

void main() {
  late Isar isar;
  late AccountsLocalDataSource dataSource;

  setUp(() async {
    await Isar.initializeIsarCore(download: true);

    isar = await Isar.open([AccountEntitySchema],
      name: 'accounts_test_db',
      directory: '',
      inspector: false,
    );

    dataSource = AccountsLocalDataSource(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  test('add() adds account to database', () async {
    const account = AccountEntity(
      id: 1,
      currency: CurrencyEntity(code: 'USD', symbol: '\$'),
    );

    await dataSource.add(account);
    final result = await dataSource.getById(account.id);

    expect(result, equals(account));
  });

  test('getById() returns null when account does not exist', () async {
    final result = await dataSource.getById(123);
    expect(result, isNull);
  });

  test('getByCurrencyCode() returns found accounts', () async {
    const account1 = AccountEntity(
      id: 1,
      currency: CurrencyEntity(code: 'USD', symbol: '\$'),
    );
    const account2 = AccountEntity(
      id: 2,
      currency: CurrencyEntity(code: 'EUR', symbol: '€'),
    );

    await dataSource.add(account1);
    await dataSource.add(account2);

    final result = await dataSource.getByCurrencyCode('USD');

    expect(result, equals([account1]));
  });

  test('getAll() returns empty list when no accounts exist', () async {
    final result = await dataSource.getAll();
    expect(result, isEmpty);
  });

  test('getAll() returns all accounts in the database', () async {
    const account1 = AccountEntity(
      id: 1,
      currency: CurrencyEntity(code: 'USD', symbol: '\$'),
    );
    const account2 = AccountEntity(
      id: 2,
      currency: CurrencyEntity(code: 'EUR', symbol: '€'),
    );

    await dataSource.add(account1);
    await dataSource.add(account2);

    final result = await dataSource.getAll();

    expect(result, equals([account1, account2]));
  });

  // TODO: Test delete()
}
