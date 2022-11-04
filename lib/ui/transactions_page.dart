import 'package:flutter/material.dart';

import 'header_content_page.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HeaderContentPage(
      headerColor: Colors.lightBlue.shade200,
      primaryTitle: '\$25.390.50',
      primarySubtitle: 'This month expenses',
      actionIcon: Icons.tune,
      content: const Center(
        child: Text('Transactions'),
      ),
    );
  }
}
