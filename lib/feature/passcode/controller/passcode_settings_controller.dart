import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/passcode/domain/passcode_settings_state.dart';
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
    );
  }

  void setPasscodeEnabled(bool enabled) {
    // TODO: Implement.
    // This line is only for testing.
    updateState((state) => state.copyWith(isPasscodeEnabled: enabled));
  }

  void setBiometricsEnabled(bool enabled) {
    // TODO: Implement.
  }
}
