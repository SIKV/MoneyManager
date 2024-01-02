import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:moneymanager/data/local/datasource/categories_local_data_source.dart';
import 'package:moneymanager/data/local/entity/transaction_category_entity.dart';
import 'package:moneymanager/data/local/entity/transaction_type_entity.dart';

void main() {
  late Isar isar;
  late CategoriesLocalDataSource dataSource;

  setUp(() async {
    await Isar.initializeIsarCore(download: true);

    isar = await Isar.open([TransactionCategoryEntitySchema],
      name: 'test_db',
      directory: '',
      inspector: false,
    );

    dataSource = CategoriesLocalDataSource(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  test('addOrUpdate() adds category to database', () async {
    // GIVEN
    const category = TransactionCategoryEntity(
      id: 0,
      createTimestamp: 123456789,
      type: TransactionTypeEntity.expense,
      title: 'Food',
      emoji: null,
    );

    // WHEN
    await dataSource.addOrUpdate(category);

    // THEN
    final result = await dataSource.getById(category.id);
    expect(result, equals(category));
  });

  test('getById() returns null when category does not exist', () async {
    // GIVEN

    // WHEN
    final result = await dataSource.getById(123);

    // THEN
    expect(result, isNull);
  });

  test('getAll() returns empty list when no category exist', () async {
    // GIVEN

    // WHEN
    final result = await dataSource.getAll(TransactionTypeEntity.income);

    // THEN
    expect(result, isEmpty);
  });

  test('getAll() returns all categories', () async {
    // GIVEN
    const category1 = TransactionCategoryEntity(
      id: 0,
      createTimestamp: 123456789,
      type: TransactionTypeEntity.expense,
      title: 'Food',
      emoji: null,
    );
    const category2 = TransactionCategoryEntity(
      id: 1,
      createTimestamp: 0,
      type: TransactionTypeEntity.income,
      title: 'Something',
      emoji: '',
    );

    await dataSource.addOrUpdate(category1);
    await dataSource.addOrUpdate(category2);

    // WHEN
    final result = await dataSource.getAll(TransactionTypeEntity.income);

    // THEN
    expect(result, equals([category2]));
  });

  test('delete() deletes category from database', () async {
    // GIVEN
    const category1 = TransactionCategoryEntity(
      id: 0,
      createTimestamp: 123456789,
      type: TransactionTypeEntity.expense,
      title: 'Food',
      emoji: null,
    );
    const category2 = TransactionCategoryEntity(
      id: 1,
      createTimestamp: 0,
      type: TransactionTypeEntity.expense,
      title: 'Drinks',
      emoji: '',
    );

    await dataSource.addOrUpdate(category1);
    await dataSource.addOrUpdate(category2);

    // WHEN
    await dataSource.delete(category2.id);

    // THEN
    final result = await dataSource.getAll(TransactionTypeEntity.expense);
    expect(result, equals([category1]));
  });
}
