import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/data/providers.dart';
import 'package:moneymanager/domain/transaction.dart';
import 'package:moneymanager/domain/transaction_category.dart';
import 'package:moneymanager/domain/transaction_type.dart';
import 'package:moneymanager/feature/transaction/domain/transaction_blueprint.dart';
import 'package:moneymanager/feature/transaction/domain/transaction_property.dart';
import 'package:moneymanager/feature/transaction/domain/ui_mode.dart';
import 'package:moneymanager/utils.dart';

import '../../../navigation/transaction_page_args.dart';
import '../domain/transaction_maker_state.dart';

final transactionMakerControllerProvider = AsyncNotifierProvider
    .autoDispose<TransactionMakerController, TransactionMakerState>(() {
      return TransactionMakerController();
});

class TransactionMakerController extends AutoDisposeAsyncNotifier<TransactionMakerState> {
  late UiMode _uiMode;
  late TransactionProperty _initialProperty;
  TransactionType? _initialType;
  int? _initialTransactionId;

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
    final transaction = await _createBlueprint(_initialTransactionId);

    return TransactionMakerState(
      uiMode: _uiMode,
      selectedProperty: _initialProperty,
      categories: await _getCategories(transaction.type),
      transaction: transaction,
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
            subcategory: transaction.subcategory,
            amount: transaction.amount,
            note: transaction.note,
          ),
        ));
  }

  Future<void> selectProperty(TransactionProperty value) async {
    _updateState((state) => state.copyWith(
      selectedProperty: value,
    ));
  }

  void setType(TransactionType type) {
    // TODO: Reset category.
    _updateState((state) => state.copyWith(
      transaction: state.transaction.copyWith(
        type: type,
      ),
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

  void processAmountKey(String key) {
    // TODO: Implement
  }

  void setNote(String? note) {
    _updateState((state) => state.copyWith(
      transaction: state.transaction.copyWith(
        note: note,
      ),
    ));
  }

  Future<void> save() async {
    final transactionsRepository = await ref.read(
        transactionsRepositoryProvider.future);

    final currentState = await future;

    transactionsRepository.addOrUpdate(
        Transaction(
          id: currentState.transaction.id,
          createTimestamp: currentState.transaction.createDateTime.millisecondsSinceEpoch,
          type: currentState.transaction.type,
          category: currentState.transaction.category!, // TODO:
          subcategory: currentState.transaction.subcategory,
          currency: currentState.transaction.currency,
          amount: currentState.transaction.amount,
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

  Future<TransactionBlueprint> _createBlueprint(int? transactionId) async {
    if (transactionId != null) {
      final transactionsRepository = await ref.watch(transactionsRepositoryProvider.future);
      final transaction = await transactionsRepository.getById(transactionId);

      if (transaction != null) {
        final DateTime createDateTime = DateTime
            .fromMillisecondsSinceEpoch(transaction.createTimestamp);

        return TransactionBlueprint(
          id: transaction.id,
          createDateTime: createDateTime,
          formattedCreateDateTime: formatDateTime(createDateTime),
          type: transaction.type,
          category: transaction.category,
          subcategory: transaction.subcategory,
          currency: transaction.currency,
          amount: transaction.amount,
          formattedAmount: '',
          // TODO: Init.
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
    final currentAccountProvider = await ref.watch(currentAccountProviderProvider.future);
    final currentAccount = await currentAccountProvider.getCurrentAccount();

    final createDateTime = DateTime.now();

    return TransactionBlueprint(
      id: generateUniqueInt(),
      createDateTime: createDateTime,
      formattedCreateDateTime: formatDateTime(createDateTime),
      type: _initialType ?? TransactionType.expense,
      category: null,
      subcategory: null,
      currency: currentAccount.currency,
      amount: 0,
      formattedAmount: '',
      // TODO: Init.
      note: null,
    );
  }
}
