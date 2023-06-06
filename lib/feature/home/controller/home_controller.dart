import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/providers.dart';
import '../domain/home_state.dart';

final homeControllerProvider = AsyncNotifierProvider<HomeController, HomeState>(() {
  return HomeController();
});

class HomeController extends AsyncNotifier<HomeState> {
  @override
  FutureOr<HomeState> build() async {
    final accountsRepository = await ref.watch(accountsRepositoryProvider);
    final accounts = await accountsRepository.getAll();

    return HomeState(
      selectedPageIndex: 0,
      shouldAddAccount: accounts.isEmpty,
    );
  }

  void selectPage(int index) async {
    final currentState = await future;
    state = AsyncValue.data(
      currentState.copyWith(
        selectedPageIndex: index,
      )
    );
  }
}
