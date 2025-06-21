enum TransactionTypeEntity {
  income,
  expense,
}

TransactionTypeEntity transactionTypeEntityFromString(String s) {
  switch (s) {
    case "income": return TransactionTypeEntity.income;
    case "expense": return TransactionTypeEntity.expense;
  }
  throw Exception("Cannot read TransactionTypeEntity.");
}
