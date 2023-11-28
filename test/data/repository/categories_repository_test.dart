import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moneymanager/data/local/datasource/categories_local_data_source.dart';
import 'package:moneymanager/data/local/entity/transaction_category_entity.dart';
import 'package:moneymanager/data/local/entity/transaction_type_entity.dart';
import 'package:moneymanager/data/mapping.dart';
import 'package:moneymanager/data/repository/categories_repository.dart';
import 'package:moneymanager/domain/transaction_category.dart';
import 'package:moneymanager/domain/transaction_type.dart';
import 'package:moneymanager/local_preferences.dart';

class CategoriesLocalDataSourceMock extends Mock implements CategoriesLocalDataSource { }

class LocalPreferencesMock extends Mock implements LocalPreferences { }

const transactionCategoryEntityMock = TransactionCategoryEntity(
  id: 0,
  createTimestamp: 0,
  type: TransactionTypeEntity.income,
  title: 'Mock',
  emoji: null,
);

const transactionTypeEntityMock = TransactionTypeEntity.income;
const transactionTypeMock = TransactionType.income;

void main() {
  setUpAll(() {
    registerFallbackValue(transactionCategoryEntityMock);
    registerFallbackValue(transactionTypeEntityMock);
    registerFallbackValue(transactionTypeMock);
  });

  test('addOrUpdate() updates LocalDataSource', () async {
    // GIVEN
    final localDataSourceMock = CategoriesLocalDataSourceMock();
    final localPreferencesMock = LocalPreferencesMock();

    when(() => localDataSourceMock.addOrUpdate(any()))
        .thenAnswer((_) async { });

    when(() => localPreferencesMock.getCategoriesCustomOrder(any()))
        .thenAnswer((_) => []);

    final repository = CategoriesRepository(localDataSourceMock, localPreferencesMock);

    const category = TransactionCategory(
      id: 0,
      createTimestamp: 0,
      type: TransactionType.income,
      title: 'TestCategory',
    );

    // WHEN
    await repository.addOrUpdate(category);

    // THEN
    final categoryEntity = category.toEntity();

    verify(() => localDataSourceMock.addOrUpdate(categoryEntity))
        .called(1);
  });

  test('getAll() returns entities from LocalDataSource', () async {
    // GIVEN
    const categories = [
      TransactionCategory(
        id: 0,
        createTimestamp: 0,
        type: TransactionType.income,
        title: 'TestCategory_0',
      ),
      TransactionCategory(
        id: 1,
        createTimestamp: 0,
        type: TransactionType.expense,
        title: 'TestCategory_1',
      ),
    ];

    final localDataSourceMock = CategoriesLocalDataSourceMock();
    final localPreferencesMock = LocalPreferencesMock();

    when(() => localDataSourceMock.getAll(any()))
        .thenAnswer((_) async { return categories.map((it) => it.toEntity()).toList(); });

    when(() => localPreferencesMock.getCategoriesCustomOrder(any()))
        .thenAnswer((_) => []);

    final repository = CategoriesRepository(localDataSourceMock, localPreferencesMock);
    const TransactionType type = TransactionType.income;

    // WHEN
    final actualCategories = await repository.getAll(type);

    // THEN
    expect(actualCategories, categories);

    verify(() => localDataSourceMock.getAll(type.toEntity()))
        .called(1);
  });

  test('delete() deletes from LocalDataSource', () async {
    // GIVEN
    final localDataSourceMock = CategoriesLocalDataSourceMock();
    final localPreferencesMock = LocalPreferencesMock();

    when(() => localDataSourceMock.delete(any()))
        .thenAnswer((_) async { });

    when(() => localPreferencesMock.getCategoriesCustomOrder(any()))
        .thenAnswer((_) => []);

    final repository = CategoriesRepository(localDataSourceMock, localPreferencesMock);
    const categoryId = 123;

    // WHEN
    await repository.delete(categoryId);

    // THEN
    verify(() => localDataSourceMock.delete(categoryId))
        .called(1);
  });
}
