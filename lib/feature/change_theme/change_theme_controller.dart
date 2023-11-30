import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/theme.dart';
import '../../theme/theme_manager.dart';
import 'change_theme_state.dart';

final changeThemeControllerProvider = AsyncNotifierProvider
    .autoDispose<ChangeThemeController, ChangeThemeState>(() {
  return ChangeThemeController();
});

class ChangeThemeController extends AutoDisposeAsyncNotifier<ChangeThemeState> {

  @override
  FutureOr<ChangeThemeState> build() async {
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);

    return ChangeThemeState(
      themes: AppThemeType.values,
      currentTheme: appTheme.type,
    );
  }

  void changeTheme(AppThemeType theme) {
    final AppThemeManager themeManager = ref.read(appThemeManagerProvider.notifier);

    if (themeManager.getType() == AppThemeType.light) {
      themeManager.setTheme(AppThemeType.dark);
    } else {
      themeManager.setTheme(AppThemeType.light);
    }
  }
}
