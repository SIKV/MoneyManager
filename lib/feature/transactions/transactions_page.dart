import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:moneymanager/feature/account/change_account_page.dart';
import 'package:moneymanager/feature/transactions/controller/header_controller.dart';
import 'package:moneymanager/feature/transactions/extensions.dart';
import 'package:moneymanager/feature/transactions/ui/transactions_list.dart';
import 'package:moneymanager/navigation/routes.dart';
import 'package:moneymanager/theme/assets.dart';
import 'package:moneymanager/ui/widget/collapsing_header_page.dart';
import 'package:moneymanager/ui/widget/header_circle_button.dart';

import '../../theme/theme.dart';
import '../../theme/theme_manager.dart';
import '../../ui/widget/SvgIcon.dart';
import 'ui/header_filters.dart';

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);
    final headerState = ref.watch(headerControllerProvider);

    return headerState.when(
      error: (_, __) {
        // TODO: Implement.
        return Container();
      },
      loading: () {
        // TODO: Implement.
        return Container();
      },
      data: (headerState) {
        String title = headerState.amount;
        String titleSuffix = ' ${headerState.currentAccount?.currency.symbol}';

        String filterTitle = getFilterTitle(context, headerState.rangeFilter, headerState.typeFilter);

        String transactionsCount = Intl.plural(headerState.transactionsCount,
            zero: '${headerState.transactionsCount} ${AppLocalizations.of(context)!.lTransactions}',
            one: '${headerState.transactionsCount} ${AppLocalizations.of(context)!.lTransaction}',
            other: '${headerState.transactionsCount} ${AppLocalizations.of(context)!.lTransactions}',
          );

        return CollapsingHeaderPage(
          colors: appTheme.colors,
          startColor: appTheme.colors.transactionsHeaderStart,
          endColor: appTheme.colors.transactionsHeaderEnd,
          collapsedHeight: 78,
          expandedHeight: 346,
          title: title,
          titleSuffix: titleSuffix,
          subtitle: filterTitle,
          tertiaryTitle: transactionsCount,
          onTitlePressed: () {
            _showChangeAccount(context);
          },
          primaryAction: IconButton(
            icon: SvgIcon(Assets.filters,
              size: 32,
              color: appTheme.colors.alwaysWhite,
            ),
            onPressed: () => _showMenu(context),
          ),
          secondaryActions: [
            HeaderCircleButton(
              title: AppLocalizations.of(context)!.categories_pageTitle,
              iconAsset: Assets.cart,
              onPressed: () => Navigator.pushNamed(context, AppRoutes.categories),
            ),
            HeaderCircleButton(
              title: AppLocalizations.of(context)!.statisticsPageTitle,
              iconAsset: Assets.chartVertical,
              onPressed: () => Navigator.pushNamed(context, AppRoutes.statistics),
            ),
            HeaderCircleButton(
              title: AppLocalizations.of(context)!.search_pageTitle,
              iconAsset: Assets.search,
              onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
            ),
          ],
          sliver: const TransactionsList(),
        );
      },
    );
  }

  void _showChangeAccount(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const ChangeAccountPage();
      },
    );
  }

  void _showMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const HeaderFilters();
      },
    );
  }
}
