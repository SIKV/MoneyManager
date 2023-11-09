import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/more/controller/more_controller.dart';
import 'package:moneymanager/feature/more/ui/action_tile.dart';
import 'package:moneymanager/theme/assets.dart';
import 'package:moneymanager/theme/theme.dart';

import '../../navigation/routes.dart';
import '../../theme/theme_manager.dart';
import '../../ui/widget/SvgIcon.dart';
import '../../ui/widget/collapsing_header_page.dart';
import 'domain/more_item.dart';

class MorePage extends ConsumerWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(moreControllerProvider);
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);

    return CollapsingHeaderPage(
      colors: appTheme.colors,
      startColor: appTheme.colors.moreHeaderStart,
      endColor: appTheme.colors.moreHeaderEnd,
      collapsedHeight: 78,
      expandedHeight: 208,
      title: AppLocalizations.of(context)!.morePageTitle,
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
        child: _Items(
          items: state.value?.items ?? [],
        ),
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

class _Items extends StatelessWidget {
  final List<MoreItem> items;

  const _Items({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> itemTiles = items.map((item) {
      switch (item.type) {
        case MoreItemType.divider:
          return const Divider();
        case MoreItemType.accountSettings:
          String? subtitle;
          if (item is AccountSettingsMoreItem) {
            subtitle = item.currentAccountName;
          }
          return ActionTile(
            onTap: () => Navigator.pushNamed(context, AppRoutes.accountSettings),
            leadingIcon: Icons.money,
            title: AppLocalizations.of(context)!.accountSettings,
            subtitle: subtitle,
          );
      }
    }).toList();

    return Column(
      children: itemTiles,
    );
  }
}
