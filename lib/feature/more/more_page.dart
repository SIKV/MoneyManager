import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/more/controller/more_controller.dart';
import 'package:moneymanager/feature/more/ui/action_tile.dart';
import 'package:moneymanager/theme/theme.dart';

import '../../navigation/routes.dart';
import 'domain/more_item.dart';

class MorePage extends ConsumerWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(moreControllerProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.morePageTitle),
        ),
        body: _Items(
          items: state.value?.items ?? [],
        ),
      ),
    );
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
            leadingIcon: Icons.account_balance_wallet_rounded,
            title: AppLocalizations.of(context)!.accountSettings,
            subtitle: subtitle,
          );
        case MoreItemType.darkTheme:
          String? subtitle;
          if (item is DarkThemeMoreItem) {
            switch (item.appTheme) {
              case AppThemeType.light:
                subtitle = AppLocalizations.of(context)!.off;
                break;
              case AppThemeType.dark:
                subtitle = AppLocalizations.of(context)!.on;
                break;
            }
          }
          return ActionTile(
            onTap: () => Navigator.pushNamed(context, AppRoutes.changeTheme),
            leadingIcon: Icons.contrast_rounded,
            title: AppLocalizations.of(context)!.darkTheme,
            subtitle: subtitle,
          );
      }
    }).toList();

    return Column(
      children: itemTiles,
    );
  }
}
