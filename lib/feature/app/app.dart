import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/passcode/domain/verify_passcode_mode.dart';
import 'package:moneymanager/feature/passcode/verify_passcode_page.dart';
import 'package:moneymanager/service/session/session_notifier.dart';
import 'package:moneymanager/service/session/session_state.dart';

import '../home/home_page.dart';
import '../wallet/add_wallet_page.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(sessionProvider);

    return sessionState.when(
      loading: () => Container(),
      error: (_, __) => Container(),
      data: (state) {
        return switch (state) {
          SessionState.ready => const HomePage(),
          SessionState.walletRequired => const AddWalletPage(),
          SessionState.passcodeRequired => const VerifyPasscodePage(mode: VerifyPasscodeMode.startup),
        };
      },
    );
  }
}
