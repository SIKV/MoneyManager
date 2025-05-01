import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/home_state.dart';

final homeControllerProvider = NotifierProvider<HomeController, HomeState>(() {
  return HomeController();
});

class HomeController extends Notifier<HomeState> {

  @override
  HomeState build() {
    return const HomeState(
      selectedPageIndex: 0,
    );
  }

  void selectPage(int index) {
    state = state.copyWith(
      selectedPageIndex: index,
    );
  }
}
