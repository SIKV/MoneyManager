import 'package:isar/isar.dart';
import 'package:moneymanager/data/local/entity/transaction_subcategory_entity.dart';
import 'package:moneymanager/data/local/entity/transaction_type_entity.dart';

part 'transaction_category_entity.g.dart';

@collection
class TransactionCategoryEntity {
  @Name("id")
  final Id id;

  @Name("type")
  @Enumerated(EnumType.name)
  final TransactionTypeEntity type;

  @Name("title")
  final String title;

  @Name("emoji")
  final String? emoji;

  @Name("subcategories")
  final List<TransactionSubcategoryEntity> subcategories;

  TransactionCategoryEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.emoji,
    required this.subcategories,
  });
}