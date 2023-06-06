import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/common/currency_formatter.dart';
import 'package:moneymanager/data/providers.dart';

import '../domain/transaction_item_ui_model.dart';

final transactionsListProvider = StreamProvider((ref) {
  final transactionsRepository = ref.watch(transactionsRepositoryProvider).value;
  final currencyFormatter = ref.watch(currencyFormatterProvider);

  final transactions = transactionsRepository?.getAll()
      .map((list) {
        return list.map((it) {
          return TransactionUiModel(
            id: it.id,
            emoji: it.category.emoji,
            title: it.category.title,
            amount: currencyFormatter.format(
              currency: it.currency,
              amount: it.amount,
            ),
          );
        }).toList();
      });

  return transactions ?? const Stream.empty();
});
