import 'package:flutter/widgets.dart';

import 'feature/categories/categories_page.dart';

class AppRoutes {
  static const categories = '/categories';

  static final routes = <String, WidgetBuilder>{
    categories: (BuildContext context) => const CategoriesPage(),
  };
}
