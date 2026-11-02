import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneymanager/domain/wallet.dart';

part 'change_theme_state.freezed.dart';

@freezed
class ChangeThemeState with _$ChangeThemeState {
  const factory ChangeThemeState({
    required List<ThemeMode> themeModes,
    required ThemeMode currentThemeMode,
  }) = _ChangeThemeState;
}
