import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'common/provider/current_wallet_provider.dart';
import 'domain/wallet.dart';
import 'feature/home/home_page.dart';
import 'feature/wallet/add_wallet_page.dart';

part 'app.freezed.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appControllerProvider);

    return state.when(
      loading: () => Container(),
      error: (_, __) => Container(),
      data: (state) {
        if (state.shouldAddWallet) {
          return const AddWalletPage();
        } else {
          return const HomePage();
        }
      },
    );
  }
}

@freezed
class AppState with _$AppState {
  const factory AppState({
    required bool shouldAddWallet,
  }) = _AppState;
}

final appControllerProvider = AsyncNotifierProvider<AppController, AppState>(() {
  return AppController();
});

class AppController extends AsyncNotifier<AppState> {
  @override
  FutureOr<AppState> build() async {
    final Wallet? currentWallet = await ref.watch(currentWalletOrNullProvider.future);
    return AppState(
      shouldAddWallet: currentWallet == null,
    );
  }
}
