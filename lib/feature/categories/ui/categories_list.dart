import 'package:flutter/material.dart';
import 'package:moneymanager/feature/categories/domain/category_maker_args.dart';

import '../../../domain/transaction_category.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/spacings.dart';
import '../../../ui/widget/no_items.dart';
import '../category_maker.dart';
import 'category_item.dart';

class CategoriesList extends StatelessWidget {
  final List<TransactionCategory> categories;
  final ReorderCallback onReorder;

  const CategoriesList({
    super.key,
    required this.categories,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: NoItems(title: AppLocalizations.of(context)!.categoriesPage_noItems),
        ),
      );
    }

    return SliverReorderableList(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final addExtraBottomPadding = index >= categories.length - 1;

        final category = categories[index];
        return Material(
          key: Key('${category.id}'),
          child: Padding(
            padding: EdgeInsets.only(
              top: Spacings.one,
              left: Spacings.four,
              right: Spacings.four,
              bottom: addExtraBottomPadding ? 96 : Spacings.one,
            ),
            child: CategoryItem(
              category: category,
              index: index,
              onPressed: () {
                _editCategory(context, category);
              },
            ),
          ),
        );
      },
      onReorder: (oldIndex, newIndex) {
        onReorder(oldIndex, newIndex);
      },
    );
  }

  void _editCategory(BuildContext context, TransactionCategory category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) => CategoryMaker(
        args: EditCategoryMakerArgs(
          category: category,
        ),
      ),
    );
  }
}
