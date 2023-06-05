import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/common/currency_formatter.dart';
import 'package:moneymanager/data/providers.dart';
import 'package:moneymanager/domain/currency.dart';
import 'package:moneymanager/domain/transaction.dart';
import 'package:moneymanager/domain/transaction_category.dart';
import 'package:moneymanager/domain/transaction_type.dart';
import 'package:moneymanager/feature/transaction/domain/amount_key.dart';
import 'package:moneymanager/feature/transaction/domain/transaction_blueprint.dart';
import 'package:moneymanager/feature/transaction/domain/transaction_property.dart';
import 'package:moneymanager/feature/transaction/domain/ui_mode.dart';
import 'package:moneymanager/utils.dart';

import '../../../common/provider/current_account_provider.dart';
import '../../../navigation/transaction_page_args.dart';
import '../../../service/providers.dart';
import '../amount_key_processor.dart';
import '../domain/transaction_maker_state.dart';
import '../domain/validation_error.dart';

final transactionMakerControllerProvider = AsyncNotifierProvider
    .autoDispose<TransactionMakerController, TransactionMakerState>(() {
      return TransactionMakerController();
});

class TransactionMakerController extends AutoDisposeAsyncNotifier<TransactionMakerState> {
  late UiMode _uiMode;
  late TransactionProperty _initialProperty;
  TransactionType? _initialType;
  int? _initialTransactionId;

  final AmountKeyProcessor amountKeyProcessor = AmountKeyProcessor();

  void initWithArgs(TransactionPageArgs args) {
    if (args is AddTransactionPageArgs) {
      _uiMode = UiMode.add;
      _initialProperty = TransactionProperty.category;
      _initialType = args.type;
    } else if (args is ViewTransactionPageArgs) {
      _uiMode = UiMode.view;
      _initialProperty = TransactionProperty.note;
      _initialTransactionId = args.id;
    } else {
      throw ArgumentError('Unexpected args: $args');
    }
    ref.invalidateSelf();
  }

  @override
  FutureOr<TransactionMakerState> build() async {
    // Rebuild when the current account changed.
    ref.watch(currentAccountProvider);

    // TODO Do not reset all the properties when the current account changed.

    final transaction = await _createBlueprint(_initialTransactionId);

    return TransactionMakerState(
      uiMode: _uiMode,
      selectedProperty: _initialProperty,
      categories: await _getCategories(transaction.type),
      transaction: transaction,
      validationError: null,
      transactionSaved: false,
    );
  }

  void setTransaction(Transaction transaction) {
    _updateState((state) =>
        state.copyWith(
          transaction: state.transaction.copyWith(
            id: transaction.id,
            createDateTime: DateTime.fromMillisecondsSinceEpoch(transaction.createTimestamp),
            type: transaction.type,
            category: transaction.category,
            amount: transaction.amount.toString(),
            note: transaction.note,
          ),
        ));
  }

  Future<void> selectProperty(TransactionProperty value) async {
    _updateState((state) => state.copyWith(
      selectedProperty: value,
    ));
  }

  void setType(TransactionType type) async {
    final categories = await _getCategories(type);

    _updateState((state) => state.copyWith(
      transaction: state.transaction.copyWith(
        type: type,
        category: null,
      ),
      categories: categories,
    ));
  }

  void setCreationDate(DateTime date) async {
    final currentState = await future;
    DateTime createDateTime = currentState.transaction.createDateTime;

    DateTime updatedCreateDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      createDateTime.hour,
      createDateTime.minute,
      0, 0, 0,
    );

