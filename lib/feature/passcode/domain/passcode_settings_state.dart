import 'package:freezed_annotation/freezed_annotation.dart';

part 'passcode_settings_state.freezed.dart';

@freezed
class PasscodeSettingsState with _$PasscodeSettingsState {
  const factory PasscodeSettingsState({
    required bool isPasscodeEnabled,
    required bool isBiometricsEnabled,
  }) = _PasscodeSettingsState;
}
