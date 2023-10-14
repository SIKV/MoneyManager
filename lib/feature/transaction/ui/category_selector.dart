import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_category.dart';
import 'package:moneymanager/feature/categories/domain/category_maker_args.dart';
import 'package:moneymanager/feature/transaction/domain/transaction_property.dart';
import 'package:moneymanager/ui/extensions.dart';
import 'package:moneymanager/ui/widget/no_items.dart';

import '../../../domain/transaction_type.dart';
import '../../../theme/spacings.dart';
import '../../../theme/theme.dart';
import '../../../theme/theme_manager.dart';
import '../../categories/category_maker.dart';
import '../controller/transaction_maker_controller.dart';

class CategorySelector extends ConsumerWidget {
  const CategorySelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);
    final state = ref.watch(transactionMakerControllerProvider);

    return state.whenOrNull(
        data: (state) {
          if (state.categories.isEmpty) {
            return Center(
              child: _NoCategories(
                onAddCategoryPressed: () =>
                    _addCategory(context, state.transaction.type),
              ),
            );
          } else {
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                ),
                itemCount: state.categories.length,
                itemBuilder: (context, index) {
                  final c = state.categories[index];
                  return ListTile(
                    leading: c.getIcon(appTheme.colors),
                    title: Text(c.title),
                    onTap: () => _categoryPressed(c, ref),
                  );
                }
            );
          }
        }
    ) ?? Container();
  }

  void _addCategory(BuildContext context, TransactionType type) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        builder: (context) {
          return CategoryMaker(
            args: AddCategoryMakerArgs(
              type: type,
            ),
          );
        }
    );
  }

  void _categoryPressed(TransactionCategory category, WidgetRef ref) {
    final controller = ref.read(transactionMakerControllerProvider.notifier);
    controller.setCategory(category).whenComplete(() =>
        controller.selectProperty(TransactionProperty.amount)
    );
  }
}

class _NoCategories extends StatelessWidget {
  final VoidCallback onAddCategoryPressed;

  const _NoCategories({
    Key? key,
    required this.onAddCategoryPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NoItems(
          title: AppLocalizations.of(context)!.categories_noItems,
        ),
        const SizedBox(height: Spacings.two),
        TextButton(
          onPressed: onAddCategoryPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add),
              const SizedBox(width: Spacings.two),
              Text(AppLocalizations.of(context)!.addCategory),
            ],
          ),
        ),
      ],
    );
  }
}
