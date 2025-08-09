import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_category.dart';
import 'package:moneymanager/feature/categories/domain/category_maker_args.dart';
import 'package:moneymanager/feature/transaction/domain/transaction_property.dart';
import 'package:moneymanager/ui/extensions.dart';
import 'package:moneymanager/ui/widget/no_items.dart';

import '../../../domain/transaction_type.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/spacings.dart';
import '../../../theme/theme.dart';
import '../../../theme/theme_manager.dart';
import '../../categories/category_maker.dart';
import '../controller/transaction_maker_controller.dart';

class CategorySelector extends ConsumerWidget {
  const CategorySelector({super.key});

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
                  childAspectRatio: 3,
                ),
                itemCount: state.categories.length,
                padding: const EdgeInsets.only(bottom: Spacings.seven),
                itemBuilder: (context, index) {
                  final c = state.categories[index];
                  return _CategoryItem(
                    onPressed: () => _selectCategory(c, ref),
                    icon: c.getIcon(appTheme.colors),
                    title: c.title,
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

  void _selectCategory(TransactionCategory category, WidgetRef ref) {
    final controller = ref.read(transactionMakerControllerProvider.notifier);
    controller.setCategory(category).whenComplete(() =>
        controller.selectProperty(TransactionProperty.amount)
    );
  }
}

class _CategoryItem extends ConsumerWidget {
  final VoidCallback? onPressed;
  final Widget? icon;
  final String title;

  const _CategoryItem({
    required this.onPressed,
    this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(Spacings.two),
      decoration: BoxDecoration(
        border: Border.all(width: 0.1),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.onSurface,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) icon!,
            if (icon != null) const SizedBox(width: Spacings.two),
            Expanded(
              child: AutoSizeText(title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoCategories extends StatelessWidget {
  final VoidCallback onAddCategoryPressed;

  const _NoCategories({
    required this.onAddCategoryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NoItems(
          title: AppLocalizations.of(context)!.transactionPage_noCategories,
        ),
        const SizedBox(height: Spacings.two),
        TextButton(
          onPressed: onAddCategoryPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add),
              const SizedBox(width: Spacings.two),
              Text(AppLocalizations.of(context)!.transactionPage_addCategoryButton),
            ],
          ),
        ),
      ],
    );
  }
}
