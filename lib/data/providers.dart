import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/data/repository/categories_repository.dart';
import 'package:moneymanager/data/repository/impl/categories_repository_impl.dart';

final categoriesRepositoryProvider = Provider<CategoriesRepository>((ref) =>
    CategoriesRepositoryImpl()
);
