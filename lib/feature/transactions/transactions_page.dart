import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:moneymanager/domain/transaction_type_filter.dart';
import 'package:moneymanager/feature/transactions/controller/header_controller.dart';
import 'package:moneymanager/feature/transactions/extensions.dart';
import 'package:moneymanager/feature/transactions/ui/transactions_list.dart';
import 'package:moneymanager/navigation/routes.dart';
import 'package:moneymanager/theme/assets.dart';
import 'package:moneymanager/theme/dimens.dart';
import 'package:moneymanager/ui/widget/collapsing_header_page.dart';
import 'package:moneymanager/ui/widget/header_circle_button.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/theme.dart';
import '../../theme/theme_manager.dart';
import '../../ui/widget/SvgIcon.dart';
import '../wallet/change_wallet_page.dart';
import 'ui/header_filters.dart';

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);
    final headerState = ref.watch(headerControllerProvider).value;

    final double amount = headerState?.amount ?? 0.0;
    final String formattedAmount = headerState?.formattedAmount ?? '...';

    final String titleSuffix = headerState != null
        ? ' ${headerState.currentWallet?.currency.symbol}'
        : '';

    final String filterTitle = headerState != null
        ? getFilterTitle(context, headerState.rangeFilter, headerState.typeFilter)
        : '';

    final String transactionsCount = headerState != null
        ? Intl.plural(headerState.transactionsCount,
            zero: '${headerState.transactionsCount} ${AppLocalizations.of(context)!.lTransactions}',
            one: '${headerState.transactionsCount} ${AppLocalizations.of(context)!.lTransaction}',
            other: '${headerState.transactionsCount} ${AppLocalizations.of(context)!.lTransactions}',
        )
        : '';

    Color startColor = appTheme.colors.transactionsAllHeaderStart;
    Color endColor = appTheme.colors.transactionsAllHeaderEnd;

    switch (headerState?.typeFilter) {
      case TransactionTypeFilter.income:
        startColor = appTheme.colors.transactionsIncomeHeaderStart;
        break;
      case TransactionTypeFilter.expenses:
        startColor = appTheme.colors.transactionsExpensesHeaderStart;
        endColor = appTheme.colors.transactionsExpensesHeaderEnd;
        break;
      case TransactionTypeFilter.all:
        break;
      case null:
        break;
    }

    return CollapsingHeaderPage(
      colors: appTheme.colors,
      startColor: startColor,
      endColor: endColor,
      collapsedHeight: Dimens.transactionsPageCollapsedHeight,
      expandedHeight: Dimens.transactionsPageExpandedHeight,
      title: formattedAmount,
      rawTitle: amount,
      titleSuffix: titleSuffix,
      subtitle: filterTitle,
      tertiaryTitle: transactionsCount,
      onTitlePressed: () {
        _showChangeWallet(context);
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
          title: AppLocalizations.of(context)!.categoriesPage_title,
          iconAsset: Assets.cart,
          onPressed: () => Navigator.pushNamed(context, AppRoutes.categories),
        ),
        HeaderCircleButton(
          title: AppLocalizations.of(context)!.statisticsPage_title,
          iconAsset: Assets.chartVertical,
          onPressed: () => Navigator.pushNamed(context, AppRoutes.statistics),
        ),
        HeaderCircleButton(
          title: AppLocalizations.of(context)!.searchPage_title,
          iconAsset: Assets.search,
          onPressed: () => Navigator.pushNamed(context, AppRoutes.search),
        ),
      ],
      sliver: const TransactionsList(),
    );
  }

  void _showChangeWallet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return const ChangeWalletPage();
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
