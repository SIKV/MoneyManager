import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'transaction_subcategory_entity.g.dart';

@embedded
class TransactionSubcategoryEntity extends Equatable {
  @Name("id")
  final String? id;

  @Name("title")
  final String? title;

  const TransactionSubcategoryEntity({
    this.id,
    this.title,
  });

  @override
  List<Object?> get props => [id];
}
