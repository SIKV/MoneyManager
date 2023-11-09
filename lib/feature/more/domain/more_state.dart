import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/feature/more/domain/more_item.dart';

part 'more_state.freezed.dart';

@freezed
class MoreState with _$MoreState {
  const factory MoreState({
    required List<MoreItem> items,
  }) = _MoreState;
}
