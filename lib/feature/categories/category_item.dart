import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_category.dart';
import 'package:moneymanager/theme/icons.dart';
import 'package:moneymanager/theme/radius.dart';
import 'package:moneymanager/theme/spacings.dart';
import 'package:moneymanager/theme/theme.dart';

const _emojiSize = 24.0;
const _subcategorySeparator = ', ';

class CategoryItem extends ConsumerWidget {
  final TransactionCategory category;
  final VoidCallback onPressed;

  const CategoryItem({
    Key? key,
    required this.category,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(appThemeManagerProvider);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppRadius.three),
      child: Container(
        padding: const EdgeInsets.all(Spacings.four),
        decoration: BoxDecoration(
          color: appTheme.colors.itemTranslucentBackground,
          borderRadius: BorderRadius.circular(AppRadius.three),
        ),
        child: Row(
          children: [
            Text(category.emoji ?? '',
              style: const TextStyle(
                fontSize: _emojiSize,
              ),
            ),
            const SizedBox(width: Spacings.five),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    category.subcategories.map((it) => it.title).join(_subcategorySeparator),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Icon(AppIcons.categoryItemDrag),
          ],
        ),
      ),
    );
  }
}
