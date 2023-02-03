import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/feature/transactions/domain/header_value.dart';

part 'header_state.freezed.dart';

@freezed
class HeaderState with _$HeaderState {
  const factory HeaderState({
    required List<HeaderValue> values,
    required HeaderValue selectedValue,
  }) = _HeaderState;
}
