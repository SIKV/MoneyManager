import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/ui/extensions.dart';

import '../../../theme/spacings.dart';
import '../../../theme/theme.dart';
import '../../../theme/theme_manager.dart';
import '../domain/transaction_item_ui_model.dart';

class TransactionItem extends ConsumerWidget {
  final TransactionUiModel transaction;

  const TransactionItem({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        transaction.getIcon(appTheme.colors),
        const SizedBox(width: Spacings.five),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(transaction.title,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            if (transaction.subtitle != null) ...[
              Padding(
                padding: const EdgeInsets.only(top: Spacings.half),
                child: Text(transaction.subtitle ?? '',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ],
        ),
        const Spacer(),
        Text(transaction.amount,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
