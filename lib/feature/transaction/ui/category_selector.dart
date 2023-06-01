import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_category.dart';
import 'package:moneymanager/feature/transaction/domain/transaction_property.dart';

import '../controller/transaction_maker_controller.dart';

class CategorySelector extends ConsumerWidget {
  const CategorySelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(transactionMakerControllerProvider
        .selectAsync((state) => state.categories)
    );

    return FutureBuilder(
      future: categories,
      builder: (context, snapshot) {
        final data = snapshot.data;

        if (data == null) {
          return Container();
        }

        return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final c = data[index];
              final title = '${c.emoji ?? ''}  ${c.title}';
              return ListTile(
                title: Text(title),
                onTap: () {
                  _categoryPressed(c, ref);
                },
              );
            }
        );
      },
    );
  }

  void _categoryPressed(TransactionCategory category, WidgetRef ref) {
    final controller = ref.read(transactionMakerControllerProvider.notifier);
    controller.setCategory(category).whenComplete(() =>
        controller.selectProperty(TransactionProperty.amount)
    );
  }
}
