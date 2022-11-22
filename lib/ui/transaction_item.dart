import 'package:flutter/material.dart';

import '../theme/spacings.dart';
import '../theme/theme.dart';

enum TransactionItemType {
  income, outcome
}

class TransactionItem extends StatelessWidget {
  final TransactionItemType type;
  final IconData icon;
  final String title;
  final String? subtitle;
  final double amount;
  final VoidCallback onPressed;

  const TransactionItem({
    Key? key,
    required this.type,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.amount,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String amountString;
    TextStyle amountStyle;

    switch (type) {
      case TransactionItemType.income:
        amountString = amount.toInt().toString(); // TODO Add formatting.
        amountStyle = TextStyles.income;
        break;
      case TransactionItemType.outcome:
        amountString = '-${amount.toInt()}'; // TODO Add formatting.
        amountStyle = TextStyles.outcome;
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon),
        const SizedBox(width: Spacings.four),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
              style: TextStyles.itemNormal,
            ),
            const SizedBox(height: Spacings.half),
            if (subtitle != null) Text(subtitle!,
              style: TextStyles.subtitleNormal,
            ),
          ],
        ),
        const Spacer(),
        Text(amountString,
          style: amountStyle,
        ),
      ],
    );
  }
}
