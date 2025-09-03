import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_category.dart';
import 'package:moneymanager/theme/radius.dart';
import 'package:moneymanager/theme/spacings.dart';
import 'package:moneymanager/ui/extensions.dart';

import '../../../theme/theme_manager.dart';

class CategoryItem extends ConsumerWidget {
  final TransactionCategory category;
  final int index;
  final VoidCallback onPressed;

  const CategoryItem({
    super.key,
    required this.category,
    required this.index,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(appThemeManagerProvider);
    final opacity = category.archived ? 0.5 : 1.0;

    return Opacity(
      opacity: opacity,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.two),
        child: Container(
          padding: const EdgeInsets.all(Spacings.four),
          decoration: BoxDecoration(
            color: appTheme.colors.itemTranslucentBackground,
            borderRadius: BorderRadius.circular(AppRadius.two),
          ),
          child: Row(
            children: [
              category.getIcon(appTheme.colors),
              const SizedBox(width: Spacings.five),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Spacings.two),
              ReorderableDragStartListener(
                index: index,
                child: const Icon(Icons.drag_handle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
