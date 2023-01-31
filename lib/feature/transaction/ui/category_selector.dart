import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_category.dart';
import 'package:moneymanager/feature/transaction/domain/transaction_property.dart';
import 'package:moneymanager/feature/transaction/provider/transaction_categories_provider.dart';

import '../provider/transaction_maker_provider.dart';

class CategorySelector extends ConsumerWidget {
  const CategorySelector({Key? key}) : super(key: key);

  void _categoryPressed(TransactionCategory category, WidgetRef ref) {
    final transactionMaker = ref.read(transactionMakerProvider.notifier);

    transactionMaker.setCategory(category);

    // TODO: Select subcategory

    transactionMaker.selectProperty(TransactionProperty.amount);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionType = ref.watch(transactionMakerProvider
        .select((state) => state.type)
    );

    final transactionCategories = ref.watch(transactionCategoriesProvider(transactionType));

    return transactionCategories.when(
      loading: () {
        return Container();
      },
      error: (_, __) {
        return Container();
      },
      data: (categories) {
        return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final c = categories[index];
              final title = '${c.emoji ?? ''}  ${c.title}';
              final subtitle = c.subcategories.map((it) => it.title).join(' | ');
              return ListTile(
                title: Text(title),
                subtitle: Text(subtitle),
                onTap: () {
                  _categoryPressed(c, ref);
                },
              );
            }
        );
      },
    );
  }
}
