import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/theme/theme.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'domain/transaction_type.dart';

final localPreferencesProvider = Provider<LocalPreferences>((_) => LocalPreferences());

const _keyFirstLaunch = '_firstLaunch';
const _keyCurrentAccount = 'currentAccount';
const _keyTheme = 'theme';
const _keyIncomeCategoriesCustomOrder = 'incomeCategoriesCustomOrder';
const _keyExpenseCategoriesCustomOrder = 'expenseCategoriesCustomOrder';

// TODO: Refactor.
class LocalPreferences {
  late final SharedPreferences _prefs;

  int? _currentAccountId;
  int? get currentAccountId => _currentAccountId;

  final onCurrentAccountIdChanged = BehaviorSubject();

  AppThemeType? _theme;
  AppThemeType? get theme =>_theme;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();

    _currentAccountId = _prefs.getInt(_keyCurrentAccount);

    onCurrentAccountIdChanged.add(_currentAccountId);

    final themeId = _prefs.getInt(_keyTheme);
    if (themeId != null) {
      _theme = AppThemeType.values
          .firstWhere((element) => element.id == themeId);
    }
  }

  bool isFirstLaunch() {
    return _prefs.getBool(_keyFirstLaunch) ?? true;
  }

  void setFirstLaunch() {
    _prefs.setBool(_keyFirstLaunch, false);
  }

  void setCurrentAccount(int? id) {
    if (id == null) {
      _prefs.remove(_keyCurrentAccount);
    } else {
      _prefs.setInt(_keyCurrentAccount, id);
    }
    _currentAccountId = id;
    onCurrentAccountIdChanged.add(_currentAccountId);
  }

  void setTheme(AppThemeType? theme) {
    if (theme != null) {
      _prefs.setInt(_keyTheme, theme.id);
    } else {
      _prefs.remove(_keyTheme);
    }
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
