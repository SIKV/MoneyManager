import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/passcode/domain/passcode_settings_route.dart';
import 'package:moneymanager/feature/passcode/domain/passcode_settings_state.dart';
import 'package:moneymanager/feature/passcode/domain/set_passcode_result.dart';
import 'package:moneymanager/service/providers.dart';

import '../../../ext/auto_dispose_async_notifier_ext.dart';

final passcodeSettingsControllerProvider = AsyncNotifierProvider
    .autoDispose<PasscodeSettingsController, PasscodeSettingsState>(() {
  return PasscodeSettingsController();
});

class PasscodeSettingsController extends AutoDisposeAsyncNotifierExt<PasscodeSettingsState> {

  @override
  FutureOr<PasscodeSettingsState> build() async {
    final passcodeService = ref.read(passcodeServiceProvider);

    return PasscodeSettingsState(
      isPasscodeEnabled: await passcodeService.isPasscodeEnabled(),
      isBiometricsEnabled: await passcodeService.isBiometricsEnabled(),
      navigateTo: null,
    );
  }

  void didNavigate() {
    updateState((state) => state.copyWith(navigateTo: null));
  }

  void handleNavigationResult(Future<Object?> resultFuture) async {
    final result = await resultFuture;

    if (result is SetPasscodeResult) {
      updateState((state) => state.copyWith(isPasscodeEnabled: true));
    }
  }

  void setPasscodeEnabled(bool enabled) {
    if (enabled) {
      updateState((state) => state.copyWith(navigateTo: PasscodeSettingsRoute.setPasscode));
    } else {
      // TODO: For testing.
      updateState((state) => state.copyWith(isPasscodeEnabled: false));
      ref.read(passcodeServiceProvider).deletePasscode();
    }
  }

  void setBiometricsEnabled(bool enabled) {
    // TODO: Implement.
  }
}
