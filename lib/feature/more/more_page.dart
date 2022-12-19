import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/theme/theme.dart';

import '../../localizations.dart';
import '../../theme/icons.dart';
import '../../ui/widget/collapsing_header_content.dart';

class MorePage extends ConsumerWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);

    return CollapsingHeaderContent(
      colors: appTheme.colors,
      startColor: appTheme.colors.moreHeaderStart,
      endColor: appTheme.colors.moreHeaderEnd,
      collapsedHeight: 78,
      expandedHeight: 208,
      title: Strings.morePageTitle.localized(context),
      primaryAction: appTheme.type == AppThemeType.light ? AppIcons.moreSetDarkTheme : AppIcons.moreSetLightTheme,
      primaryActionBackground: appTheme.colors.alwaysWhite,
      onPrimaryActionPressed: () {
        _updateTheme(ref.read(appThemeManagerProvider.notifier));
      },
      sliver: SliverToBoxAdapter(
        child: Container(),
      ),
    );
  }

  void _updateTheme(AppThemeManager themeManager) {
    if (themeManager.theme.type == AppThemeType.light) {
      themeManager.setTheme(AppThemeType.dark);
    } else {
      themeManager.setTheme(AppThemeType.light);
    }
  }
}
