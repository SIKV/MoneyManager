import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/more/controller/more_controller.dart';
import 'package:moneymanager/feature/more/ui/action_tile.dart';
import 'package:moneymanager/theme/spacings.dart';
import 'package:moneymanager/theme/theme.dart';
import 'package:moneymanager/ui/widget/small_section_text.dart';

import '../../l10n/app_localizations.dart';
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
          title: Text(AppLocalizations.of(context)!.morePage_title),
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
        // Divider
        case MoreItemType.divider: {
          return const Divider();
        }
        // Wallet settings
        case MoreItemType.walletSettings: {
          String? subtitle;
          if (item is WalletSettingsMoreItem) {
            subtitle = item.currentWalletName;
          }
          return ActionTile(
            onTap: () => Navigator.pushNamed(context, AppRoutes.walletSettings),
            leadingIcon: Icons.account_balance_wallet_rounded,
            title: AppLocalizations.of(context)!.morePage_walletSettingsItem,
            subtitle: subtitle,
          );
        }
        // Backup
        case MoreItemType.backup: {
          return ActionTile(
            onTap: () => Navigator.pushNamed(context, AppRoutes.backup),
            leadingIcon: Icons.import_export_rounded,
            title: AppLocalizations.of(context)!.backupPage_title,
          );
        }
        // Dark theme
        case MoreItemType.darkTheme: {
          String? subtitle;

          if (item is DarkThemeMoreItem) {
            switch (item.appTheme) {
              case AppThemeType.light:
                subtitle = AppLocalizations.of(context)!.changeThemePage_darkThemeOff;
                break;
              case AppThemeType.dark:
                subtitle = AppLocalizations.of(context)!.changeThemePage_darkThemeOn;
                break;
            }
          }
          return ActionTile(
            onTap: () => Navigator.pushNamed(context, AppRoutes.changeTheme),
            leadingIcon: Icons.contrast_rounded,
            title: AppLocalizations.of(context)!.changeThemePage_title,
            subtitle: subtitle,
          );
        }
        case MoreItemType.sendFeedback: {
          return ActionTile(
            onTap: () => Navigator.pushNamed(context, AppRoutes.sendFeedback),
            leadingIcon: Icons.feedback_rounded,
            title: AppLocalizations.of(context)!.morePage_sendFeedback_itemTitle,
            subtitle: AppLocalizations.of(context)!.morePage_sendFeedback_itemSubtitle,
          );
        }
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
