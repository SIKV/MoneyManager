import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moneymanager/data/default/categories_default_data_source.dart';
import 'package:moneymanager/data/local/datasource/categories_local_data_source.dart';
import 'package:moneymanager/data/local/entity/transaction_category_entity.dart';
import 'package:moneymanager/data/local/entity/transaction_type_entity.dart';
import 'package:moneymanager/data/providers.dart';
import 'package:moneymanager/data/repository/categories_repository.dart';
import 'package:moneymanager/domain/transaction_type.dart';
import 'package:moneymanager/feature/categories/controller/categories_controller.dart';
import 'package:moneymanager/local_preferences.dart';

class CategoriesLocalDataSourceMock extends Mock implements CategoriesLocalDataSource { }

class CategoriesDefaultDataSourceMock extends Mock implements CategoriesDefaultDataSource { }

class LocalPreferencesMock extends Mock implements LocalPreferences { }

TransactionCategoryEntity categoryEntity(int id, String title) => TransactionCategoryEntity(
  id: id,
  createTimestamp: 0,
  type: TransactionTypeEntity.income,
  title: title,
  emoji: null,
  archived: false,
);

void main() {
  setUpAll(() {
    registerFallbackValue(TransactionTypeEntity.income);
    registerFallbackValue(TransactionType.income);
  });

  test('build() reloads categories when the repository notifies about an update', () async {
    // GIVEN
    final localDataSourceMock = CategoriesLocalDataSourceMock();
    final localPreferencesMock = LocalPreferencesMock();

    var storedCategories = [categoryEntity(1, 'Salary')];

    when(() => localDataSourceMock.getAll(any(), any()))
        .thenAnswer((_) async => storedCategories);
    when(() => localPreferencesMock.getCategoriesCustomOrder(any()))
        .thenReturn([]);

    final repository = CategoriesRepository(
      localDataSourceMock,
      CategoriesDefaultDataSourceMock(),
      localPreferencesMock,
    );

    final container = ProviderContainer(overrides: [
      categoriesRepositoryProvider.overrideWithValue(Future.value(repository)),
    ]);
    addTearDown(container.dispose);

    container.listen(categoriesControllerProvider, (_, __) { });

    final initialState = await container.read(categoriesControllerProvider.future);
    expect(initialState.categories.map((it) => it.title), equals(['Salary']));

    // WHEN
    storedCategories = [categoryEntity(2, 'Gifts')];
    repository.notifyUpdated();
    await pumpEventQueue();

    // THEN
    final updatedState = await container.read(categoriesControllerProvider.future);
    expect(updatedState.categories.map((it) => it.title), equals(['Gifts']));
  });
}
