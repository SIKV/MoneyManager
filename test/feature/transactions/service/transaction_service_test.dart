import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:moneymanager/common/currency_formatter.dart';
import 'package:moneymanager/data/repository/transactions_repository.dart';
import 'package:moneymanager/domain/currency.dart';
import 'package:moneymanager/domain/transaction.dart';
import 'package:moneymanager/domain/transaction_category.dart';
import 'package:moneymanager/domain/transaction_type.dart';
import 'package:moneymanager/feature/transactions/domain/transaction_filter.dart';
import 'package:moneymanager/feature/transactions/service/transaction_service.dart';

class TransactionsRepositoryMock extends Mock implements TransactionsRepository { }

class CurrencyFormatterMock extends Mock implements CurrencyFormatter { }

const transactionTypeMock = TransactionType.income;

const currencyMock = Currency(
  code: '',
  name: '',
  symbol: '',
  emoji: ''
);

void main() {
  setUpAll(() {
    registerFallbackValue(transactionTypeMock);
    registerFallbackValue(currencyMock);
  });

  late TransactionService service;
  late TransactionsRepositoryMock transactionsRepository;
  late CurrencyFormatterMock currencyFormatter;
  late StreamController<List<Transaction>> transactionsStreamController;

  setUp(() {
    transactionsRepository = TransactionsRepositoryMock();
    currencyFormatter = CurrencyFormatterMock();

    service = TransactionService(transactionsRepository, currencyFormatter);
    transactionsStreamController = StreamController<List<Transaction>>();

    when(() => transactionsRepository.getAll(
      type: any(named: 'type'),
      fromTimestamp: any(named: 'fromTimestamp'),
    )).thenAnswer((_) => transactionsStreamController.stream);

    when(() => currencyFormatter.format(
      currency: any(named: 'currency'),
      amount: any(named: 'amount'),
    )).thenReturn('formatted_amount');
  });

  test('getFiltered()', () async {
    // GIVEN
    const filter = TransactionFilter.monthIncome;

    final transactions = [
      // Section 1
      _createTransaction(DateTime(2023, 10, 1, 0, 0, 0, 0, 0)),
      _createTransaction(DateTime(2023, 10, 1, 0, 0, 0, 0, 0)),
      // Section 2
      _createTransaction(DateTime(2022, 5, 10, 0, 0, 0, 0, 0)),
    ];

    // WHEN
    transactionsStreamController.add(transactions);
    transactionsStreamController.close();

    final result = await service.getFiltered(filter).toList();

    // THEN
    verify(() =>
      transactionsRepository.getAll(
        type: TransactionType.income,
        fromTimestamp: any(named: 'fromTimestamp'),
      )
    ).called(1);

    expect(result.first.length, 5);
  });
}

Transaction _createTransaction(DateTime createDateTime) {
  return Transaction(
    id: 0,
    createTimestamp: createDateTime.millisecondsSinceEpoch,
    type: TransactionType.income,
    category: const TransactionCategory(
      id: 0,
      type: TransactionType.income,
      title: '',
      emoji: '',
    ),
    currency: const Currency(
      code: '',
      name: '',
      symbol: '',
      emoji: '',
    ),
    amount: 0.0,
    note: null,
  );
}
