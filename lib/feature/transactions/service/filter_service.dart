import 'package:moneymanager/domain/transaction_type_filter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/transaction_range_filter.dart';

const _keyRangeFilter = 'rangeFilter';
const _keyTypeFilter = 'typeFilter';

class FilterService {
  final SharedPreferences _prefs;

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
    // TODO: Do not use index.
    _prefs.setInt(_keyTypeFilter, type.index);
    onTypeChanged.add(type);
  }

  TransactionTypeFilter getType() {
    int index = _prefs.getInt(_keyTypeFilter) ?? 0;
    return getTypes()[index];
  }

  void setRange(TransactionRangeFilter range) {
    // TODO: Do not use index.
    _prefs.setInt(_keyRangeFilter, range.index);
    onRangeChanged.add(range);
  }

  TransactionRangeFilter getRange() {
    int index = _prefs.getInt(_keyRangeFilter) ?? 0;
    return getRanges()[index];
  }
}
