import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/transactions/domain/header_state.dart';
import 'package:moneymanager/feature/transactions/domain/header_value.dart';

final headerControllerProvider = AsyncNotifierProvider<_HeaderController, HeaderState>(() {
  return _HeaderController();
});

class _HeaderController extends AsyncNotifier<HeaderState> {
  HeaderState _state = const HeaderState(
    values: HeaderValue.values,
    selectedValue: HeaderValue.monthExpenses,
  );

  @override
  FutureOr<HeaderState> build() {
    return _state;
  }

  void selectValue(HeaderValue value) {
    _state = _state.copyWith(
      selectedValue: value
    );

    ref.invalidateSelf();
  }
}
