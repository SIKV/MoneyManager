import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency.freezed.dart';

@freezed
class Currency with _$Currency {
  const factory Currency({
    required String code,
    required String name,
    required String symbol,
    required String? emoji,
  }) = _Currency;
}
