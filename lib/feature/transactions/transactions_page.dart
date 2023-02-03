import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/transactions/ui/transactions_list.dart';
import 'package:moneymanager/routes.dart';
import 'package:moneymanager/theme/icons.dart';
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
      primaryAction: AppIcons.transactionsHeaderSettings,
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
          icon: AppIcons.categoriesPage,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.categories);
          },
        ),
        HeaderCircleButton(
          title: Strings.statisticsPageTitle.localized(context),
          icon: AppIcons.statisticsPage,
          onPressed: () { },
        ),
        HeaderCircleButton(
          title: Strings.searchPageTitle.localized(context),
          icon: AppIcons.searchPage,
          onPressed: () { },
        ),
      ],
      sliver: const TransactionsList(),
    );
  }
}
