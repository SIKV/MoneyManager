import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/feature/passcode/domain/verify_passcode_result.dart';

part 'verify_passcode_state.freezed.dart';

@freezed
class VerifyPasscodeState with _$VerifyPasscodeState {
  const factory VerifyPasscodeState({
    required int passcodeLength,
    required int currentInputLength,
    required VerifyPasscodeResult? result,
  }) = _VerifyPasscodeState;
}
