import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/provider/current_account_provider.dart';
import '../../../domain/account.dart';
import '../domain/home_state.dart';

final homeControllerProvider = AsyncNotifierProvider<HomeController, HomeState>(() {
  return HomeController();
});

class HomeController extends AsyncNotifier<HomeState> {
  @override
  FutureOr<HomeState> build() async {
    final Account? currentAccount = await ref.watch(currentAccountOrNullProvider.future);



    print('--- --- --- Current account changed: ${currentAccount?.id.toString() ?? 'NULL'}');


    return HomeState(
      selectedPageIndex: 0,
      shouldAddAccount: currentAccount == null,
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
