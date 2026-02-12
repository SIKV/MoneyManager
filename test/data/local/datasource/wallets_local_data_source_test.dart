import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:moneymanager/data/local/datasource/wallets_local_data_source.dart';
import 'package:moneymanager/data/local/entity/wallet_entity.dart';
import 'package:moneymanager/data/local/entity/currency_entity.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Isar isar;
  late WalletsLocalDataSource dataSource;

  setUp(() async {
    await Isar.initializeIsarCore(download: true);

    isar = await Isar.open([WalletEntitySchema],
      name: 'wallets_test_db',
      directory: '',
      inspector: false,
    );

    dataSource = WalletsLocalDataSource(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  test('add() adds wallet to database', () async {
    const wallet = WalletEntity(
      id: 1,
      currency: CurrencyEntity(code: 'USD', symbol: '\$'),
    );

    await dataSource.add(wallet);
    final result = await dataSource.getById(wallet.id);

    expect(result, equals(wallet));
  });

  test('getById() returns null when wallet does not exist', () async {
    final result = await dataSource.getById(123);
    expect(result, isNull);
  });

  test('getByCurrencyCode() returns found wallets', () async {
    const wallet1 = WalletEntity(
      id: 1,
      currency: CurrencyEntity(code: 'USD', symbol: '\$'),
    );
    const wallet2 = WalletEntity(
      id: 2,
      currency: CurrencyEntity(code: 'EUR', symbol: '€'),
    );

    await dataSource.add(wallet1);
    await dataSource.add(wallet2);

    final result = await dataSource.getByCurrencyCode('USD');

    expect(result, equals([wallet1]));
  });

  test('getAll() returns empty list when no wallets exist', () async {
    final result = await dataSource.getAll();
    expect(result, isEmpty);
  });

  test('getAll() returns all wallets in the database', () async {
    const wallet1 = WalletEntity(
      id: 1,
      currency: CurrencyEntity(code: 'USD', symbol: '\$'),
    );
    const wallet2 = WalletEntity(
      id: 2,
      currency: CurrencyEntity(code: 'EUR', symbol: '€'),
    );

    await dataSource.add(wallet1);
    await dataSource.add(wallet2);

    final result = await dataSource.getAll();

    expect(result, equals([wallet1, wallet2]));
  });

  // TODO: Test delete()
}
