import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/more/controller/more_controller.dart';
import 'package:moneymanager/feature/more/ui/action_tile.dart';
import 'package:moneymanager/theme/spacings.dart';
import 'package:moneymanager/theme/theme.dart';
import 'package:moneymanager/ui/widget/small_section_text.dart';

import '../../navigation/routes.dart';
import 'domain/more_item.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(moreControllerProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.morePageTitle),
        ),
        body: state.when(
          loading: () {
            return Container();
          },
          error: (_, __) {
            return Container();
          },
          data: (state) {
            return _Items(
              items: state.items,
              appVersion: state.appVersion ?? '',
            );
          },
        ),
      ),
    );
  }
}

class _Items extends StatelessWidget {
  final List<MoreItem> items;
  final String appVersion;

  const _Items({
    required this.items,
    required this.appVersion,
  });

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

    itemTiles.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: Spacings.four),
          child: SmallSectionText(appVersion),
        )
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: itemTiles,
    );
  }
}