    _updateState((state) => state.copyWith(
      transaction: state.transaction.copyWith(
        createDateTime: updatedCreateDateTime,
        formattedCreateDateTime: formatDateTime(updatedCreateDateTime),
      )
    ));
  }

  void setCreationTime(DateTime time) async {
    final currentState = await future;
    DateTime createDateTime = currentState.transaction.createDateTime;

    DateTime updatedCreateDateTime = DateTime(
      createDateTime.year,
      createDateTime.month,
      createDateTime.day,
      time.hour,
      time.minute,
      0, 0, 0,
    );

    _updateState((state) => state.copyWith(
        transaction: state.transaction.copyWith(
          createDateTime: updatedCreateDateTime,
          formattedCreateDateTime: formatDateTime(updatedCreateDateTime),
        )
    ));
  }

  Future<void> setCategory(TransactionCategory category) async {
    _updateState((state) => state.copyWith(
      transaction: state.transaction.copyWith(
        category: category,
      ),
    ));
  }

  void processAmountKey(AmountKey key) async {
    final currentState = await future;

    String amount = amountKeyProcessor.processAmountKey(
      currentAmount: currentState.transaction.amount,
      key: key,
      onCalculatorPressed: () {
        // TODO: Implement.
      },
      onDonePressed: () {
        // TODO: Implement.
      },
    );

    _updateState((state) => state.copyWith(
      transaction: state.transaction.copyWith(
        amount: amount,
        formattedAmount: _formatAmount(amount, currentState.transaction.currency),
      ),
    ));
  }

  void setNote(String? note) {
    _updateState((state) => state.copyWith(
      transaction: state.transaction.copyWith(
        note: note,
      ),
    ));
  }

  void resetValidationError() {
    _updateState((state) => state.copyWith(
      validationError: null,
    ));
  }

  Future<void> save() async {
    final transactionsRepository = await ref.read(
        transactionsRepositoryProvider.future);

    final currentState = await future;

    final category = currentState.transaction.category;
    if (category == null) {
      _updateState((state) => state.copyWith(
        validationError: ValidationError.emptyCategory,
      ));
      return;
    }

    final amount = double.tryParse(currentState.transaction.amount);
    if (amount == null) {
      _updateState((state) => state.copyWith(
        validationError: ValidationError.emptyAmount,
      ));
      return;
    }

    transactionsRepository.addOrUpdate(
        Transaction(
          id: currentState.transaction.id,
          createTimestamp: currentState.transaction.createDateTime.millisecondsSinceEpoch,
          type: currentState.transaction.type,
          category: category,
          currency: currentState.transaction.currency,
          amount: amount,
          note: currentState.transaction.note,
        )
    );

    _updateState((state) => state.copyWith(
      transactionSaved: true,
    ));
  }

  Future<void> _updateState(TransactionMakerState Function(TransactionMakerState state) update) async {
    final currentState = await future;
    state = AsyncValue.data(update(currentState));
  }

  Future<List<TransactionCategory>> _getCategories(TransactionType type) async {
    final categoriesRepository = await ref.watch(categoriesRepositoryProvider.future);
    return await categoriesRepository.getAll(type);
  }

  String _formatAmount(String amount, Currency currency) {
    final currencyFormatter = ref.read(currencyFormatterProvider);
    double amountNumber = amount.isEmpty ? 0 : double.parse(amount);

    return currencyFormatter.format(
      currency: currency,
      amount: amountNumber,
      alwaysShowDecimalPoint: amountKeyProcessor.hasDecimalPoint(amount),
    );
  }

  Future<TransactionBlueprint> _createBlueprint(int? transactionId) async {
    if (transactionId != null) {
      final transactionsRepository = await ref.watch(transactionsRepositoryProvider.future);
      final transaction = await transactionsRepository.getById(transactionId);

      if (transaction != null) {
        final DateTime createDateTime = DateTime
            .fromMillisecondsSinceEpoch(transaction.createTimestamp);

        final amount = transaction.amount.toString();

        return TransactionBlueprint(
          id: transaction.id,
          createDateTime: createDateTime,
          formattedCreateDateTime: formatDateTime(createDateTime),
          type: transaction.type,
          category: transaction.category,
          currency: transaction.currency,
          amount: amount,
          formattedAmount: _formatAmount(amount, transaction.currency),
          note: transaction.note,
        );
      } else {
        return _createDefaultBlueprint();
      }
    } else {
      return _createDefaultBlueprint();
    }
  }

  Future<TransactionBlueprint> _createDefaultBlueprint() async {
    final currentAccountService = await ref.watch(currentAccountServiceProvider.future);
    final currentAccount = await currentAccountService.getCurrentAccount();

    final createDateTime = DateTime.now();
    const amount = '';

    return TransactionBlueprint(
      id: generateUniqueInt(),
      createDateTime: createDateTime,
      formattedCreateDateTime: formatDateTime(createDateTime),
      type: _initialType ?? TransactionType.expense,
      category: null,
      currency: currentAccount.currency,
      amount: amount,
      formattedAmount: _formatAmount(amount, currentAccount.currency),
      note: null,
    );
  }
}
