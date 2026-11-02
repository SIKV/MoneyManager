import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import 'change_theme_controller.dart';

class ChangeThemePage extends ConsumerWidget {
  const ChangeThemePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(changeThemeControllerProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: Text(AppLocalizations.of(context)!.changeThemePage_title),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: state.value?.themeModes.map((themeMode) {
                String title = '';
                switch (themeMode) {
                  case ThemeMode.system:
                    title = AppLocalizations.of(context)!.changeThemePage_followSystem;
                    break;
                  case ThemeMode.dark:
                    title = AppLocalizations.of(context)!.changeThemePage_darkThemeOn;
                    break;
                  case ThemeMode.light:
                    title = AppLocalizations.of(context)!.changeThemePage_darkThemeOff;
                    break;
                }
                return ListTile(
                  onTap: () => _changeThemeMode(ref, themeMode),
                  title: Text(title),
                  leading: Radio(
                    value: themeMode,
                    groupValue: state.value?.currentThemeMode,
                    onChanged: (value) => _changeThemeMode(ref, value),
                  ),
                );
              }).toList() ?? [],
            ),
          ),
        ],
      ),
    );
  }

  void _changeThemeMode(WidgetRef ref, ThemeMode? themeMode) {
    if (themeMode != null) {
      ref.read(changeThemeControllerProvider.notifier).changeThemeMode(themeMode);
    }
  }
}
