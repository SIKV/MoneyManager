import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/domain/account.dart';

import '../../theme/theme.dart';

part 'change_theme_state.freezed.dart';

@freezed
class ChangeThemeState with _$ChangeThemeState {
  const factory ChangeThemeState({
    required List<AppThemeType> themes,
    required AppThemeType currentTheme,
  }) = _ChangeThemeState;
}
