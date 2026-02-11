import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_category.dart';
import 'package:moneymanager/domain/transaction_type.dart';
import 'package:moneymanager/feature/categories/category_maker.dart';
import 'package:moneymanager/feature/categories/domain/categories_state.dart';
import 'package:moneymanager/feature/categories/domain/category_maker_args.dart';
import 'package:moneymanager/feature/categories/ui/categories_list.dart';
import 'package:moneymanager/theme/spacings.dart';

import '../../l10n/app_localizations.dart';
import '../common/transaction_type_selector.dart';
import 'controller/categories_controller.dart';

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({super.key});

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
                title: Text(AppLocalizations.of(context)!.categoriesPage_title),
                actions: _getAppBarActions(context, ref, state),
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
                    child: TransactionTypeSelector(
                      selectedType: state.selectedType,
                      onSelectedTypeChanged: (transactionType) {
                        _selectType(ref, transactionType);
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
            label: Text(AppLocalizations.of(context)!.categoriesPage_addButton),
            icon: const Icon(Icons.add),
            onPressed: () {
              _addCategory(context, state.selectedType);
            },
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }

  List<Widget> _getAppBarActions(BuildContext context, WidgetRef ref, CategoriesState state) {
    String text = state.showArchived
        ? AppLocalizations.of(context)!.categoriesPage_hideArchivedMenuItem
        : AppLocalizations.of(context)!.categoriesPage_showArchivedMenuItem;

    return [
      PopupMenuButton<void Function()>(
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: () {
                ref.read(categoriesControllerProvider.notifier)
                    .setShowArchived(!state.showArchived);
              },
              child: Text(text),
            ),
          ];
        },
        onSelected: (fn) => fn(),
      )
    ];
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
      routeSettings: const RouteSettings(name: '/categories-add-category-modal'),
      builder: (context) => CategoryMaker(
        args: AddCategoryMakerArgs(
          type: transactionType,
        ),
      ),
    );
  }
}
