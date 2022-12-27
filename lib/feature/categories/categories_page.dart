import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_subcategory.dart';
import 'package:moneymanager/feature/categories/category_item.dart';
import 'package:moneymanager/theme/icons.dart';
import 'package:moneymanager/theme/spacings.dart';
import 'package:moneymanager/ui/widget/collapsing_header_content.dart';

import '../../domain/transaction_category.dart';
import '../../localizations.dart';
import '../../theme/theme.dart';

final sampleCategories = [
  const TransactionCategory(
    id: '1',
    title: 'Food',
    emoji: '🍔',
    subcategories: [
      TransactionSubcategory(id: '1', title: 'Subcategory 1'),
      TransactionSubcategory(id: '1', title: 'Subcategory 2'),
    ]
  ),
];

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);

    return Theme(
      data: appTheme.themeData().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: appTheme.colors.categoriesHeaderEnd),
      ),
      child: Stack(
        children: [
          CollapsingHeaderContent(
            colors: appTheme.colors,
            startColor: appTheme.colors.categoriesHeaderStart,
            endColor: appTheme.colors.categoriesHeaderEnd,
            collapsedHeight: 64,
            expandedHeight: 192,
            title: Strings.categoriesPageTitle.localized(context),
            sliver: const _CategoriesList(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(Spacings.six),
              child: FloatingActionButton.extended(
                label: Text(Strings.addCategory.localized(context)),
                icon: const Icon(AppIcons.categoriesAddCategory),
                onPressed: () {
                  addCategory(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addCategory(BuildContext context) {
    // TODO: Implement
  }
}

class _CategoriesList extends StatelessWidget {
  const _CategoriesList();

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacings.four,
            vertical: Spacings.two,
          ),
          child: CategoryItem(
            category: sampleCategories[index],
            onPressed: () {
              editCategory(context, sampleCategories[index]);
            },
          ),
        );
      }, childCount: sampleCategories.length),
    );
  }

  void editCategory(BuildContext context, TransactionCategory category) {
    // TODO: Implement
  }
}
