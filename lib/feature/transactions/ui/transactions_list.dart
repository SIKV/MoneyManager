import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/transactions/controller/transactions_list_controller.dart';
import 'package:moneymanager/feature/transactions/ui/transaction_item.dart';
import 'package:moneymanager/localizations.dart';
import 'package:moneymanager/theme/spacings.dart';
import '../../../navigation/routes.dart';
import '../../../navigation/transaction_page_args.dart';
import '../../../ui/widget/no_items.dart';
import '../domain/transaction_item_ui_model.dart';

class TransactionsList extends ConsumerWidget {
  const TransactionsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsListControllerProvider);

    return transactions.when(
      loading: () {
        return SliverToBoxAdapter(
          child: Container(),
        );
      },
      error: (_, __) {
        return SliverToBoxAdapter(
          child: Container(),
        );
      },
      data: (transactions) {
        if (transactions.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: NoItems(title: Strings.transactions_noItems.localized(context)),
            ),
          );
        } else {
          return SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              final item = transactions[index];

              if (item is TransactionUiModel) {
                return InkWell(
                  onTap: () {
                    _viewTransaction(context, item.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Spacings.four,
                      vertical: Spacings.three,
                    ),
                    child: TransactionItem(
                      transaction: item,
                    ),
                  ),
                );
              } else if (item is TransactionSectionUiModel) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: Spacings.two),
                  child: Center(
                    child: Text(item.title,
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall,
                    ),
                  ),
                );
              } else {
                throw ArgumentError('Unexpected item $item');
              }
            }, childCount: transactions.length),
          );
        }
      },
    );
  }

  void _viewTransaction(BuildContext context, int id) {
    Navigator.pushNamed(context, AppRoutes.viewTransaction,
      arguments: ViewTransactionPageArgs(
        id: id,
      ),
    );
  }
}
