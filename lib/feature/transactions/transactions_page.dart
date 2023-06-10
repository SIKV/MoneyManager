import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/account/change_account_page.dart';
import 'package:moneymanager/feature/transactions/controller/header_controller.dart';
import 'package:moneymanager/feature/transactions/extensions.dart';
import 'package:moneymanager/feature/transactions/provider/transactions_list_provider.dart';
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
    final headerState = ref.watch(headerControllerProvider);
    final transactionsList = ref.watch(transactionsListProvider);

    return CollapsingHeaderPage(
      colors: appTheme.colors,
      startColor: appTheme.colors.transactionsHeaderStart,
      endColor: appTheme.colors.transactionsHeaderEnd,
      collapsedHeight: 78,
      expandedHeight: 346,
      title: headerState.value?.amount ?? '',
      titleSuffix: ' ${headerState.value?.currentAccount?.currency.symbol}',
      subtitle: headerState.value?.currentFilter.getTitle(context),
      tertiaryTitle: '${transactionsList.value?.length ?? 0} transactions', // TODO
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
          title: Strings.categories_pageTitle.localized(context),
          iconAsset: Assets.cart,
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
          title: Strings.search_pageTitle.localized(context),
          iconAsset: Assets.search,
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.search);
          },
        ),
      ],
      sliver: const TransactionsList(),
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
        return const HeaderSettings();
      },
    );
  }
}
