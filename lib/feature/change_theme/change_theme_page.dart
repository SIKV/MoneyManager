import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/theme.dart';
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
              children: state.value?.themes.map((theme) {
                String title = '';
                switch (theme) {
                  case AppThemeType.light:
                    title = AppLocalizations.of(context)!.changeThemePage_darkThemeOff;
                    break;
                  case AppThemeType.dark:
                    title = AppLocalizations.of(context)!.changeThemePage_darkThemeOn;
                    break;
                }
                return ListTile(
                  title: Text(title),
                  leading: Radio(
                    value: theme,
                    groupValue: state.value?.currentTheme,
                    onChanged: (value) => _changeTheme(ref, value),
                  ),
                );
              }).toList() ?? [],
            ),
          ),
        ],
      ),
    );
  }

  void _changeTheme(WidgetRef ref, AppThemeType? theme) {
    if (theme != null) {
      ref.read(changeThemeControllerProvider.notifier).changeTheme(theme);
    }
  }
}
