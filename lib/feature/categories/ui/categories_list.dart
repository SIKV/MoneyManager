import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:moneymanager/feature/categories/domain/category_maker_args.dart';

import '../../../domain/transaction_category.dart';
import '../../../theme/spacings.dart';
import '../../../ui/widget/no_items.dart';
import '../category_maker.dart';
import 'category_item.dart';

class CategoriesList extends StatelessWidget {
  final List<TransactionCategory> categories;
  final ReorderCallback onReorder;

  const CategoriesList({
    Key? key,
    required this.categories,
    required this.onReorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Implement reordering.

    if (categories.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: NoItems(title: AppLocalizations.of(context)!.categories_noItems),
        ),
      );
    }

    return SliverList(delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      final category = categories[index];
      return Padding(
        key: Key('${category.id}'),
        padding: const EdgeInsets.symmetric(
          horizontal: Spacings.four,
          vertical: Spacings.one,
        ),
        child: CategoryItem(
          category: category,
          onPressed: () {
            _editCategory(context, category);
          },
        ),
      );
    }, childCount: categories.length));
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
