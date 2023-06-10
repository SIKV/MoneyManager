import 'package:moneymanager/feature/transactions/domain/transaction_filter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _keyFilter = 'filter';

class FilterService {
  final SharedPreferences _prefs;

  final onFilterChanged = BehaviorSubject<TransactionFilter>();

  FilterService(this._prefs) {
    onFilterChanged.add(getFilter());
  }

  List<TransactionFilter> getAll() {
    return TransactionFilter.values;
  }

  void setFilter(TransactionFilter filter) {
    _prefs.setInt(_keyFilter, filter.index); // TODO: Do not use 'index'.

    onFilterChanged.add(filter);
  }

  TransactionFilter getFilter() {
    int filterIndex = _prefs.getInt(_keyFilter) ?? 0;
    return getAll()[filterIndex];
  }
}
