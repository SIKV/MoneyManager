import 'package:moneymanager/feature/transactions/domain/transaction_filter.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _keyFilter = 'filter';

class FilterService {
  final SharedPreferences _prefs;

  FilterService(this._prefs);

  List<TransactionFilter> getAll() {
    return TransactionFilter.values;
  }

  void setFilter(TransactionFilter filter) {
    _prefs.setInt(_keyFilter, filter.index); // TODO: Do not use 'index'.
  }

  TransactionFilter getFilter() {
    int filterIndex = _prefs.getInt(_keyFilter) ?? 0;
    return getAll()[filterIndex];
  }
}
