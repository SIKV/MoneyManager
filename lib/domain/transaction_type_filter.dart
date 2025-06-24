enum TransactionTypeFilter {
  income(1),
  expenses(2),
  all(3);

  const TransactionTypeFilter(this.id);

  final int id;
}
