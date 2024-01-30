import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'categories_default_data_source.dart';

final categoriesDefaultDataSourceProvider = Provider((_) {
  return const CategoriesDefaultDataSource('assets/defaults/categories.json');
});
