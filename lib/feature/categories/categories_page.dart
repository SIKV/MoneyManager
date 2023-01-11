import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/categories/categories_list_controller.dart';
import 'package:moneymanager/feature/categories/category_editor.dart';
import 'package:moneymanager/feature/categories/category_item.dart';
import 'package:moneymanager/theme/icons.dart';
import 'package:moneymanager/theme/spacings.dart';
import 'package:moneymanager/ui/widget/collapsing_header_page.dart';

import '../../domain/transaction_category.dart';
import '../../localizations.dart';
import '../../theme/theme.dart';

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);

    return Theme(
      data: appTheme.themeData().copyWith(
        colorScheme: ColorScheme.fromSeed(
            seedColor: appTheme.colors.categoriesHeaderEnd),
      ),
      child: Stack(
        children: [
          CollapsingHeaderPage(
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
                  addCategory(context, ref);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addCategory(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) =>
      const CategoryEditor(
        action: CategoryEditorAction.add,
      ),
    );
  }
}

class _CategoriesList extends ConsumerWidget {
  const _CategoriesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesListControllerProvider);

    return categories.when(
      loading: () =>
          SliverToBoxAdapter(
            child: Container(),
          ),
      error: (err, _) =>
      const SliverToBoxAdapter(
        child: Text('Error fetching categories'),
      ),
      data: (categories) =>
          SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context,
                int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacings.four,
                  vertical: Spacings.two,
                ),
                child: CategoryItem(
                  category: categories[index],
                  onPressed: () {
                    editCategory(context, categories[index]);
                  },
                ),
              );
            }, childCount: categories.length),
          ),
    );
  }

  void editCategory(BuildContext context, TransactionCategory category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) =>
          CategoryEditor(
            action: CategoryEditorAction.edit,
            category: category,
          ),
    );
  }
}
