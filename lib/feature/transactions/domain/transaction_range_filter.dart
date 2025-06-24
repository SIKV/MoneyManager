enum TransactionRangeFilter {
  day(1),
  week(2),
  month(3),
  year(4);

  const TransactionRangeFilter(this.id);

  final int id;
}
