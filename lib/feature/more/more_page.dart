import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/theme/assets.dart';
import 'package:moneymanager/theme/theme.dart';

import '../../localizations.dart';
import '../../theme/theme_manager.dart';
import '../../ui/widget/SvgIcon.dart';
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
      primaryAction: Container(
        decoration: BoxDecoration(
          color: appTheme.colors.alwaysWhite,
          borderRadius: BorderRadius.circular(32),
        ),
        child: IconButton(
          icon: SvgIcon(appTheme.type == AppThemeType.light ? Assets.moon : Assets.sun,
            color: appTheme.colors.alwaysBlack,
          ),
          onPressed: () {
            _updateTheme(ref.read(appThemeManagerProvider.notifier));
          },
        ),
      ),
      sliver: SliverToBoxAdapter(
        child: Container(),
      ),
    );
  }

  void _updateTheme(AppThemeManager themeManager) {
    if (themeManager.getType() == AppThemeType.light) {
      themeManager.setTheme(AppThemeType.dark);
    } else {
      themeManager.setTheme(AppThemeType.light);
    }
  }
}
