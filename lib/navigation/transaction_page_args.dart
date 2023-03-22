import 'package:flutter/foundation.dart';
import 'package:moneymanager/domain/transaction_type.dart';

@immutable
abstract class TransactionPageArgs {
  const TransactionPageArgs();
}

@immutable
class AddTransactionPageArgs extends TransactionPageArgs {
  final TransactionType type;

  const AddTransactionPageArgs({
    required this.type,
  });
}

@immutable
class ViewTransactionPageArgs extends TransactionPageArgs {
  final int id;

  const ViewTransactionPageArgs({
    required this.id,
  });
}
