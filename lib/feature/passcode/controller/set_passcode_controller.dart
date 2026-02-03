import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/passcode/domain/set_passcode_mode.dart';
import 'package:moneymanager/feature/passcode/domain/set_passcode_result.dart';
import 'package:moneymanager/feature/passcode/domain/set_passcode_state.dart';
import 'package:moneymanager/service/providers.dart';

import '../../../ext/auto_dispose_notifier_ext.dart';
import '../../transaction/domain/amount_key.dart';
import '../common.dart';

final setPasscodeControllerProvider = NotifierProvider
    .autoDispose<SetPasscodeController, SetPasscodeState>(() {
  return SetPasscodeController();
});

class SetPasscodeController extends AutoDisposeNotifierExt<SetPasscodeState> {
  // It's the current input. It's cleared when the mode is switched.
  String _currentPasscodeInput = "";
  // It's the input from the 'set' mode.
  // It's needed to verify that inputs from the 'set' and 'reEnter' modes are equal.
  String _passcode = "";

  @override
  SetPasscodeState build() {
    return SetPasscodeState(
      mode: SetPasscodeMode.set,
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
        _handleModeSwitch();
      }
    }
  }

  void _resetResult() {
    if (state.result != null) {
      updateState((state) => state.copyWith(result: null));
    }
  }

  void _handleModeSwitch() {
    final currentMode = state.mode;

    switch (currentMode) {
      case SetPasscodeMode.set:
        updateState((state) => state.copyWith(
          mode: SetPasscodeMode.reEnter,
          currentInputLength: 0,
        ));
        _passcode = _currentPasscodeInput;
        _currentPasscodeInput = "";
        break;
      case SetPasscodeMode.reEnter:
        // Check inputs from the 'set' and 'reEnter' modes.
        if (_currentPasscodeInput == _passcode) {
          // If 'reEnter' and 'set' inputs are equal, set the passcode.
          _setPasscode();
          updateState((state) => state.copyWith(result: SetPasscodeResult.set));
        } else {
          // 'reEnter' input is different from 'set'.
          // Show an error and go back to the 'set' mode.
          updateState((state) => state.copyWith(
            mode: SetPasscodeMode.set,
            currentInputLength: 0,
            result: SetPasscodeResult.validationError,
          ));
          _passcode = "";
          _currentPasscodeInput = "";
        }
        break;
    }
  }

  void _setPasscode() {
    ref.read(passcodeServiceProvider)
        .setPasscode(_passcode);
  }
}
