import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/feature/passcode/domain/set_passcode_mode.dart';
import 'package:moneymanager/feature/passcode/domain/set_passcode_result.dart';

part 'set_passcode_state.freezed.dart';

@freezed
class SetPasscodeState with _$SetPasscodeState {
  const factory SetPasscodeState({
    required SetPasscodeMode mode,
    required int passcodeLength,
    required int currentInputLength,
    required SetPasscodeResult? result,
  }) = _SetPasscodeState;
}
