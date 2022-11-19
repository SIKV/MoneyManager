import 'package:flutter/material.dart';

import 'header_content_page.dart';
import 'transactions_header_settings.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HeaderContentPage(
      headerColor: Colors.lightBlue.shade200,
      primaryTitle: '\$25.390.50',
      primarySubtitle: 'This month expenses',
      actionIcon: Icons.tune,
      onActionPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return const TransactionsHeaderSettings();
          },
        );
      },
      content: const Center(
        child: Text('Transactions'),
      ),
    );
  }
}
