import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/transactions/ui/transactions_list.dart';
import 'package:moneymanager/routes.dart';
import 'package:moneymanager/theme/assets.dart';
import 'package:moneymanager/ui/widget/collapsing_header_page.dart';
import 'package:moneymanager/ui/widget/header_circle_button.dart';

import '../../localizations.dart';
import '../../theme/theme.dart';
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
      title: '25 390 50',
      titleSuffix: ' \$',
      subtitle: 'This month expenses',
      primaryActionAsset: Assets.chevronDown,
      onPrimaryActionPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return const HeaderSettings();
          },
        );
      },
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
}
