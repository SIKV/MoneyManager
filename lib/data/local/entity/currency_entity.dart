import 'package:isar/isar.dart';

part 'currency_entity.g.dart';

@embedded
class CurrencyEntity {
  @Name("code")
  final String? code;

  @Name("name")
  final String? name;

  @Name("symbol")
  final String? symbol;

  @Name("emoji")
  final String? emoji;

  CurrencyEntity({
    this.code,
    this.name,
    this.symbol,
    this.emoji,
  });
}
