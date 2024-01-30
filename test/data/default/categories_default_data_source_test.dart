import 'package:flutter_test/flutter_test.dart';
import 'package:moneymanager/data/default/categories_default_data_source.dart';
import 'package:moneymanager/domain/transaction_type.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CategoriesDefaultDataSource dataSource;

  setUp(() {
    dataSource = const CategoriesDefaultDataSource('assets/defaults/categories.json');
  });

  test('getAll() returns default categories', () async {
    final defaultIncomeCategories = await dataSource.getAll(TransactionType.income);
    final defaultExpenseCategories = await dataSource.getAll(TransactionType.expense);

    expect(defaultIncomeCategories.length, 3);
    expect(defaultExpenseCategories.length, 2);
  });
}
