import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_category.dart';
import 'package:moneymanager/domain/transaction_type.dart';
import 'package:moneymanager/feature/categories/category_maker.dart';
import 'package:moneymanager/feature/categories/domain/category_maker_args.dart';
import 'package:moneymanager/feature/categories/ui/categories_list.dart';
import 'package:moneymanager/theme/icons.dart';
import 'package:moneymanager/theme/spacings.dart';

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
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar.medium(
                title: Text(AppLocalizations.of(context)!.categories_pageTitle),
                actions: [
                  IconButton(
                    onPressed: () { },
                    icon: const Icon(Icons.more_vert_rounded),
                  )
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: Spacings.four,
                    right: Spacings.four,
                    bottom: Spacings.four,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CupertinoSlidingSegmentedControl<TransactionType>(
                      groupValue: state.selectedType,
                      onValueChanged: (transactionType) {
                        _selectType(ref, transactionType);
                      },
                      children: <TransactionType, Widget>{
                        TransactionType.income: Text(AppLocalizations.of(context)!.income),
                        TransactionType.expense: Text(AppLocalizations.of(context)!.expense),
                      },
                    ),
                  ),
                ),
              ),
              CategoriesList(
                categories: state.categories,
                onReorder: (oldIndex, newIndex) {
                  _reorder(ref, state.categories[oldIndex], oldIndex, newIndex);
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            label: Text(AppLocalizations.of(context)!.addCategory),
            icon: const Icon(AppIcons.categoriesAddCategory),
            onPressed: () {
              _addCategory(context, state.selectedType);
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }

  void _selectType(WidgetRef ref, TransactionType? type) {
    if (type != null) {
      ref.read(categoriesControllerProvider.notifier)
          .selectType(type);
    }
  }

  void _reorder(WidgetRef ref, TransactionCategory category, int oldIndex, int newIndex) {
    ref.read(categoriesControllerProvider.notifier)
        .reorder(category, oldIndex, newIndex);
  }

  void _addCategory(BuildContext context, TransactionType transactionType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) => CategoryMaker(
        args: AddCategoryMakerArgs(
          type: transactionType,
        ),
      ),
    );
  }
}
