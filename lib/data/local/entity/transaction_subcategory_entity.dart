import 'package:isar/isar.dart';

part 'transaction_subcategory_entity.g.dart';

@embedded
class TransactionSubcategoryEntity {
  @Name("id")
  final String? id;

  @Name("title")
  final String? title;

  TransactionSubcategoryEntity({
    this.id,
    this.title,
  });
}
