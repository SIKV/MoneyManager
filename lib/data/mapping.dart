import 'package:moneymanager/domain/wallet.dart';

import '../domain/currency.dart';
import '../domain/transaction.dart';
import '../domain/transaction_category.dart';
import '../domain/transaction_type.dart';
import 'local/entity/wallet_entity.dart';
import 'local/entity/currency_entity.dart';
import 'local/entity/transaction_category_entity.dart';
import 'local/entity/transaction_entity.dart';
import 'local/entity/transaction_type_entity.dart';

/// Wallet

extension WalletEntityToDomain on WalletEntity {
  Wallet? toDomain() {
    final code = currency.code;
    final name = currency.name;
    final symbol = currency.symbol;

    if (code == null || name == null || symbol == null) {
      return null;
    }
    return Wallet(
      id: id,
      currency: Currency(
        code: code,
        name: name,
        symbol: symbol,
        emoji: currency.emoji,
      ),
    );
  }
}

extension DomainToWalletEntity on Wallet {
  WalletEntity toEntity() {
    return WalletEntity(
      id: id,
      currency: CurrencyEntity(
        code: currency.code,
        name: currency.name,
        symbol: currency.symbol,
        emoji: currency.emoji,
      ),
    );
  }
}

/// TransactionTypeEntity

extension TransactionTypeEntityToDomain on TransactionTypeEntity {
  TransactionType toDomain() {
    switch (this) {
      case TransactionTypeEntity.income:
        return TransactionType.income;
      case TransactionTypeEntity.expense:
        return TransactionType.expense;
    }
  }
}

extension DomainToTransactionTypeEntity on TransactionType {
  TransactionTypeEntity toEntity() {
    switch (this) {
      case TransactionType.income:
        return TransactionTypeEntity.income;
      case TransactionType.expense:
        return TransactionTypeEntity.expense;
    }
  }
}

/// TransactionCategory

extension TransactionCategoryEntityToDomain on TransactionCategoryEntity {
  TransactionCategory toDomain() {
    return TransactionCategory(
      id: id,
      createTimestamp: createTimestamp,
      type: type.toDomain(),
      title: title,
      emoji: emoji,
    );
  }
}

extension DomainToTransactionCategoryEntity on TransactionCategory {
  TransactionCategoryEntity toEntity() {
    return TransactionCategoryEntity(
      id: id,
      createTimestamp: createTimestamp,
      type: type.toEntity(),
      title: title,
      emoji: emoji,
    );
  }
}

/// Transaction

extension TransactionEntityToDomain on TransactionEntity {
  Transaction toDomain(TransactionCategory category, Currency currency) {
    return Transaction(
      id: id,
      createTimestamp: createTimestamp,
      type: type.toDomain(),
      category: category,
      currency: currency,
      amount: amount,
      note: note,
    );
  }
}

extension DomainToTransactionEntity on Transaction {
  TransactionEntity toEntity(int accountId) {
    return TransactionEntity(
      id: id,
      walletId: accountId,
      createTimestamp: createTimestamp,
      type: type.toEntity(),
      categoryId: category.id,
      amount: amount,
      note: note,
    );
  }
}
