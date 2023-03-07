import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneymanager/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localPreferencesProvider = Provider<LocalPreferences>((_) => LocalPreferences());

const _keyCurrentAccount = 'currentAccount';
const _keyTheme = 'theme';

class LocalPreferences {
  late final SharedPreferences _prefs;

  int? _currentAccountId;
  int? get currentAccountId => _currentAccountId;

  AppThemeType? _theme;
  AppThemeType? get theme =>_theme;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();

    _currentAccountId = _prefs.getInt(_keyCurrentAccount);

    final themeId = _prefs.getInt(_keyTheme);
    if (themeId != null) {
      _theme = AppThemeType.values
          .firstWhere((element) => element.id == themeId);
    }
  }

  void setCurrentAccount(int id) {
    _prefs.setInt(_keyCurrentAccount, id);
    _currentAccountId = id;
  }

  void setTheme(AppThemeType? theme) {
    if (theme != null) {
      _prefs.setInt(_keyTheme, theme.id);
    } else {
      _prefs.remove(_keyTheme);
    }
    _theme = theme;
  }
}
