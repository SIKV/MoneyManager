import 'package:flutter/widgets.dart';

import 'feature/categories/categories_page.dart';
import 'feature/transaction/transaction_page.dart';

class AppRoutes {
  static const categories = '/categories';
  static const addTransaction = '/add_transaction';

  static final routes = <String, WidgetBuilder>{
    categories: (BuildContext context) => const CategoriesPage(),
    addTransaction: (BuildContext context) => const TransactionPage(),
  };
}
