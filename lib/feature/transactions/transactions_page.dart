import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/transactions/ui/transactions_list.dart';
import 'package:moneymanager/navigation/routes.dart';
import 'package:moneymanager/theme/assets.dart';
import 'package:moneymanager/ui/widget/collapsing_header_page.dart';
import 'package:moneymanager/ui/widget/header_circle_button.dart';

import '../../localizations.dart';
import '../../theme/theme.dart';
import '../../theme/theme_manager.dart';
import '../../ui/widget/SvgIcon.dart';
import 'ui/header_settings.dart';

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);

    return CollapsingHeaderPage(
      colors: appTheme.colors,
      startColor: appTheme.colors.transactionsHeaderStart,
      endColor: appTheme.colors.transactionsHeaderEnd,
      collapsedHeight: 78,
      expandedHeight: 346,
      title: '0',
      titleSuffix: ' \$',
      subtitle: 'This month expenses',
      tertiaryTitle: '0 Transactions',
      primaryAction: IconButton(
        icon: SvgIcon(Assets.menu,
          size: 32,
          color: appTheme.colors.alwaysWhite,
        ),
        onPressed: () => _showMenu(context),
      ),
      secondaryActions: [
        HeaderCircleButton(
          title: Strings.categoriesPageTitle.localized(context),
          iconAsset: Assets.listRight,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.categories);
          },
        ),
        HeaderCircleButton(
          title: Strings.statisticsPageTitle.localized(context),
          iconAsset: Assets.chartVertical,
          onPressed: () { },
        ),
        HeaderCircleButton(
          title: Strings.searchPageTitle.localized(context),
          iconAsset: Assets.search,
          onPressed: () { },
        ),
      ],
      sliver: const TransactionsList(),
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const HeaderSettings();
      },
    );
  }
}
