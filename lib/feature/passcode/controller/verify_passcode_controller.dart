import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/passcode/domain/verify_passcode_result.dart';
import 'package:moneymanager/service/providers.dart';

import '../../../ext/auto_dispose_family_notifier_ext.dart';
import '../../../service/session/session_notifier.dart';
import '../../calculator/domain/amount_key.dart';
import '../common.dart';
import '../domain/verify_passcode_controller_args.dart';
import '../domain/verify_passcode_mode.dart';
import '../domain/verify_passcode_state.dart';

final verifyPasscodeControllerProvider = NotifierProvider
    .autoDispose
    .family<VerifyPasscodeController, VerifyPasscodeState, VerifyPasscodeControllerArgs>(VerifyPasscodeController.new);

class VerifyPasscodeController extends AutoDisposeFamilyNotifierExt<VerifyPasscodeState, VerifyPasscodeControllerArgs> {
  late VerifyPasscodeControllerArgs _args;
  String _currentPasscodeInput = "";

  @override
  VerifyPasscodeState build(VerifyPasscodeControllerArgs args) {
    _args = args;

    _runBiometricsAuthIfNeeded(args.localizedReason, args.mode == VerifyPasscodeMode.startup);

    return VerifyPasscodeState(
      passcodeLength: passcodeLength,
      currentInputLength: _currentPasscodeInput.length,
      result: null,
    );
  }

  void processKeyEntered(AmountKey key) {
    _resetResult();

    // Remove last key if the backspace was entered.
    if (key == AmountKey.backspace && _currentPasscodeInput.isNotEmpty) {
      _currentPasscodeInput = _currentPasscodeInput.substring(0, _currentPasscodeInput.length - 1);
      updateState((state) => state.copyWith(currentInputLength: _currentPasscodeInput.length));
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

  void _resetResult() {
    if (state.result != null) {
      updateState((state) => state.copyWith(result: null));
    }
  }

  void _verifyPasscode() async {
    final verified = await ref.read(passcodeServiceProvider)
        .verifyPasscode(_currentPasscodeInput);

    final result = verified
        ? VerifyPasscodeResult.success
        : VerifyPasscodeResult.error;

    // if _mode == VerifyPasscodeMode.startup -> no need to update the current state,
    // because this page will be automatically popped.
    if (_args.mode == VerifyPasscodeMode.startup && result == VerifyPasscodeResult.success) {
      _updateSession();
    } else {
      _currentPasscodeInput = "";

      updateState((state) =>
          state.copyWith(
            currentInputLength: _currentPasscodeInput.length,
            result: result,
          ));
    }
  }

  void _runBiometricsAuthIfNeeded(String localizedReason, bool updateSession) async {
    final passcodeService = ref.read(passcodeServiceProvider);
    final biometricsEnabled = await passcodeService.isBiometricsEnabled();

    if (biometricsEnabled) {
      final authenticated = await passcodeService.runBiometricsAuth(localizedReason);
      if (authenticated) {
        if (updateSession) {
          _updateSession();
        } else {
          updateState((state) => state.copyWith(
            result: VerifyPasscodeResult.success,
          ));
        }
      }
    }
  }

  void _updateSession() {
    ref.read(sessionProvider.notifier).authenticated();
  }
}
