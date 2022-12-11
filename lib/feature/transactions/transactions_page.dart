import 'package:flutter/material.dart';
import 'package:moneymanager/theme/icons.dart';
import 'package:moneymanager/feature/transactions/transaction_item.dart';

import '../../theme/spacings.dart';
import '../../theme/styles.dart';
import '../../ui/widget/header_content_page.dart';
import 'transactions_header_settings.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HeaderContentPage(
      headerColor: Colors.lightBlue.shade200,
      primaryTitle: '\$25.390.50',
      primarySubtitle: 'This month expenses',
      actionIcon: AppIcons.transactionsHeaderSettings,
      onActionPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (context) {
            return const TransactionsHeaderSettings();
          },
        );
      },
      content: ListView.builder(
        itemCount: 25,
        padding: const EdgeInsets.all(Spacings.four),
        itemBuilder: (context, index) {
          return (index % 10 != 0) ? _item() : _sectionItem();
        },
      ),
    );
  }

  Widget _item() {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacings.three),
      child: TransactionItem(
        type: TransactionItemType.outcome,
        icon: Icons.fastfood,
        title: 'Food',
        subtitle: 'KFC',
        amount: 499,
        onPressed: () {},
      ),
    );
  }

  Widget _sectionItem() {
    return const Center(
      child: Text('Today',
        style: TextStyles.itemSectionNormal,
      ),
    );
  }
}
