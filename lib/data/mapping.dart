import 'package:moneymanager/domain/account.dart';

import '../domain/currency.dart';
import '../domain/transaction.dart';
import '../domain/transaction_category.dart';
import '../domain/transaction_subcategory.dart';
import '../domain/transaction_type.dart';
import 'local/entity/account_entity.dart';
import 'local/entity/currency_entity.dart';
import 'local/entity/transaction_category_entity.dart';
import 'local/entity/transaction_entity.dart';
import 'local/entity/transaction_subcategory_entity.dart';
import 'local/entity/transaction_type_entity.dart';

/// Account

extension AccountEntityToDomain on AccountEntity {
  Account? toDomain() {
    final code = currency.code;
    final name = currency.name;
    final symbol = currency.symbol;

    if (code == null || name == null || symbol == null) {
      return null;
    }
    return Account(
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

extension DomainToAccountEntity on Account {
  AccountEntity toEntity() {
    return AccountEntity(
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

/// TransactionSubcategory

extension TransactionSubcategoryEntityToDomain on TransactionSubcategoryEntity {
  TransactionSubcategory? toDomain() {
    final id = this.id;
    final title = this.title;

    if (id == null || title == null) {
      return null;
    } else {
      return TransactionSubcategory(
        id: id,
        title: title,
      );
    }
  }
}

extension DomainToTransactionSubcategoryEntity on TransactionSubcategory {
  TransactionSubcategoryEntity toEntity() {
    return TransactionSubcategoryEntity(
      id: id,
      title: title,
    );
  }
}

/// TransactionCategory

extension TransactionCategoryEntityToDomain on TransactionCategoryEntity {
  TransactionCategory toDomain() {
    return TransactionCategory(
      id: id,
      type: type.toDomain(),
      title: title,
      emoji: emoji,
      subcategories: subcategories.map((it) => it.toDomain())
          .whereType<TransactionSubcategory>()
          .toList(),
    );
  }
}

extension DomainToTransactionCategoryEntity on TransactionCategory {
  TransactionCategoryEntity toEntity() {
    return TransactionCategoryEntity(
      id: id,
      type: type.toEntity(),
      title: title,
      emoji: emoji,
      subcategories: subcategories.map((it) => it.toEntity()).toList(),
    );
  }
}

/// Transaction

extension TransactionEntityToDomain on TransactionEntity {
  Transaction toDomain(TransactionCategory category, TransactionSubcategory? subcategory, Currency currency) {
    return Transaction(
      id: id,
      createTimestamp: createTimestamp,
      type: type.toDomain(),
      category: category,
      subcategory: subcategory,
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
      accountId: accountId,
      createTimestamp: createTimestamp,
      type: type.toEntity(),
      categoryId: category.id,
      subcategoryId: subcategory?.id,
      amount: amount,
      note: note,
    );
  }
}
