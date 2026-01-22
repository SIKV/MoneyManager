import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/passcode/domain/passcode_settings_route.dart';
import 'package:moneymanager/feature/passcode/domain/passcode_settings_state.dart';
import 'package:moneymanager/feature/passcode/domain/set_passcode_result.dart';
import 'package:moneymanager/service/providers.dart';

import '../../../ext/auto_dispose_async_notifier_ext.dart';
import '../domain/passcode_settings_deferred_action.dart';
import '../domain/verify_passcode_result.dart';

final passcodeSettingsControllerProvider = AsyncNotifierProvider
    .autoDispose<PasscodeSettingsController, PasscodeSettingsState>(() {
  return PasscodeSettingsController();
});

class PasscodeSettingsController extends AutoDisposeAsyncNotifierExt<PasscodeSettingsState> {
  // An action to be run after navigation result is received.
  // This approach is not the best and hss to be revised.
  PasscodeSettingsDeferredAction? _deferredAction;

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

  void handleNavigationResult(Future<Object?> navigationResult) async {
    final result = await navigationResult;

    switch (result) {
      case SetPasscodeResult.set: {
        _runDeferredAction();
      }
      case VerifyPasscodeResult.success: {
        _runDeferredAction();
      }
    }
  }

  void _runDeferredAction() {
    switch (_deferredAction) {
      case null: // Do nothing.
        break;
      case PasscodeSettingsDeferredAction.passcodeSet:
        updateState((state) => state.copyWith(isPasscodeEnabled: true));
        break;
      case PasscodeSettingsDeferredAction.disablePasscode:
        ref.read(passcodeServiceProvider)
            .deletePasscode()
            .then((_) {
              updateState((state) => state.copyWith(isPasscodeEnabled: false));
            });
        break;
    }
    _deferredAction = null;
  }

  void setPasscodeEnabled(bool enabled) {
    final navigateTo = enabled
        ? PasscodeSettingsRoute.setPasscode
        : PasscodeSettingsRoute.verifyPasscode;

    _deferredAction = enabled
        ? PasscodeSettingsDeferredAction.passcodeSet
        : PasscodeSettingsDeferredAction.disablePasscode;

    updateState((state) => state.copyWith(navigateTo: navigateTo));
  }

  void setBiometricsEnabled(bool enabled) {
    // TODO: Implement.
  }
}
