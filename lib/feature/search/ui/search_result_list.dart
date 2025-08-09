import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/theme/spacings.dart';

import '../../../l10n/app_localizations.dart';
import '../../../navigation/routes.dart';
import '../../../navigation/transaction_page_args.dart';
import '../../../ui/widget/no_items.dart';
import '../../../ui/widget/something_went_wrong.dart';
import '../../common/transaction_item.dart';
import '../controller/search_controller.dart';

class SearchResultList extends ConsumerWidget {
  const SearchResultList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchControllerProvider);

    return state.when(
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
      data: (state) {
        if (state.didSearch && state.searchResult.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: NoItems(title: AppLocalizations.of(context)!.searchPage_noResults),
            ),
          );
        } else {
          return SliverList(
            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              final item = state.searchResult[index];

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
            }, childCount: state.searchResult.length),
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
