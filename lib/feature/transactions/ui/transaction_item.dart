import 'package:flutter/material.dart';

import '../../../theme/spacings.dart';
import '../domain/transaction_item_ui_model.dart';

class TransactionItem extends StatelessWidget {
  final TransactionUiModel transaction;

  const TransactionItem({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(transaction.emoji ?? '',
          style: const TextStyle(
            fontSize: 21,
          ),
        ),
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
