import 'package:equatable/equatable.dart';
import 'package:isar/isar.dart';

part 'currency_entity.g.dart';

@Embedded(ignore: {'props'})
class CurrencyEntity extends Equatable {
  @Name("code")
  final String? code;

  @Name("name")
  final String? name;

  @Name("symbol")
  final String? symbol;

  @Name("emoji")
  final String? emoji;

  const CurrencyEntity({
    this.code,
    this.name,
    this.symbol,
    this.emoji,
  });

  @override
  List<Object?> get props => [code, name, symbol];
}
