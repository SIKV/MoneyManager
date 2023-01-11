import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/transactions/transaction_item.dart';
import 'package:moneymanager/routes.dart';
import 'package:moneymanager/theme/icons.dart';
import 'package:moneymanager/ui/widget/collapsing_header_page.dart';
import 'package:moneymanager/ui/widget/header_circle_button.dart';

import '../../localizations.dart';
import '../../theme/spacings.dart';
import '../../theme/styles.dart';
import '../../theme/theme.dart';
import 'header/transactions_header_settings.dart';

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
            return const TransactionsHeaderSettings();
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
      sliver: sampleList(),
    );
  }

  Widget sampleList() {
    return SliverPadding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
          return (index % 10 != 0) ? _item() : _sectionItem();
          },
          childCount: 35,
        ),
      ),
    );
  }

  Widget _item() {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacings.three),
      child: TransactionItem(
        type: TransactionItemType.outcome,
        icon: Icons.fastfood,
        title: 'Food',
        subtitle: 'KFC',
        amount: 499,
        onPressed: () {},
      ),
    );
  }

  Widget _sectionItem() {
    return const Center(
      child: Text('Today',
        style: TextStyles.itemSectionNormal,
      ),
    );
  }
}
