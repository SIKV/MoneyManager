import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_category.dart';
import 'package:moneymanager/domain/transaction_type.dart';
import 'package:moneymanager/feature/categories/category_editor.dart';
import 'package:moneymanager/feature/categories/ui/categories_list.dart';
import 'package:moneymanager/theme/icons.dart';
import 'package:moneymanager/theme/spacings.dart';

import '../../localizations.dart';
import 'controller/categories_controller.dart';

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(categoriesControllerProvider);

    return state.when(
      loading: () => Container(),
      error: (_, __) => Container(),
      data: (state) {
        final types = state.types
            .map((it) => Text(it.getTitle(context)))
            .toList();

        final isSelectedTypes = state.types
            .map((it) => it == state.selectedType)
            .toList();

        return Scaffold(
          appBar: AppBar(
            title: Text(Strings.categoriesPageTitle.localized(context)),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ToggleButtons(
                  constraints: BoxConstraints(
                    minWidth: (MediaQuery.of(context).size.width / 2) - Spacings.four,
                    minHeight: 46,
                  ),
                  onPressed: (index) {
                    _selectType(ref, index);
                  },
                  isSelected: isSelectedTypes,
                  children: types,
                ),
              ),
              Expanded(
                child: CategoriesList(
                  categories: state.categories,
                  onReorder: (oldIndex, newIndex) {
                    _reorder(ref, state.categories[oldIndex], oldIndex, newIndex);
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            label: Text(Strings.addCategory.localized(context)),
            icon: const Icon(AppIcons.categoriesAddCategory),
            onPressed: () {
              _addCategory(context, ref);
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation
              .centerFloat,
        );
      },
    );
  }

  void _selectType(WidgetRef ref, int index) {
    ref.read(categoriesControllerProvider.notifier)
        .selectType(index);
  }

  void _reorder(WidgetRef ref, TransactionCategory category, int oldIndex, int newIndex) {
    ref.read(categoriesControllerProvider.notifier)
        .reorder(category, oldIndex, newIndex);
  }

  void _addCategory(BuildContext context, WidgetRef ref) {
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
