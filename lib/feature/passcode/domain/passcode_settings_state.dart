import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/feature/passcode/domain/passcode_settings_route.dart';

part 'passcode_settings_state.freezed.dart';

@freezed
class PasscodeSettingsState with _$PasscodeSettingsState {
  const factory PasscodeSettingsState({
    required bool isPasscodeEnabled,
    required bool isBiometricsAvailable,
    required bool isBiometricsEnabled,
    required PasscodeSettingsRoute? navigateTo,
  }) = _PasscodeSettingsState;
}
