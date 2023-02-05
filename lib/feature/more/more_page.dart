import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/theme/assets.dart';
import 'package:moneymanager/theme/theme.dart';

import '../../localizations.dart';
import '../../ui/widget/collapsing_header_page.dart';

class MorePage extends ConsumerWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);

    return CollapsingHeaderPage(
      colors: appTheme.colors,
      startColor: appTheme.colors.moreHeaderStart,
      endColor: appTheme.colors.moreHeaderEnd,
      collapsedHeight: 78,
      expandedHeight: 208,
      title: Strings.morePageTitle.localized(context),
      primaryActionAsset: appTheme.type == AppThemeType.light ? Assets.moon : Assets.sun,
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
