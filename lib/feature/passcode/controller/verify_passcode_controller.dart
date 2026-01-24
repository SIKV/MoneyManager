import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/passcode/domain/verify_passcode_result.dart';
import 'package:moneymanager/service/providers.dart';

import '../../../ext/auto_dispose_notifier_ext.dart';
import '../../transaction/domain/amount_key.dart';
import '../common.dart';
import '../domain/verify_passcode_state.dart';

final verifyPasscodeControllerProvider = NotifierProvider
    .autoDispose<VerifyPasscodeController, VerifyPasscodeState>(() {
  return VerifyPasscodeController();
});

class VerifyPasscodeController extends AutoDisposeNotifierExt<VerifyPasscodeState> {

  String _currentPasscodeInput = "";

  @override
  VerifyPasscodeState build() {

    _runBiometricsAuthIfNeeded();

    return VerifyPasscodeState(
      passcodeLength: passcodeLength,
      currentInputLength: _currentPasscodeInput.length,
      result: null,
    );
  }

  void resetResult() {
    updateState((state) => state.copyWith(result: null));
  }

  void processKeyEntered(AmountKey key) {
    // Remove last key if the backspace was entered.
    if (key == AmountKey.backspace && _currentPasscodeInput.isNotEmpty) {
      _currentPasscodeInput = _currentPasscodeInput.substring(0, _currentPasscodeInput.length - 1);
    } else if (key.isDigit) {
      // Add the key.
      _currentPasscodeInput = _currentPasscodeInput + key.char;
      updateState((state) => state.copyWith(currentInputLength: _currentPasscodeInput.length));
      // Check if it's the last key entered.
      if (_currentPasscodeInput.length >= state.passcodeLength) {
        _verifyPasscode();
      }
    }
  }

  void _verifyPasscode() async {
    final verified = await ref.read(passcodeServiceProvider)
        .verifyPasscode(_currentPasscodeInput);

    final result = verified
        ? VerifyPasscodeResult.success
        : VerifyPasscodeResult.error;

    _currentPasscodeInput = "";

    updateState((state) => state.copyWith(
      currentInputLength: _currentPasscodeInput.length,
      result: result,
    ));
  }

  void _runBiometricsAuthIfNeeded() async {
    final passcodeService = ref.read(passcodeServiceProvider);
    final biometricsEnabled = await passcodeService.isBiometricsEnabled();

    if (biometricsEnabled) {
      final authenticated = await passcodeService.runBiometricsAuth();
      if (authenticated) {
        updateState((state) =>
            state.copyWith(
              result: VerifyPasscodeResult.success,
            ));
      }
    }
  }
}
