import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/feature/passcode/domain/verify_passcode_mode.dart';

part 'verify_passcode_controller_args.freezed.dart';

@freezed
class VerifyPasscodeControllerArgs with _$VerifyPasscodeControllerArgs {
  const factory VerifyPasscodeControllerArgs({
    required VerifyPasscodeMode mode,
    required String localizedReason,
  }) = _VerifyPasscodeControllerArgs;
}
