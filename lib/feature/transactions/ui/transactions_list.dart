import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/feature/transactions/provider/transactions_list_provider.dart';
import 'package:moneymanager/feature/transactions/ui/transaction_item.dart';
import 'package:moneymanager/theme/spacings.dart';
import 'package:moneymanager/ui/widget/small_section_text.dart';

import '../../../navigation/routes.dart';
import '../../../navigation/transaction_page_args.dart';
import '../../../ui/widget/no_items.dart';
import '../../../ui/widget/something_went_wrong.dart';
import '../domain/transaction_item_ui_model.dart';

class TransactionsList extends ConsumerWidget {
  const TransactionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsListProvider);

    return transactions.when(
      loading: () {
        return const SliverFillRemaining(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (_, __) {
        return const SliverFillRemaining(
          child: Center(
            child: SomethingWentWrong(),
          ),
        );
      },
      data: (transactions) {
        if (transactions.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: NoItems(title: AppLocalizations.of(context)!.transactionsPage_noItems),
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
                    child: SmallSectionText(item.title),
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
