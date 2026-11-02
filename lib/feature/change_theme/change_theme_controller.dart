import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/theme_manager.dart';
import 'change_theme_state.dart';

final changeThemeControllerProvider = AsyncNotifierProvider
    .autoDispose<ChangeThemeController, ChangeThemeState>(() {
  return ChangeThemeController();
});

class ChangeThemeController extends AutoDisposeAsyncNotifier<ChangeThemeState> {

  @override
  FutureOr<ChangeThemeState> build() async {
    ref.watch(appThemeManagerProvider);
    final AppThemeManager themeManager = ref.read(appThemeManagerProvider.notifier);

    return ChangeThemeState(
      themeModes: [ThemeMode.system, ThemeMode.dark, ThemeMode.light],
      currentThemeMode: themeManager.getThemeMode(),
    );
  }

  void changeThemeMode(ThemeMode themeMode) {
    ref.read(appThemeManagerProvider.notifier).setThemeMode(themeMode);
  }
}
