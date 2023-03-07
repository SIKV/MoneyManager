import 'package:flutter/material.dart';

import '../../../domain/transaction_category.dart';
import '../../../theme/spacings.dart';
import '../category_editor.dart';
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
    return ReorderableListView.builder(
      onReorder: onReorder,
      itemCount: categories.length,
      itemBuilder: (context, index) {
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
      },
    );
  }

  void _editCategory(BuildContext context, TransactionCategory category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) => CategoryEditor(
        action: CategoryEditorAction.edit,
        category: category,
      ),
    );
  }
}
