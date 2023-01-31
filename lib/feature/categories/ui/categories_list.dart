import 'package:flutter/material.dart';

import '../../../domain/transaction_category.dart';
import '../../../theme/spacings.dart';
import '../category_editor.dart';
import 'category_item.dart';

class CategoriesList extends StatelessWidget {
  final List<TransactionCategory> categories;

  const CategoriesList({
    Key? key,
    required this.categories,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacings.four,
            vertical: Spacings.one,
          ),
          child: CategoryItem(
            category: categories[index],
            onPressed: () {
              _editCategory(context, categories[index]);
            },
          ),
        );
      },
    );
  }
}
