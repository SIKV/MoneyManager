import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/theme/theme.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'domain/transaction_type.dart';

final localPreferencesProvider = Provider<LocalPreferences>((_) => LocalPreferences());

const _keyFirstLaunch = 'firstLaunch';
const _keyCurrentWallet = 'currentWallet';
const _keyTheme = 'theme';
const _keyIncomeCategoriesCustomOrder = 'incomeCategoriesCustomOrder';
const _keyExpenseCategoriesCustomOrder = 'expenseCategoriesCustomOrder';

// TODO: Split to separate services?
class LocalPreferences {
  late final SharedPreferences _prefs;

  int? _currentWalletId;
  int? get currentWalletId => _currentWalletId;

  final onCurrentWalletIdChanged = BehaviorSubject();

  late AppThemeType? _theme;
  AppThemeType? get theme =>_theme;

  // IMPORTANT. This has to be called in main() before runApp().
  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();

    _currentWalletId = _prefs.getInt(_keyCurrentWallet);
    onCurrentWalletIdChanged.add(_currentWalletId);

    final themeId = _prefs.getInt(_keyTheme);
    if (themeId != null) {
      _theme = AppThemeType.values
          .firstWhere((element) => element.id == themeId);
    } else {
      // Use device theme. See AppThemeManager for more details.
      _theme = null;
    }
  }

  bool isFirstLaunch() {
    return _prefs.getBool(_keyFirstLaunch) ?? true;
  }

  void setFirstLaunch() {
    _prefs.setBool(_keyFirstLaunch, false);
  }

  void setCurrentWallet(int? id) {
    if (id == null) {
      _prefs.remove(_keyCurrentWallet);
    } else {
      _prefs.setInt(_keyCurrentWallet, id);
    }
    _currentWalletId = id;
    onCurrentWalletIdChanged.add(_currentWalletId);
  }

  void setTheme(AppThemeType theme) {
    _prefs.setInt(_keyTheme, theme.id);
    _theme = theme;
  }

  List<String> getCategoriesCustomOrder(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return _prefs.getStringList(_keyIncomeCategoriesCustomOrder) ?? [];
      case TransactionType.expense:
        return _prefs.getStringList(_keyExpenseCategoriesCustomOrder) ?? [];
    }
  }

  void setCategoriesCustomOrder(List<String> order, TransactionType type) {
    switch (type) {
      case TransactionType.income:
        _prefs.setStringList(_keyIncomeCategoriesCustomOrder, order);
        break;
      case TransactionType.expense:
        _prefs.setStringList(_keyExpenseCategoriesCustomOrder, order);
        break;
    }
  }
}
