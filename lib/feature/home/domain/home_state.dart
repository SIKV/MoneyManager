import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    required int selectedPageIndex,
    required bool shouldAddAccount,
  }) = _HomeState;
}
