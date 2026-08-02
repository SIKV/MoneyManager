import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:moneymanager/domain/transaction_type_filter.dart';
import 'package:moneymanager/feature/anonymous_mode/anonymous_mode_controller.dart';
import 'package:moneymanager/feature/transactions/controller/header_controller.dart';
import 'package:moneymanager/feature/transactions/extensions.dart';
import 'package:moneymanager/feature/transactions/ui/transactions_list.dart';
import 'package:moneymanager/navigation/routes.dart';
import 'package:moneymanager/theme/assets.dart';
import 'package:moneymanager/theme/dimens.dart';
import 'package:moneymanager/ui/widget/collapsing_header_page.dart';
import 'package:moneymanager/ui/widget/header_circle_button.dart';
import 'package:moneymanager/ui/widget/pull_to_activate.dart';

import '../../l10n/app_localizations.dart';
import '../../theme/colors.dart';
import '../../theme/spacings.dart';
import '../../theme/theme.dart';
import '../../theme/theme_manager.dart';
import '../../ui/widget/SvgIcon.dart';

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);
    final headerState = ref.watch(headerControllerProvider).value;
    final bool anonymousMode = ref.watch(anonymousModeControllerProvider);

    final double amount = headerState?.amount ?? 0.0;
    final String formattedAmount = anonymousMode
        ? anonymousAmount
        : headerState?.formattedAmount ?? '...';

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

    return PullToActivate(
      onActivate: () {
        ref.read(anonymousModeControllerProvider.notifier).toggle();
      },
      indicatorBuilder: (context, progress, armed) {
        return _buildPullIndicator(appTheme.colors, progress, armed,
          enabled: anonymousMode,
        );
      },
      child: CollapsingHeaderPage(
        colors: appTheme.colors,
        startColor: startColor,
        endColor: endColor,
        collapsedHeight: Dimens.transactionsPageCollapsedHeight,
        expandedHeight: Dimens.transactionsPageExpandedHeight,
        // Required to over-scroll on Android, where the default physics clamps.
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        title: formattedAmount,
        // Skip the count up animation, there is no number to count up to.
        rawTitle: anonymousMode ? null : amount,
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
      ),
    );
  }

  /// Fades in at the top center as the user pulls the page down, and flips to
  /// a solid circle once releasing would toggle the anonymous mode.
  Widget _buildPullIndicator(AppColors colors, double progress, bool armed, {
    required bool enabled,
  }) {
    final value = Curves.easeOut.transform(progress);

    return Padding(
      padding: const EdgeInsets.only(top: Spacings.two),
      child: Center(
        child: Opacity(
          opacity: value,
          child: Transform.scale(
            scale: 0.6 + 0.4 * value,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: armed
                    ? colors.alwaysWhite
                    : colors.alwaysWhite.withOpacity(0.24),
              ),
              // Shows what releasing does, not the current state.
              child: Icon(enabled ? Icons.visibility : Icons.visibility_off,
                size: 22,
                color: armed ? colors.alwaysBlack : colors.alwaysWhite,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showChangeWallet(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.changeWalletModal);
  }

  void _showMenu(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.transactionsFiltersModal);
  }
}
