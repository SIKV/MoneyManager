import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/service/session/session_state.dart';

import '../../common/provider/current_wallet_provider.dart';
import '../../domain/wallet.dart';
import '../providers.dart';

final sessionProvider = AsyncNotifierProvider<SessionNotifier, SessionState>(() {
  return SessionNotifier();
});

class SessionNotifier extends AsyncNotifier<SessionState> {

  @override
  FutureOr<SessionState> build() async {
    final Wallet? currentWallet = await ref.watch(
        currentWalletOrNullProvider.future);

    final passcodeEnabled = await ref
        .read(passcodeServiceProvider)
        .isPasscodeEnabled();

    if (currentWallet == null) {
      return SessionState.walletRequired;
    } else if (passcodeEnabled) {
      return SessionState.passcodeRequired;
    } else {
      return SessionState.ready;
    }
  }

  void authenticated() {
    state = const AsyncData(SessionState.ready);
  }
}
