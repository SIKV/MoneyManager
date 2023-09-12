import 'package:flutter/foundation.dart';
import 'package:moneymanager/domain/transaction_category.dart';
import 'package:moneymanager/domain/transaction_type.dart';

@immutable
abstract class CategoryMakerArgs {
  const CategoryMakerArgs();
}

@immutable
class AddCategoryMakerArgs extends CategoryMakerArgs {
  final TransactionType type;

  const AddCategoryMakerArgs({
    required this.type,
  });
}

@immutable
class EditCategoryMakerArgs extends CategoryMakerArgs {
  final TransactionCategory category;

  const EditCategoryMakerArgs({
    required this.category,
  });
}
