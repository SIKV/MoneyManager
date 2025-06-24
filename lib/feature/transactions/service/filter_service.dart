import 'package:collection/collection.dart';
import 'package:moneymanager/domain/transaction_type_filter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/transaction_range_filter.dart';

const _keyRangeFilter = 'transactionsRangeFilter';
const _keyTypeFilter = 'transactionsTypeFilter';

class FilterService {
  final SharedPreferences _prefs;

  final defaultType = TransactionTypeFilter.all;
  final defaultRange = TransactionRangeFilter.month;

  final onTypeChanged = BehaviorSubject<TransactionTypeFilter>();
  final onRangeChanged = BehaviorSubject<TransactionRangeFilter>();

  FilterService(this._prefs) {
    onTypeChanged.add(getType());
    onRangeChanged.add(getRange());
  }

  List<TransactionTypeFilter> getTypes() {
    return TransactionTypeFilter.values;
  }

  List<TransactionRangeFilter> getRanges() {
    return TransactionRangeFilter.values;
  }

  void setType(TransactionTypeFilter type) {
    _prefs.setInt(_keyTypeFilter, type.id);
    onTypeChanged.add(type);
  }

  TransactionTypeFilter getType() {
    int id = _prefs.getInt(_keyTypeFilter) ?? defaultType.id;
    return getTypes().firstWhereOrNull((e) => e.id == id) ?? defaultType;
  }

  void setRange(TransactionRangeFilter range) {
    _prefs.setInt(_keyRangeFilter, range.id);
    onRangeChanged.add(range);
  }

  TransactionRangeFilter getRange() {
    int id = _prefs.getInt(_keyRangeFilter) ?? defaultRange.id;
    return getRanges().firstWhereOrNull((e) => e.id == id) ?? defaultRange;
  }
}
