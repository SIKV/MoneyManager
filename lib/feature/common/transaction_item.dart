import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/domain/transaction_type.dart';
import 'package:moneymanager/ui/extensions.dart';

import '../../../theme/spacings.dart';
import '../../../theme/theme.dart';
import '../../../theme/theme_manager.dart';
import 'domain/transaction_item_ui_model.dart';

class TransactionItem extends ConsumerWidget {
  final TransactionUiModel transaction;

  const TransactionItem({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTheme appTheme = ref.watch(appThemeManagerProvider);

    return Row(
      children: [
        transaction.getIcon(appTheme.colors),

        const SizedBox(width: Spacings.five),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(transaction.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (transaction.subtitle != null) ...[
                Padding(
                  padding: const EdgeInsets.only(top: Spacings.half),
                  child: Text(transaction.subtitle ?? '',
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(width: Spacings.five),

        Text(transaction.amount,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: transaction.type == TransactionType.income ? appTheme.colors.incomeTransaction : null,
          ),
        ),
      ],
    );
  }
}
