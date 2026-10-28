import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:moneymanager/data/local/entity/currency_entity.dart';
import 'package:moneymanager/data/local/entity/transaction_category_entity.dart';
import 'package:moneymanager/data/local/entity/transaction_entity.dart';
import 'package:moneymanager/data/local/entity/transaction_type_entity.dart';
import 'package:moneymanager/data/local/entity/wallet_entity.dart';
import 'package:moneymanager/service/backup/backup_data.dart';
import 'package:moneymanager/service/backup/utils.dart';

import '../../isar_test_utils.dart';

void main() {
  late Isar isar;

  setUp(() async {
    await initializeIsarCoreForTests();

    isar = await Isar.open([
      WalletEntitySchema,
      TransactionCategoryEntitySchema,
      TransactionEntitySchema,
    ],
      name: 'backup_test_db',
      directory: '',
      inspector: false,
    );
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  WalletEntity wallet(int id) => WalletEntity(
    id: id,
    currency: const CurrencyEntity(code: 'USD', symbol: '\$'),
  );

  TransactionCategoryEntity category(int id) => TransactionCategoryEntity(
    id: id,
    createTimestamp: 123456789,
    type: TransactionTypeEntity.expense,
    title: 'Food',
    emoji: null,
    archived: false,
  );

  TransactionEntity transaction(int id, {required int walletId, required int categoryId}) => TransactionEntity(
    id: id,
    walletId: walletId,
    createTimestamp: 123456789,
    type: TransactionTypeEntity.expense,
    categoryId: categoryId,
    amount: 100.0,
    note: null,
  );

  Future<String> exportJson() async {
    return jsonEncode({
      'wallets': await isar.walletEntitys.where().exportJson(),
      'categories': await isar.transactionCategoryEntitys.where().exportJson(),
      'transactions': await isar.transactionEntitys.where().exportJson(),
    });
  }

  test('parseJsonBackup() reads exported data', () async {
    // GIVEN
    await isar.writeTxn(() async {
      await isar.walletEntitys.put(wallet(1));
      await isar.transactionCategoryEntitys.put(category(2));
      await isar.transactionEntitys.put(transaction(3, walletId: 1, categoryId: 2));
    });

    // WHEN
    final backup = parseJsonBackup(await exportJson());

    // THEN
    expect(backup.wallets, equals([wallet(1)]));
    expect(backup.categories, equals([category(2)]));
    expect(backup.transactions, equals([transaction(3, walletId: 1, categoryId: 2)]));
    expect(backup.transactions.single.amount, equals(100.0));
  });

  test('parseJsonBackup() throws when a collection is missing', () {
    final content = jsonEncode({'wallets': [], 'categories': []});

    expect(() => parseJsonBackup(content), throwsA(anything));
  });

  test('parseJsonBackup() throws when content is not JSON', () {
    expect(() => parseJsonBackup('not a backup'), throwsA(anything));
  });

  test('writeBackupToDatabase() replaces existing data', () async {
    // GIVEN
    await isar.writeTxn(() async {
      await isar.walletEntitys.putAll([wallet(1), wallet(10)]);
      await isar.transactionCategoryEntitys.putAll([category(2), category(20)]);
      await isar.transactionEntitys.putAll([
        transaction(3, walletId: 1, categoryId: 2),
        transaction(30, walletId: 10, categoryId: 20),
      ]);
    });

    final backup = BackupData(
      wallets: [wallet(1), wallet(100)],
      categories: [category(200)],
      transactions: [transaction(300, walletId: 100, categoryId: 200)],
    );

    // WHEN
    writeBackupToDatabase(isar, backup);

    // THEN
    expect(await isar.walletEntitys.where().findAll(), equals([wallet(1), wallet(100)]));
    expect(await isar.transactionCategoryEntitys.where().findAll(), equals([category(200)]));
    expect(
      await isar.transactionEntitys.where().findAll(),
      equals([transaction(300, walletId: 100, categoryId: 200)]),
    );
  });
}
